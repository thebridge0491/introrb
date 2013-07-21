#!/usr/bin/env ruby -w

require 'English'
require 'json'
require 'erb'
require 'fileutils'

SCRIPTPARENT = File.dirname(File.absolute_path(__FILE__))

def regex_checks(nameX, config={})
	if (config.has_key?(:parentregex) and !(%r"#{config[:parentregex]}".match(config.fetch(:parent, ''))))
		puts "ERROR: Parent regex match failure (%r'#{config[:parentregex]}'.match(#{config.fetch(:parent, '')})) for package (#{nameX})."
		exit 1
	end
	if (config.has_key?(:projectregex) and !(%r"#{config[:projectregex]}".match(config[:project])))
		puts "ERROR: Project regex match failure (%r'#{config[:projectregex]}'.match(#{config[:project]})) for package (#{nameX})."
		exit 1
	end
end

def config_data(datajson, kvset={})
	cfg = {}
	initdata = JSON.parse(File.read(datajson), {:symbolize_names => true}
		).merge(:date => Time.new.strftime('%Y-%m-%d'))
	
	cfg = cfg.merge(initdata)
	cfg = cfg.merge(kvset)
	cfg = cfg.merge(
		:author => kvset[:author] ? kvset[:author] : cfg[:repoacct],
		:email => kvset[:email] ? kvset[:email] : "#{cfg[:repoacct]}-codelab@yahoo.com"
	)
	
	namespace = "#{cfg[:groupid] ? cfg[:groupid] + '.' : ''}#{cfg.fetch(:parent, '')}.#{cfg[:project]}"
	name = "#{cfg[:parent]}#{cfg.fetch(:separator, '')}#{cfg[:project]}"
	parentcap = cfg.fetch(:parent, '').split(cfg.fetch(:separator, '-')).map{|s| s.capitalize
		}.join(cfg.fetch(:joiner, ''))
	
	cfg = cfg.merge(:year => cfg[:date].split('-')[0],
		:namespace => namespace, :nesteddirs => namespace.tr('.', '/'),
		:name => name, :parentcap => parentcap,
		:projectcap => cfg[:project].capitalize)
	regex_checks(cfg[:name], cfg)
	return cfg
end

def render_skeleton(skeleton='skeleton-rb', config={})
	b = binding
	config = config.merge(:skeletondir => File.expand_path(skeleton,
		SCRIPTPARENT))
	config.each{|k, v| b.local_variable_set(k, v)}
	if File.exist?(File.join(config[:skeletondir], '<%=config[:name]%>'))
		start_dir = File.join(config[:skeletondir], '<%=config[:name]%>')
	else
		start_dir = File.join(config[:skeletondir], '<%=name%>')
	end
	
	files_skel = Dir["{**/*,**/.*}", base: start_dir
		].filter{|p| File.file? File.join(start_dir, p)}
	inouts = {}
	files_skel.each{|f|
		inouts[f] = ERB.new(f).result(b).sub(/\.erb$/, '').sub(/\.tt$/, '')}
	puts "... #{inouts.size} files processing ..."
	
	#inouts = {'LICENSE.erb' => 'LICENSE'}
    inouts.values().uniq.each{|pathX|
		dirX = File.dirname(pathX)
		if not File.exist?("#{config[:name]}/#{dirX}")
			FileUtils.mkdir_p("#{config[:name]}/#{dirX}")
		end}
    inouts.each{|src, dst| File.open(File.join(config[:name], dst), 'w+') {|f|
		f.write(ERB.new(File.read(File.join(start_dir, src))).result(b))}}
	
	puts 'Post rendering message'
	Dir.chdir(config[:name])
	system('ruby choices/post_render.rb')
end

def parse_cmdopts(args=[])
	require 'optparse'
	
	opts_hash = {'datajson': 'data.json', 'skeleton': 'skeleton-rb',
		'fileIn': STDIN, 'fileOut': STDOUT}
	usage_str = <<EOF
Usage: #{File.basename $PROGRAM_NAME} [OPTIONS]

Example: #{File.basename $PROGRAM_NAME} -i LICENSE.erb -s skeleton-rb
EOF
	opts_parser = OptionParser.new {|opts|
		opts.separator nil
		opts.separator 'Specific options:'
		
		opts.on('-d DATA', '--datajson DATA', String, 'JSON data file name') {
			|datajson| opts_hash[:datajson] = datajson}
		opts.on('-s SKEL', '--skeleton SKEL', String, 'Choose skeleton template') {
			|skeleton| opts_hash[:skeleton] = skeleton}
		opts.on('-i IN', '--fileIn IN', String, 'Input file or stdin') {
			|fileIn| opts_hash[:fileIn] = File.open(fileIn)}
		opts.on('-o OUT', '--fileOut OUT', String, 'Output file or stdout') {
			|fileOut| opts_hash[:fileOut] = File.open(fileOut, mode = 'w+')}
		opts.on('-f FUNC', '--func FUNC', ['skeleton', 'file'],
			'Specify render method (skeleton, file)') {|func|
			opts_hash[:func] = func}
		
		opts.banner = usage_str
		opts.separator nil
		opts.separator 'Common options:'
		
		opts.on_tail('-h', 'help message') {
			$stderr.print opts
			exit 0 }
	}.parse!(args) or raise
	#raise usage_str unless 0 == args.size
	opts_hash
end

if __FILE__ == $PROGRAM_NAME
	opts_hash = parse_cmdopts(ARGV)
	kvset = {}
	while extra = ARGV.shift
		if extra.match(/\w+=\w+/)
			key1, val1 = *extra.split('=', 2)
			(kvset ||= {})[key1.to_sym] = val1
		end
	end
	
	case opts_hash[:func]
	when 'file'
		b = binding
		config = config_data(opts_hash[:datajson], kvset)
		config.each{|k, v| b.local_variable_set(k, v)}
		opts_hash[:fileOut].write(ERB.new(opts_hash[:fileIn].read).result(b))
	else
		config = config_data(File.expand_path(
			"#{opts_hash[:skeleton]}/#{opts_hash[:datajson]}", SCRIPTPARENT),
			kvset)
		render_skeleton(opts_hash[:skeleton], config)
	end
	exit 0
end

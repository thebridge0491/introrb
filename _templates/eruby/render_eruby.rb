#!/usr/bin/env ruby -w

require 'English'
require 'json'
require 'psych'
require 'toml'
require 'erb'
require 'fileutils'

module RenderEruby
	extend self
	
	SCRIPTPARENT = File.dirname(File.absolute_path(__FILE__))

	def deserialize_file(datapath, fmt='yaml', date_key='date')
		initdata = {}
	
		keys2sym = proc {|h| h.map{|k, v|
		  [k.to_sym, v.is_a?(Hash) ? keys2sym.call(v) : v]}.to_h}
	
		if ['yaml', 'json'].include? fmt
			initdata = initdata.merge(keys2sym.call Psych.load_file(datapath))
		elsif 'toml' == fmt
			initdata = initdata.merge(keys2sym.call TOML.load_file(datapath))
		#elsif 'json' == fmt
		#	#initdata = JSON.parse(File.read(datapath), {:symbolize_names => true})
		#	initdata = initdata.merge(JSON.parse(File.read(datapath), {:symbolize_names => true}))
		end
	
		initdata = initdata.merge(date_key.to_sym => Time.new.strftime('%Y-%m-%d'))
		return initdata
	end

	def deserialize_str(datastr, fmt='yaml', date_key='date')
		initdata = {}
	
		keys2sym = proc {|h| h.map{|k, v|
		  [k.to_sym, v.is_a?(Hash) ? keys2sym.call(v) : v]}.to_h}
	
		if ['yaml', 'json'].include? fmt
			initdata = initdata.merge(Psych.load(datastr, {:symbolize_names => true}))
		elsif 'toml' == fmt
			initdata = initdata.merge(keys2sym.call TOML.load(datastr))
		#elsif 'json' == fmt
		#	#initdata = JSON.parse(datastr, {:symbolize_names => true})
		#	initdata = initdata.merge(JSON.parse(datastr, {:symbolize_names => true}))
		end
	
		initdata = initdata.merge(date_key.to_sym => Time.new.strftime('%Y-%m-%d'))
		return initdata
	end

	def regex_checks(pat, substr, txt)
		if (!(%r"#{pat}".match(substr)))
			puts "ERROR: Regex match failure (%r'#{pat}'.match(#{substr})) for (#{txt})."
			exit 1
		end
	end

	def derive_skel_vars(ctx={})
		name = "#{ctx.fetch(:parent, '')}#{ctx.fetch(:separator, '')}#{ctx[:project]}"
		parentcap = ctx.fetch(:parent, '').split(ctx.fetch(:separator, '-')).map{|s| s.capitalize
			}.join(ctx.fetch(:joiner, ''))
		namespace = "#{ctx[:groupid] ? ctx[:groupid] + '.' : ''}#{ctx.fetch(:parent, '')}.#{ctx[:project]}"
	
		ctx = ctx.merge(:year => ctx[:date].split('-')[0], :name => name,
			:parentcap => parentcap, :projectcap => ctx[:project].capitalize,
			:namespace => namespace, :nesteddirs => namespace.tr('.', '/'))
		return ctx
	end

	def render_skeleton(skeleton='skeleton-rb', ctx={})
		b = binding
		config = ctx.merge(:skeletondir => File.expand_path(skeleton, SCRIPTPARENT))
		config.each{|k, v| b.local_variable_set(k, v)}
		if File.exist?(File.join(config[:skeletondir], '<%=config[:name]%>'))
			start_dir = File.join(config[:skeletondir], '<%=config[:name]%>')
		else
			start_dir = File.join(config[:skeletondir], '<%=name%>')
		end
	
		files_skel = Dir["{**/*,**/.*}", base: start_dir].filter{|p|
			File.file? File.join(start_dir, p)}
		renderouts, copyouts, pat_erb, pat_tt = {}, {}, /\.erb$/, /\.tt$/
		files_skel.each{|skelX|
			template = ERB.new(skelX)
			if pat_erb.match(skelX) or pat_tt.match(skelX)
				renderouts[skelX] = template.result(b).sub(pat_erb, '').sub(pat_tt, '')
			else
				copyouts[skelX] = template.result(b)
			end
		}
		puts "... processing files -- rendering #{renderouts.size} ; copying #{copyouts.size} ..."
	
		(renderouts.values() + copyouts.values()).uniq.each{|pathX|
			dirX = File.dirname(pathX)
			if not File.exist?(File.join(config[:name], dirX))
				FileUtils.mkdir_p(File.join(config[:name], dirX))
			end}
		renderouts.each{|srcR, dstR| File.open(File.join(config[:name], dstR), 'w+') {|f|
			template = ERB.new(File.read(File.join(start_dir, srcR)))
			f.write(template.result(b))
			}
		}
		copyouts.each{|srcC, dstC| File.open(File.join(config[:name], dstC), 'w+') {|f|
			f.write(File.read(File.join(start_dir, srcC)))}}
	
		puts 'Post rendering message'
		Dir.chdir(config[:name])
		system('ruby choices/post_gen_project.rb') # ruby ___.rb | sh ___.sh
	end

	def parse_cmdopts(args=[])
		require 'optparse'
	
		opts_hash = {'data': 'data.yaml', 'datafmt': 'yaml', 'fileOut': STDOUT,
		  'template': 'skeleton-rb'}
		usage_str = <<EOF
Usage: #{File.basename $PROGRAM_NAME} [OPTIONS] [TEMPLATE] [KEY1=VAL1 KEYN=VALN]

Example: #{File.basename $PROGRAM_NAME} -d data.yaml LICENSE.erb
EOF
		opts_parser = OptionParser.new {|opts|
			opts.separator nil
			opts.separator 'Specific options:'
		
			opts.on('-d DATA', '--data DATA', String, 'Data path or - (for stdin)') {
				|data| opts_hash[:data] = data}
			opts.on('-f FMT', '--datafmt FMT', ['yaml', 'json', 'toml'],
				'Specify data file format (yaml, json, toml)') {
				|datafmt| opts_hash[:datafmt] = datafmt}
			#opts.on('-t TEMPLATE', '--template TEMPLATE', String, 'Template path') {
			#	|template| opts_hash[:template] = template}
			#opts.on('-i IN', '--fileIn IN', String, 'File in - (for stdin) or path') {
			#	|fileIn| opts_hash[:fileIn] = File.open(fileIn)}
			opts.on('-o FILEOUT', '--fileOut FILEOUT', String,
			  'File out - (for stdout) or path') {
				|fileOut| opts_hash[:fileOut] = File.open(fileOut, mode = 'w+')}
		
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

	def main(args=[])
		opts_hash, config = parse_cmdopts(args), {}
		
		kvset, rest = {}, []
		while extra = args.shift
			if extra.match(/\w+=\w+/)
				key1, val1 = *extra.split('=', 2)
				(kvset ||= {})[key1.to_sym] = val1
			else
			  rest += [extra]
			end
		end
		if 0 < rest.length
		  opts_hash[:template] = rest.shift
		end
		if (not File.exist?(opts_hash[:template]) and 
		    not File.exist?(File.expand_path(opts_hash[:template], SCRIPTPARENT)))
		  puts "Non-existent template: #{opts_hash[:template]}"
		  exit 1
		end
		is_dir = (File.directory?(opts_hash[:template]) or 
		  File.directory?(File.expand_path(opts_hash[:template], SCRIPTPARENT)))
	  if '-' == opts_hash[:data]
	    config = deserialize_str($stdin.read, opts_hash[:datafmt], 'date')
	  end
	  
	  if not is_dir
	    b = binding
	    
	    if not '-' == opts_hash[:data]
	      config = deserialize_file(opts_hash[:data], opts_hash[:datafmt], 'date')
	    end
	    config = config.merge(kvset)
			config.each{|k, v| b.local_variable_set(k, v)}
			template = ERB.new(File.read(opts_hash[:template]))
			opts_hash[:fileOut].write(template.result(b))
	  else
	    if not '-' == opts_hash[:data]
	      config = deserialize_file(File.expand_path(
				  "#{opts_hash[:template]}/#{opts_hash[:data]}", SCRIPTPARENT),
				  opts_hash[:datafmt], 'date')
	    end
			config = config.merge(kvset)
			config = derive_skel_vars(config)
			regex_checks(config.fetch(:parentregex, ''), config.fetch(:parent, ''),
				config.fetch(:name, ''))
			regex_checks(config.fetch(:projectregex, ''), config.fetch(:project, ''), 
			  config.fetch(:name, ''))
			render_skeleton(opts_hash[:template], config)
	  end
		0
	end
end


if __FILE__ == $PROGRAM_NAME
  exit RenderEruby.main(ARGV)
end

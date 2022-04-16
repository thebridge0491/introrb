require 'thor/group'
require 'json'
require 'psych'
require 'toml'
require 'erb'
require 'fileutils'

module Template; end

class Template::Cli < Thor::Group
  #namespace "template:cli"
  include Thor::Actions
  
  argument :template, :default => "#{ENV['HOME']}/Templates/eruby/templatethor-rb",
    :desc => 'Template path'
  class_option :data, :default => "data.yaml",
    :desc => 'Data path or - (for stdin)', :aliases => :d
  class_option :datafmt, :default => "yaml",
    :desc => 'Specify data file format (yaml, json, toml)', :aliases => :f
  #class_option :fileIn, :default => "STDIN", :desc => 'File in - (for stdin) or path',
  #  :aliases => :i
  class_option :fileOut, :default => "STDOUT", :desc => 'File out - (for stdout) or path',
    :aliases => :o
  class_option :kvhash, :type => :hash, :desc => 'Set key:value pairs (key1:val1 keyN:valN)',
    :aliases => :k
  
  def self.source_root
    #File.expand_path(File.join(File.dirname(__FILE__), '.'))
    File.dirname(__FILE__)
  end
  
  def main(args = [])
    config, kvset = {}, {}
    for key1, val1 in (options[:kvhash] || {})
      (kvset ||= {})[key1.to_sym] = val1
    end
    
    if not File.exist?(template)
	  puts "Non-existent template: #{template}"
	  exit 1
	end
	is_dir = File.directory?(template)
    if '-' == options[:data]
      config = deserialize_str($stdin.read, options[:datafmt], 'date')
    end
    
    if not is_dir
      #fileIn = "STDIN" == options[:fileIn] ? STDIN : File.open(options[:fileIn])
      fileOut = "STDOUT" == options[:fileOut] ? STDOUT : File.open(options[:fileOut],
        mode = 'w+')
      b = binding
      
      if not '-' == options[:data]
        config = deserialize_file(options[:data], options[:datafmt], 'date')
      end
      config = config.merge(kvset)
      config.each{|k, v| b.local_variable_set(k, v)}
      templateF = ERB.new(File.read(template))
      fileOut.write(templateF.result(b))
    else
      if not '-' == options[:data]
        config = deserialize_file(File.expand_path(options[:data], template),
		  options[:datafmt], 'date')
      end
      config = config.merge(kvset)
      config = derive_skel_vars(config)
      regex_checks(config.fetch(:parentregex, ''), config.fetch(:parent, ''),
		config.fetch(:name, ''))
	  regex_checks(config.fetch(:projectregex, ''), config.fetch(:project, ''), 
		config.fetch(:name, ''))
	  render_skeleton(template, config)
    end
  end
  
  private
  
  def deserialize_file(datapath, fmt='yaml', date_key='date')
    initdata = {}
    
    keys2sym = proc {|h| h.map{|k, v|
      [k.to_sym, v.is_a?(Hash) ? keys2sym.call(v) : v]}.to_h}
    
    if ['yaml', 'json'].include? fmt
	  initdata = initdata.merge(keys2sym.call Psych.load_file(datapath))
    elsif 'toml' == fmt
	  initdata = initdata.merge(keys2sym.call TOML.load_file(datapath))
    #elsif 'json' == fmt
    #  #initdata = JSON.parse(File.read(datapath), {:symbolize_names => true})
    #  initdata = initdata.merge(JSON.parse(File.read(datapath), {:symbolize_names => true}))
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
    #  #initdata = JSON.parse(datastr, {:symbolize_names => true})
    #  initdata = initdata.merge(JSON.parse(datastr, {:symbolize_names => true}))
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

  def render_skeleton(skeleton='templatethor-rb', ctx={})
    b = binding
    config = ctx.merge(:skeletondir => File.expand_path(skeleton))
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

end


if __FILE__ == $PROGRAM_NAME
  Template::Cli.start(ARGV)
  exit 0
end

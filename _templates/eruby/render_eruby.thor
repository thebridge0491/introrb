require 'thor/group'
require 'json'
require 'erb'

module Skel; end

class Skel::Template < Thor::Group
  #namespace "skel:template"
  include Thor::Actions
  
  argument :skeleton, :default => "templatethor-rb"
  argument :datajson, :default => "data.json"
  class_option :kvhash, :type => :hash
  
  def self.source_root
    #File.expand_path(File.join(File.dirname(__FILE__), '.'))
    #File.dirname(__FILE__)
    File.expand_path("#{ENV['HOME']}/Templates/eruby")
  end
  
  def render_skeleton
    cfg = config_data()
    
    b = binding
    config = cfg.merge(:skeletondir => File.expand_path(skeleton,
      "#{ENV['HOME']}/Templates/eruby"))
    config.each{|k, v| b.local_variable_set(k, v)}
    if File.exist?(File.join(config[:skeletondir], '<%=config[:name]%>'))
      start_dir = File.join(config[:skeletondir], '<%=config[:name]%>')
    else
      start_dir = File.join(config[:skeletondir], '<%=name%>')
    end
    
    files_skel = Dir["{**/*,**/.*}", base: start_dir].filter{|p| 
      File.file? File.join(start_dir, p)}
    inouts = {}
    files_skel.each{|f|
      inouts[f] = ERB.new(f).result(b).sub(/\.erb$/, '').sub(/\.tt$/, '')}
    puts "... #{inouts.size} files processing ..."
    
    #template('LICENSE.tt', 'LICENSE', config)
    #inouts = {'LICENSE.tt' => 'LICENSE'}
    inouts.each{|src, dst|
      template(File.join(start_dir, src), File.join(config[:name], dst), 
        config)}
	
    puts 'Post rendering message'
    Dir.chdir(config[:name])
    system('ruby choices/post_render.rb')
  end
  
  private
  
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

  def config_data
    kvset = {}
    for key1, val1 in (options[:kvhash] || {})
      (kvset ||= {})[key1.to_sym] = val1
    end
    
    cfg = {}
    initdata = JSON.parse(File.read(File.join(File.expand_path(skeleton, 
        "#{ENV['HOME']}/Templates/eruby"), datajson)),
        {:symbolize_names => true}
        ).merge(:date => Time.new.strftime('%Y-%m-%d'))
    
    cfg = cfg.merge(initdata)
    cfg = cfg.merge(kvset)
    cfg = cfg.merge(:verbose => 'false' == kvset[:verbose] ? false : true,
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
end

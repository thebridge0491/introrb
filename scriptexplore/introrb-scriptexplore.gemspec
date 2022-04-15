# -*- ruby -*-
# encoding: utf-8

require_relative 'lib/introrb/scriptexplore/version'

Gem::Specification.new do |s|
  gemfiles = gemfiles = (File.exist?('Manifest.txt') ? (File.read('Manifest.txt').split(/\r?\n\r?/) rescue nil) : Dir.glob('{lib/**/*,ext/**/*.i,resources/*}', File::FNM_DOTMATCH)) # + Dir.glob('{*.gemspec,.editorconfig,exclude.lst,.*ignore,.document,.rdoc_options,.rspec,.yardopts,*.sh,Gemfile,*akefile,README*,test/**/*,spec/**/*}', File::FNM_DOTMATCH)
  # gemfiles = `git ls-files`.split # [git ls-files | hg manifest -r default | svn ls -R]
  ## cmd w/ zip: zip -q -x @exclude.lst -r - . | unzip -Z -1 -
  ## cmd w/ tar: tar -X exclude.lst -cf - . | tar -tf - | sed "s|^./||"
  # gemfiles = (proc {
  #  require 'open3'
  #  out, err, st = Open3.capture3('zip -q -x @exclude.lst -r - . | unzip -Z -1 -')
  #  out.split.reject{|f| File.directory? f} }).call
  # gemfiles = `tar -X exclude.lst -cf - . | tar -tf - | sed "s|^./||"`.split.reject{
  #  |f| File.directory? f}
  
  s.name = 'introrb-scriptexplore'
  s.version = Introrb::Scriptexplore::VERSION
  s.summary = 'Script explore sub-package for Ruby Intro examples project.'
  s.authors = ['thebridge0491']
  s.files = gemfiles.reject{|f| f.match(%r{^(test|spec)/})}
  
  s.licenses = ['Apache-2.0']
  s.description = 'Script explore sub-package for Ruby Intro examples project.'
  s.email = ['thebridge0491-codelab@yahoo.com']
  s.homepage = 'https://www.bitbucket.org/thebridge0491/introrb'
  # s.metadata = { 'bug_tracker_uri' => "#{s.homepage}/issues",
  #  'homepage_uri' => s.homepage, 'source_code_uri' => s.homepage
  # } if s.respond_to? :metadata=
    
  s.test_files = gemfiles.select{|f| f.match(%r{^(test|spec)/})} if
    s.respond_to? :test_files=
  # s.require_paths = ['lib']
  # s.bindir = 'bin'
  s.executables = Dir.glob("#{s.bindir}/*").map{|f|
    File.basename f}.reject{|f| f.match(%r{^(console|setup)$})}
  s.extensions = Dir.glob('ext/**/extconf.rb')
  s.extra_rdoc_files = Dir.glob('{LICENSE,README*}')
  # s.rdoc_options = ['--main', 'README.txt']
  
  s.required_ruby_version = Gem::Requirement.new('>= 2.7') if
    s.respond_to? :required_ruby_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 3.0') if
    s.respond_to? :required_rubygems_version=
  s.platform = Gem::Platform::RUBY
  
  ## (trusted source) gem cert --add $HOME/.pki/publish_crls/demoCA/chain.crt
  # s.cert_chain = ["#{ENV['HOME']}/.pki/paired/codesign.pem"]
  # s.signing_key = "#{ENV['HOME']}/.pki/paired/codesign.pem"
  
  # s.date = '2013-07-02' # Time.now.strftime('%Y-%m-%d')

  {'bundler' => '>= 2.3', 'rake' => '>= 13.0', 'rdoc' => '>= 6.3',
    'yard' => '>= 0.9', 'rspec' => '>= 3.10', 'minitest' => '>= 5.14',
    'simplecov' => '>= 0.21', 'rubocop' => '>= 1.24',
    'rake-compiler' => '>= 1.1'}.each do |depn, ver|
    s.add_development_dependency depn, ver
  end
  
  {'logging' => '>= 2.2', 'log4r' => '>= 1.1', 'inifile' => '>= 2.0',
    'parseconfig' => '>= 1.1', 'toml' => '>= 0.3', 'thor' => '>= 1.1' #,
    #'ffi' => '>= 1.14'
    }.each do |depn, ver|
    s.add_runtime_dependency depn, ver
  end
end

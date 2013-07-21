# -*- ruby -*-
# encoding: utf-8

require_relative 'lib/introrb/util/version'

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
  
  s.name = 'introrb-util'
  s.version = Introrb::Util::VERSION
  s.summary = 'Utilities sub-package for Ruby Intro examples project.'
  s.authors = ['thebridge0491']
  s.files = gemfiles.reject{|f| f.match(%r{^(test|spec)/})}
  
  s.licenses = ['Apache-2.0']
  s.description = 'Utilities sub-package for Ruby Intro examples project.'
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
  
  s.required_ruby_version = Gem::Requirement.new('>= 2.0') if
    s.respond_to? :required_ruby_version=
  s.required_rubygems_version = Gem::Requirement.new('>= 2.0') if
    s.respond_to? :required_rubygems_version=
  s.platform = Gem::Platform::RUBY
  
  # s.cert_chain = ["#{ENV['HOME']}/.pki/paired/codesign.pem"]
  # s.signing_key = "#{ENV['HOME']}/.pki/paired/codesign.pem"
  
  # s.date = '2013-07-20' # Time.now.strftime('%Y-%m-%d')

  {'bundler' => '>= 1.3.5', 'rake' => '>= 10.0.4', 'rdoc' => '>= 4.0.1',
    'yard' => '>= 0.8.6', 'rspec' => '>= 2.13.0', 'minitest' => '>= 5.0.3',
    'simplecov' => '>= 0.7.1', 'rubocop' => '>= 0.8.2',
    'rake-compiler' => '>= 0.8.3'}.each do |depn, ver|
    s.add_development_dependency depn, ver
  end
  
  {'logging' => '>= 1.7.2', 'log4r' => '>= 1.1.10' #,
    #'ffi' => '>= 1.8.1'
    }.each do |depn, ver|
    s.add_runtime_dependency depn, ver
  end
end

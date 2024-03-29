require 'psych'

choosehelper = 'manual' # jeweler | hoe | manual

configyaml = "name: introrb-util
summary: Utilities sub-package for Ruby Intro examples project.
description: Utilities sub-package for Ruby Intro examples project.
authors: [thebridge0491]
email: [thebridge0491-codelab@yahoo.com]
licenses: [Apache-2.0]
homepage: https://www.bitbucket.org/thebridge0491/introrb

required_ruby_version: '>= 2.7'
required_rubygems_version: '>= 3.0'

development_dependencies: {
  bundler: '>= 2.3', rake: '>= 13.0', rdoc: '>= 6.3', yard: '>= 0.9',
  rspec: '>= 3.10', minitest: '>= 5.14', simplecov: '>= 0.21',
  rubocop: '>= 1.24', rake-compiler: '>= 1.1'
  }
runtime_dependencies: {
  logging: '>= 2.2', log4r: '>= 1.1' #,
  # ffi: '>= 1.14'
  }
"

configdata = Psych.load(configyaml)
SPEC =
  if 'jeweler' == choosehelper
    require 'jeweler'

    require_relative 'lib/introrb/util/version'

    Jeweler::Tasks.new do |s|
      gemfiles = (File.exist?('Manifest.txt') ? (File.read('Manifest.txt').split(/\r?\n\r?/) rescue nil) : Dir.glob('{lib/**/*,ext/**/*.i,resources/*}', File::FNM_DOTMATCH))

      s.name = configdata.fetch('name')
      s.version = Introrb::Util::VERSION
      s.summary = configdata['summary']
      s.authors = configdata['authors']
      s.files = gemfiles.reject{|f| f.match(%r{^(test|spec)/})}

      s.licenses = configdata['licenses']
      s.description = configdata['description']
      s.email = configdata['email']
      s.homepage = configdata['homepage']
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

      s.required_ruby_version = Gem::Requirement.new(configdata['required_ruby_version']) if
        s.respond_to? :required_ruby_version=
      s.required_rubygems_version = Gem::Requirement.new(configdata['required_rubygems_version']) if
        s.respond_to? :required_rubygems_version=
      s.platform = Gem::Platform::RUBY

      ## (trusted source) gem cert --add $HOME/.pki/publish_crls/demoCA/chain.crt
      # s.cert_chain = ["#{ENV['HOME']}/.pki/paired/codesign.pem"]
      # s.signing_key = "#{ENV['HOME']}/.pki/paired/codesign.pem"

      # s.date = '2013-07-20' # Time.now.strftime('%Y-%m-%d')

      configdata['development_dependencies'].each do |depn, ver|
        s.add_development_dependency depn, ver
      end

      configdata['runtime_dependencies'].each do |depn, ver|
        s.add_runtime_dependency depn, ver
      end
    end

    Rake.application.tasks.each{|t|
      Rake.application.instance_variable_get('@tasks').delete(t.to_s) unless
      %r{(gemspec|version_required)}.match(t.to_s)}

    Rake.application.jeweler.gemspec
  elsif 'hoe' == choosehelper
    require 'hoe'

    require_relative 'lib/introrb/util/version'

    ## common extra plugins -- :bundler, :compiler, :gem_prelude_sucks,
    ##   :gemspec, :inline, :minitest, :racc, :rcov, :rdoc
    class Hoe
      # @@plugins = [:clean, :debug, :deps, :flay, :flog, :newb, :package,
      #  :publish, :gemcutter, :signing, :test]
      @@plugins = [:gemspec]
    end

    gemspec_object = Hoe.spec configdata.fetch('name') do |s|
      gemfiles = (File.exist?('Manifest.txt') ? (File.read('Manifest.txt').split(/\r?\n\r?/) rescue nil) : Dir.glob('{lib/**/*,ext/**/*.i,resources/*}', File::FNM_DOTMATCH))

      s.version = Introrb::Util::VERSION

      s.summary = configdata['summary']
      s.description = configdata['description']

      s.author = configdata['authors']
      s.email = configdata['email']

      s.licenses = configdata['licenses']

      # s.readme_file = 'README.txt'
      # s.history_file = 'History.txt'
      require_ruby_version configdata['required_ruby_version'] # Gem::Requirement.new configdata['required_ruby_version']
      require_rubygems_version configdata['required_rubygems_version'] # Gem::Requirement.new configdata['required_rubygems_version']

      pluggable!
      configdata['development_dependencies'].each do |depn, ver|
        dependency depn, ver, :development
      end

      configdata['runtime_dependencies'].each do |depn, ver|
        dependency depn, ver #, :runtime
      end

      # Hoe.add_include_dirs ['lib', 'test', 'spec']
      # bindir = 'bin'
      s.spec_extras = s.spec_extras.merge({'bindir' => bindir ||= 'bin',
        'executables' => Dir.glob("#{bindir ||= 'bin'}/*").map{|f|
          File.basename f}.reject{|f| f.match(%r{^(console|setup)$})},
        'extensions' => Dir.glob('ext/**/extconf.rb'), 'rdoc_options' => '',
        'extra_rdoc_files' => Dir.glob('{LICENSE,README*}'),
        'homepage' => configdata['homepage'], 'metadata' => {},
        'files' => gemfiles.reject{|f| f.match(%r{^(test|spec)/})},
        'test_files' => gemfiles.select{|f| f.match(%r{^(test|spec)/})}})
    end

    gemspec_object.spec
  else # manual edit .gemspec
    require 'bundler' # bundler/gem_tasks | bundler

    begin
      Bundler.setup(:default, :development)
    rescue Bundler::BundlerError => e
      $stderr.puts e.message
      $stderr.puts 'Run `bundle install` to install missing gems'
      exit e.status_code
    end if defined? Bundler

    Gem::Specification.load("#{configdata.fetch('name')}.gemspec")
  end

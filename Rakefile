RAKE = ENV['RAKE'] ? ENV['RAKE'] : 'rake'
# Multi-package project rakefile script.
require 'rake/clean'
require 'rake/packagetask'

[CLEAN, CLOBBER, Rake::FileList::DEFAULT_IGNORE_PATTERNS].each{|a| a.clear}
CLEAN.include("**/core*", "**/*~", "**/*.o", "**/*.log", ".coverage")
CLOBBER.include("build/*", "build/.??*")

def _get_task_opts(options = {})
  require 'optparse'
  
  o = OptionParser.new do |opts|
    opts.banner = "Usage: #{RAKE} <opts_task> [options]"
    opts.on("-a OPTS", "--args OPTS") {|args| options[:args] = args}
  end
  options[:leftovers] = o.parse(o.order(ARGV) {})
  options
end

desc "Task example with opts: #{RAKE} _opts_task -- -a '-h'"
task :_opts_task do
  options = _get_task_opts #({args: ''})
  puts "Options were: #{options[:args]}"
end

desc "Task example with args: #{RAKE} _args_task\[arg1,arg2\]"
task :_args_task, [:arg1] do |t, args|
  puts "Args were: #{args[:arg1]} #{args.extras.join(' ')}"
end

parent, version = 'introrb', '0.1.0'
SUBDIRS = ENV['SUBDIRS'] ? ENV['SUBDIRS'].split : 'common foreignc api app'.split

desc "Default target: #{RAKE} help"
task :default => [:help]

desc "Help info"
task :help do |task_name|
  SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} #{task_name}"}}
  puts "##### Top-level multiproject: #{parent} #####"
  puts "Usage: #{RAKE} [SUBDIRS=#{SUBDIRS.join(' ')}] [task]"
  sh "#{RAKE} -T"
end

task :subclean do
	SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} clean"}}
end
task :subclobber do
	SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} clobber"}}
end
task :clean => [:subclean]
task :clobber => [:subclobber]

[['compile', 'Compile extension(s)']
].each do |task_name, desc_txt|
  desc desc_txt
  task :"#{task_name}" do
    SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} #{task_name}"}}
  end
end

#desc 'Run test(s): rake test\[topt1,topt2\]'
#task :test, [:topt1] do |task_name, topts|
#  SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} #{task_name}\\[#{topts[:topt1]},#{topts.extras.join(',')}\\] || true"}}
#end
desc 'Run spec(s): rake spec\[topt1,topt2\]'
task :spec, [:topt1] do |task_name, topts|
  SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} #{task_name}\\[#{topts[:topt1]},#{topts.extras.join(',')}\\] || true"}}
end

#----------------------------------------
file "pkg/#{parent}-#{version}" do |p|
  mkdir_p(p.name)
  # sh "zip -9 -q --exclude @exclude.lst -r - . | unzip -od #{p.name} -"
  sh "tar --format=posix --dereference --exclude-from=exclude.lst -cf - . | tar -xpf - -C #{p.name}"
end

if defined? Rake::PackageTask
  Rake::PackageTask.new(parent, version) do |p|
    # task("pkg/#{parent}-#{version}").invoke
    
    ENV.fetch('FMTS', 'tar.gz,zip').split(',').each{|fmt|
      if p.respond_to? "need_#{fmt.tr('.', '_')}="
        p.send("need_#{fmt.tr('.', '_')}=", true)
      else
        p.need_tar_gz = true
      end
    }
    task(:package).add_description "[FMTS=#{ENV.fetch('FMTS', 'tar.gz,zip')}]"
    task(:repackage).add_description "[FMTS=#{ENV.fetch('FMTS', 'tar.gz,zip')}]"
  end
  
  task :subpackage do
	SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} package"}}
  end
  task :subrepackage do
	SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} repackage"}}
  end
  task :package => :subpackage
  task :repackage => :subrepackage
else
  desc "[FMTS=#{ENV.fetch('FMTS', 'tar.gz,zip')}] Package project distribution"
  task :dist => ["pkg/#{parent}-#{version}"] do |t|
    distdir = "#{parent}-#{version}"
    
    ENV.fetch('FMTS', 'tar.gz,zip').split(',').each{|fmt|
      case fmt
      when '7z'
        rm_rf("pkg/#{distdir}.7z") || true
        cd('pkg') {sh "7za a -t7z -mx=9 #{distdir}.7z #{distdir}" || true}
      when 'zip'
        rm_rf("pkg/#{distdir}.zip") || true
        cd('pkg') {sh "zip -9 -q -r #{distdir}.zip #{distdir}" || true}
      else
        # tarext = `echo #{fmt} | grep -e '^tar$' -e '^tar.xz$' -e '^tar.zst$' -e '^tar.bz2$' || echo tar.gz`.chomp
        tarext = fmt.match(%r{(^tar$|^tar.xz$|^tar.zst$|^tar.bz2$)}) ? fmt : 'tar.gz'
        rm_rf("pkg/#{distdir}.#{tarext}") || true
        cd('pkg') {sh "tar --posix -h -caf #{distdir}.#{tarext} #{distdir}" || true}
      end
    }
    rm_rf("pkg/#{distdir}") || true
    SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} #{task_name}"}}
  end
end

[['gem', 'Build gem(s)'],
  ['uninstall', 'Uninstall product(s)'],
  ['install', 'Install product(s)'],
  ['rubocop', 'Rubocop check code'],
  # ['rdoc', 'Generate Rdoc API documentation(s)'],
  ['yard', 'Generate YARD API documentation(s)']
].each do |task_name, desc_txt|
  desc desc_txt
  task :"#{task_name}" do
    SUBDIRS.each {|dirX| cd(dirX) {sh "#{RAKE} #{task_name}"}}
  end
end

#!/usr/bin/env ruby

require 'English'
require 'psych'
require 'log4r'
require 'log4r/configurator'
require 'json'
require 'toml'
require 'inifile'
require 'parseconfig'

require 'introrb/util'
require 'introrb/practice'
require 'introrb/intro'

Logger = Log4r::Logger
Person = Introrb::Intro::Person
Intro = Introrb::Intro
Util = Introrb::Util
Classic = Introrb::Practice::Classic
Seqops = Introrb::Practice::Sequenceops

module Introrb; end
module Introrb::Intro; end

# -- run w/out compile --
# ruby -Ilib script[.rb] [arg1 argN]
# 
# -- run REPL, import script, & run --
# irb -Ilib
# > require 'script'
# > Script.main([arg1, argN])
# 
# -- help/info tools in REPL --
# help

module Introrb::Intro::App
  extend self
  
  User = Struct.new(:name, :num, :time_in)
  
  def run_intro(opts, rsrc_path: 'resources')
    time_in = DateTime.now
    user1 = User.new(opts[:user], Integer(opts[:num]), time_in)
    num_arr, num_i, delay_secs = [0b1011, 0o13, 0xb, 11], 0, 2.5
    
    pers1 = Person.new('I.M. Computer', 32)
    
    for num in num_arr
      num_i += num
    end
    raise 'Total of number array error' unless num_i == (num_arr.count * num_arr[0])
    
    ch = Intro.delay_char(delay_secs)
    
    user1.num = rand(17) + 2 if 0 == user1.num
    
    rexp = /^quit$/i # Regexp.new('^quit$', Regexp::IGNORECASE)
    printf("%s match: %s to %s\n", (rexp.match(opts[:user]) ? 'Good' : 
      'Does not'), opts[:user], rexp.inspect)
    
    greet_str = Intro.greeting('greet.txt', user1.name, rsrc_path: rsrc_path)
    printf "%s\n%s\n", user1.time_in, greet_str
    
    time_diff = (DateTime.now - user1.time_in).to_f * 1e5
    printf "(program %s) Took %.1f seconds.\n", $PROGRAM_NAME, time_diff
    
    puts '#' * 40
    arr = [2, 1, 0, 4, 3]
    if opts[:is_expt2]
      puts "expt(2.0, #{Float(user1.num)}): #{Classic.expt_i(2.0, Float(user1.num))}"
      puts "reverse(#{arr}): #{arr.reverse}"
      puts "#{arr}.sort: #{arr.sort}"
    else
      puts "fact(#{user1.num}): #{Classic.fact_i(user1.num)}"
      el = 3
      puts "indexOf(#{el}, #{arr}): #{Seqops.index_i(el, arr)}"
      puts "#{arr}.append(50): #{arr.append(50)}"
    end
    
    puts '#' * 40
    
    puts '#' * 40
    printf "pers1.age: %d\n", pers1.age
    pers1.age = 33
    printf "pers1.to_s: %s\n", pers1
    printf "pers1.inspect: %s\n", pers1.inspect
  end

  def parse_cmdopts(args = [])
    require 'optparse'
    
    opts_hash = {'user': 'World', 'num': 0, 'is_expt2': false}
    usage_str = <<EOF
Usage: #{$PROGRAM_NAME} [OPTIONS]

Example: #{$PROGRAM_NAME} -u World -n 5 
EOF
    opts_parser = OptionParser.new {|opts|
      opts.separator nil
      opts.separator 'Specific options:'
      
      opts.on('-u USER', '--user USER', String, 'User name') {
        |user| opts_hash[:user] = user}
      opts.on('-n NUM', '--num NUM', String, 'Number n') {
        |num| opts_hash[:num] = Integer(num)}
      opts.on('-2', '--is-expt', 'Expt 2 to n vice fact') {
        opts_hash[:is_expt2] = true}
        
      opts.banner = usage_str
      opts.separator nil
      opts.separator 'Common options:'
      
      opts.on_tail('-h', 'help message') {
        $stderr.print opts
        exit 0 }
    }.parse!(args) or raise
    # raise usage_str unless 0 == args.size
    opts_hash
  end
  
  def main(opts_hash = {})
    rsrc_path = ENV.fetch('RSRC_PATH', 'resources')
    
    begin
      Log4r::Configurator.load_xml_file("#{rsrc_path}/log4r.xml")
    rescue StandardError => e
      Logger.new('root1')
      Logger.root.level = Log4r::INFO
      Log4r::StderrOutputter.new 'console'
      Logger['root1'].add('console')
    end
    
    keys2sym = proc {|h| h.map{|k, v|
      [k.to_sym, v.is_a?(Hash) ? keys2sym.call(v) : v]}.to_h}
    
    # cfg_ini = keys2sym.call IniFile.load("#{rsrc_path}/prac.conf")
    cfg_ini = keys2sym.call ParseConfig.new("#{rsrc_path}/prac.conf").params
    
    #cfg_json = keys2sym.call JSON.parse(File.read("#{rsrc_path}/prac.json"))
    
    #cfg_yaml = keys2sym.call Psych.load(File.read("#{rsrc_path}/prac.yaml"))
    
    #cfg_toml = keys2sym.call TOML.load(File.read("#{rsrc_path}/prac.toml"))
    
    tup_arr = [
      [cfg_ini, cfg_ini[:default][:domain], cfg_ini[:user1][:name]] #,
      #[cfg_json, cfg_json[:domain], cfg_json[:user1][:name]],
      #[cfg_yaml, cfg_yaml[:domain], cfg_yaml[:user1][:name]],
      #[cfg_toml, cfg_toml[:domain], cfg_toml[:user1][:name]]
    ]
    
    tup_arr.each{|t0, t1, t2|
      puts "\nconfig: #{t0}"
      puts "domain: #{t1}"
      puts "user1Name: #{t2}"
    }
    puts ''
    run_intro(opts_hash, rsrc_path: rsrc_path)
    
    Logger['root1'].info 'exiting main'
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  App = Introrb::Intro::App
  exit App.main(App.parse_cmdopts(ARGV))
end

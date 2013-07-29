#!/usr/bin/env ruby

require 'English'

module Introrb; end
module Introrb::Scriptexplore; end

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

module Introrb::Scriptexplore::App
  extend self

  def parse_cmdopts(args = [])
    require 'optparse'
    
    mod_list = ['simple', 'advanced', 'mymd5', 'ggrep', 'ddiff']
    opts_hash = {'mod': 'simple'}
    usage_str = <<EOF
Usage: #{$PROGRAM_NAME} [OPTIONS]

Example: #{$PROGRAM_NAME} -m simple
EOF
    opts_parser = OptionParser.new {|opts|
      opts.separator nil
      opts.separator 'Specific options:'
      
      opts.on('-m MOD', '--mod MOD', String, "Select run module #{mod_list}") {
        |mod| opts_hash[:mod] = mod}
      
      opts.banner = usage_str
      opts.separator nil
      opts.separator 'Common options:'
      
      opts.on_tail('-h', 'help message') {
        $stderr.print opts
        exit 0 }
    }.parse!(args) or raise
    # raise usage_str unless 0 == args.size
    opts_hash[:rest] = args
    opts_hash
  end
  
  def main(opts_hash = {})
    require 'introrb/scriptexplore/' + opts_hash[:mod]
    
    ENV['PATH_PFX'] = 'resources/explore'
    runmod = Object.const_get('Introrb::Scriptexplore::' + opts_hash[:mod].capitalize())
    runmod.lib_main(opts_hash[:rest])
    
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  App = Introrb::Scriptexplore::App
  exit App.main(App.parse_cmdopts(ARGV))
end

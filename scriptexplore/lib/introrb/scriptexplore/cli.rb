#!/usr/bin/env ruby

require 'English'
require 'thor'

require 'introrb/scriptexplore/app'

module Introrb; end
module Introrb::Scriptexplore; end

class Introrb::Scriptexplore::Cli < Thor
  no_commands {
  #
  }
  
  mod_list = ['simple', 'advanced', 'mymd5', 'ggrep', 'ddiff']
  
  desc 'main ARGS', 'Main method'
  option :mod, :default => mod_list[0], :aliases => '-m', :desc => "choices: #{mod_list}"
  def main(args = [])
    Introrb::Scriptexplore::App.main(options.merge({:rest => ARGV.drop(3)}))
  end
end


if __FILE__ == $PROGRAM_NAME
  Introrb::Scriptexplore::Cli.start(ARGV)
  exit 0
end

#!/usr/bin/env ruby

require 'English'
require 'thor'

require 'introrb/intro/app'

module Introrb; end
module Introrb::Intro; end

class Introrb::Intro::Cli < Thor
  no_commands {
  #
  }
  
  desc 'main ARGS', 'Main method'
  option :user, :default => 'World', :aliases => '-u'
  def main(args = [])
    Introrb::Intro::App.main(options)
  end
end


if __FILE__ == $PROGRAM_NAME
  Introrb::Intro::Cli.start(ARGV)
  exit 0
end

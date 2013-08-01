require 'log4r'

module Introrb; end

module Introrb::Intro
  extend self
  
  Logger = Log4r::Logger
  Logger.new('root1')
  
  def greeting(greet_file, name, rsrc_path: "resources")
    Logger['root1'].info 'greeting'
    res_str = File.read("#{rsrc_path}/#{greet_file}").chomp
    
    res_str + name
  end
  
  def delay_char(delay_secs)
    require 'readline'
    
    ch = ''
    while true
      sleep delay_secs
      ch = Readline.readline 'Type any character when ready.'
      if '\n' != ch and '' != ch
        break
      end
    end
    ch[0]
  end
    
  def lib_main(args = [])
    delay_secs = 2.5
    puts "delay_char(#{delay_secs})"
    delay_char(delay_secs)
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  Introrb::Intro.lib_main(ARGV)
  exit 0
end

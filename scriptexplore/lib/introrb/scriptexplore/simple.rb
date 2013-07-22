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

module Introrb::Scriptexplore::Simple
  extend self
  
  SET_X = 'simperl'
  
  def xform_args(args, path_pfx)
    args.map {|f| nil == path_pfx ? f : "#{path_pfx}/#{SET_X}/#{f}"}
  end
  
  #problem 01: print cmd-line arguments 1 per line
  #<path>/maynard.pl 01 <path>/data01/arg[1 .. N]
  def simple01(args="data01/file1 data01/file2 data01/file3 data01/file4 data01/file5".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    for arg in args
	  puts arg
    end
  end
  
  #problem 02: print all lines read with line number, space, line
  #<path>/maynard.pl 02 [<path>/data02/arg[1 .. N]]
  def simple02(args="data02/file1 data02/file2 data02/file3 data02/file4 data02/file5".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    line_num = 1
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        print line_num, ' ', line
        line_num += 1
      end}
  end
  
  #problem 03: print logins and names (gcos field) of password-format file
  #<path>/maynard.pl 03 <path>/data03/arg[1 .. N]
  def simple03(args="data03/file1 data03/file2".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        fields = line.split(/:/)
        puts "#{fields[0]}\t\t#{fields[4]}"
      end}
  end
  
  #problem 04: print logins and names (gcos field) of password-format file sorted
  #<path>/maynard.pl 04 <path>/data03/arg[1 .. N]
  def simple04(args="data03/file1 data03/file2".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    log_list = []
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        fields = line.split(/:/)
        log_list.push("#{fields[0]}\t\t#{fields[4]}\n")
      end}
    puts log_list.sort
  end
  
  #problem 05: print all file/directory names in directory from cmd-line
  #<path>/maynard.pl 05 <path>/data05
  def simple05(args="data05".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    xform_args(args, path_pfx).map{|dir|
      d = IO.popen("/bin/ls #{dir}", 'r')
      while (line = d.gets)
        print "#{dir}/#{line}"
      end
      d.close}
  end
  
  #problem 06: print all regular file names in directory from cmd-line
  #<path>/maynard.pl 06 <path>/data05
  def simple06(args="data05".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    xform_args(args, path_pfx).map{|dir|
      d = IO.popen("/bin/ls #{dir}", 'r')
      while (line = d.gets)
        line = line.chomp
        if (File.file?("#{dir}/#{line}"))
          puts "#{dir}/#{line}"
        end
      end
      d.close}
  end
  
  #problem 07: print all directory names in directory from cmd-line
  #<path>/maynard.pl 07 <path>/data05
  def simple07(args="data05".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    xform_args(args, path_pfx).map{|dir|
      d = IO.popen("/bin/ls #{dir}", 'r')
      while (line = d.gets)
        line = line.chomp
        if (File.directory?("#{dir}/#{line}"))
          puts "#{dir}/#{line}"
        end
      end
      d.close}
  end
  
  #problem 08: print mv cmds to chg file extension fm "for" to "f"
  #<path>/maynard.pl 08 for f <path>/data08
  def simple08(args="for f data08".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    usage_str = "Usage: #{$PROGRAM_NAME} 08 <old> <new> <dirX>\n"
    if (3 > args.length)
      exit usage_str
    end
    ext_old, ext_new, dir1toN = args[0], args[1], args.drop(2)
    xform_args(dir1toN, path_pfx).map{|dir|
      d = IO.popen("/bin/ls #{dir}", 'r')
      while (old_file = d.gets)
	    old_file = old_file.chomp
	    
	    if (File.file?("#{dir}/#{old_file}"))
		  $ARG = old_file.clone # str.clone | "" + str | String.new str
		  
		  if ($ARG.sub!(/\.#{ext_old}$/, "\.#{ext_new}"))
		    puts "mv #{dir}/#{old_file} #{dir}/#$ARG"
		  end
	    end
	  end
      d.close}
  end
  
  def lib_main(args = [])
	switcher = {
	  '01' => lambda {|*a| simple01(*a)},
	  '02' => lambda {|*a| simple02(*a)},
	  '03' => lambda {|*a| simple03(*a)},
	  '04' => lambda {|*a| simple04(*a)},
	  '05' => lambda {|*a| simple05(*a)},
	  '06' => lambda {|*a| simple06(*a)},
	  '07' => lambda {|*a| simple07(*a)},
	  '08' => lambda {|*a| simple08(*a)}
	}
	usage_str = sprintf("  Usage: %s simple<n> <arg1> [arg2 ..]\n\n  Available functions: %s", $PROGRAM_NAME, switcher.keys())
	
	func = switcher.fetch([] != args ? args[0] : '01', lambda {|*args|  printf("Invalid function: %s\n%s\n", args[0], usage_str)})
    if ([] != args.drop(1))
      func.call(args.drop(1))
    else
      func.call()
    end
    
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  Simple = Introrb::Scriptexplore::Simple
  exit Simple.lib_main(ARGV)
end

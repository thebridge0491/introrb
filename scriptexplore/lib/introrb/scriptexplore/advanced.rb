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

module Introrb::Scriptexplore::Advanced
  extend self
  
  SET_X = 'perl'
  
  def xform_args(args, path_pfx)
    args.map {|f| nil == path_pfx ? f : "#{path_pfx}/#{SET_X}/#{f}"}
  end
  
  #problem 01: interleave the lines of two files
  #<path>/maynard.pl 01 <path>/data01/arg[1 .. 2]
  def advanced01(args="data01/filea data01/fileb".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    fh1, fh2 = xform_args(args, path_pfx).map{|p| File.open(p)}
    (line1, line2) = [fh1.gets, fh2.gets]
    
	while (line1 || line2)
	  print line1 if line1
	  print line2 if line2
	  
	  line1 = fh1.gets
	  line2 = fh2.gets
	end 

	fh1.close
	fh2.close
  end
  
  #problem 02: grep for regexp in list of files fm cmd-line
  #<path>/maynard.pl 02 'ba+d' <path>/data02/arg[1 .. N]
  def advanced02(args="ba+d data02/filea data02/fileb data02/dir/filec".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    rexp = args[0]
    xform_args(args.drop(1), path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        print "#{f.path}:#{line}" if line.match(/#{rexp}/)
      end}
  end
  
  #problem 03: concatenate all files whose names given in files fm cmd-line
  #<path>/maynard.pl 03 <path>/data03/arg[1 .. N]
  def advanced03(args="data03/files1a data03/files2a data03/files3a".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (filenm = f.gets)
        file0 = File.open(xform_args([filenm.chomp], path_pfx)[0])
        while (line = file0.gets)
          print line
        end
      end}
  end
  
  #problem 04: locate all core files in directories fm cmd-line
  #<path>/maynard.pl 04 <path>/data04/{a,b,a/d}
  def advanced04(args="data04/a data04/b data04/a/d".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    xform_args(args, path_pfx).map{|dir|
      #fh = IO.popen("/usr/bin/find #{dir} -name 'core' -print", 'r')
      #
      #while (line = fh.gets)
      #  print "rm #{line}"
      #end
      #fh.close
      Dir["#{dir}/**/core"].each{|line| puts "rm #{line}"}
      }
  end
  
  #problem 05: locate all core files in directories fm file fm cmd-line
  #<path>/maynard.pl 05 <path>/data05/dirs
  def advanced05(args="data05/dirsa".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (dir = f.gets)
        dir = xform_args([dir.chomp], path_pfx)[0]
        #fh = IO.popen("/usr/bin/find #{dir} -name 'core' -print", 'r')
        #
        #while (line = fh.gets)
        #  puts "rm #{line}"
        #end
        #fh.close
        Dir["#{dir}/**/core"].each{|line| puts "rm #{line}"}
      end}
  end
  
  #problem 06: grep f/all occur's of regexp fm cmd-line in all text files
  #<path>/maynard.pl 06 'ba+d' <path>/data06
  def advanced06(args="ba+d data06".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    rexp = args[0]
    xform_args(args.drop(1), path_pfx).map{|p|
      #fh1 = IO.popen("/bin/ls #{p}", 'r')
      #while (file0 = fh1.gets)
      #  file0 = p + '/' + file0.chomp
      #  
	  #	if (File.file?(file0) && `/usr/bin/file #{file0}`.match(/text/))
	  #	  fh2 = File.open(file0, 'r')
	  #	  
	  #	  while (line = fh2.gets)
	  #	    print "#{file0}:#{line}" if line.match(/#{rexp}/)
	  #	  end
	  #	  fh2.close
	  #	end
      #end
      #fh1.close
      Dir['*', base: p].each{|file0|
        file0 = p + '/' + file0.chomp
        
        if File.file?(file0)
	  	  fh2 = File.open(file0, 'r')
	  	  
	  	  while (line = fh2.gets)
	  	    begin
	  	      print "#{file0}:#{line}" if line.match(/#{rexp}/)
	  	    rescue ArgumentError => e
	  	      $stderr.puts "###\nError: Non-text file\n#{e}\n###"
	  	      break
	  	    end
	  	  end
	  	  fh2.close
	  	end
      }
      }
  end
  
  #problem 07: print mv cmds to chg basename for a set of files fm cmd-line
  #<path>/maynard.pl 07 solar <path>/data07/data.*
  def advanced07(args="solar data07/data.*".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    new_base = args[0]
    xform_args(args.drop(1), path_pfx).map{|f|
      f_ext = File.extname(f)
	  f_name = File.basename(f, f_ext)
	  f_path = File.dirname(f)
	  new_name = f_name
	  new_name = new_name.sub(/#{new_name}/, new_base)
	  
	  if (f_path.eql?('.'))
		puts "mv #{f_name}#{f_ext} #{new_name}#{f_ext}"
	  else
		puts "mv #{f_path}/#{f_name}#{f_ext} #{f_path}/#{new_name}#{f_ext}"
	  end}
  end
  
  #problem 08: print cmds to list users of sendmail (possible spammers)
  #<path>/maynard.pl 08 <path>/data08
  def advanced08(args="data08".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        if (m = line.match(/(\d+) .+ sendmail: \w+ (\S+).: user (.*)/))
		  puts "#{m[2]}   #{m[1]}"
		end
		if (line.match(/(\d+) .+ sendmail: server (\S+@)?(\S+) (\S+) cmd (.*)/))
	      puts "#$3   #$1"
	    end
	  end}
  end
  
  #problem 09: print user names in each event with quotes in ISP file
  #<path>/maynard.pl 09 <path>/data09
  def advanced09(args="data09".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    user_list = []
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        if (line.match(/^\s+User-Name = (.*)$/))
          user_list.push($1) 
        end
      end
      print user_list.join("\n")}
  end
  
  #problem 10: print user names in each event without quotes in ISP file
  #<path>/maynard.pl 10 <path>/data10
  def advanced10(args="data10".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    user_list = []
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        if (line.match(/^\s+User-Name = "(.*)"(.*)$/))
          user_list.push($1) 
        end
      end
      print user_list.join("\n")}
  end
  
  #problem 11: compute total user minutes in ISP file
  #<path>/maynard.pl 11 <path>/data11
  def advanced11(args="data11".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    time_tot = 0
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        if (line.match(/Acct-Session-Time = (\d+)/))
          time_tot += $1.to_i 
        end
      end
      puts "Total User Session Time = #{time_tot}"}
  end
  
  #problem 12: print number of connections with designated connect rates
  #<path>/maynard.pl 12 <path>/data12
  def advanced12(args="data12".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    (rate144, rate192, rate288, rate336, rate_hi) = [0, 0, 0, 0, 0]
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
		if (line.match(/Ascend-Data-Rate = (\d+)/))
		  choice = $1.to_i
		
		  case
		    when (14400 >= choice) then rate144 += 1
		    when (19200 >= choice) then rate192 += 1
		    when (28800 >= choice) then rate288 += 1
		    when (33600 >= choice) then rate336 += 1
		    else rate_hi += 1
		  end
		end
      end
	  puts "0-14400\t\t#{rate144}"
	  puts "14401-19200\t\t#{rate192}"
	  puts "19201-28800\t\t#{rate288}"
	  puts "28801-33600\t\t#{rate336}"
	  puts "above 33600\t\t#{rate_hi}"
      }
  end
  
  #problem 13: print total input and output bandwidth usage in packets
  #<path>/maynard.pl 13 <path>/data13
  def advanced13(args="data13".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    (usage_in, usage_out) = [0, 0]
    xform_args(args, path_pfx).map{|p| File.open(p)}.each{|f|
      while (line = f.gets)
        usage_in += $1.to_i if (line.match(/Acct-Input-Packets = (\d+)/))
        usage_out += $1.to_i if (line.match(/Acct-Output-Packets = (\d+)/))
      end}
    puts "Total Input Bandwidth Usage = #{usage_in} packets"
    puts "Total Output Bandwidth Usage = #{usage_out} packets"
  end
  
  #problem 14: print ???
  #<path>/maynard.pl 14 <path>/data14
  def advanced14(args="data14".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    
  end
  
  #problem 15: ???
  #<path>/maynard.pl 15 <path>/data15
  def advanced15(args="data15".split(), path_pfx=ENV.fetch('PATH_PFX', nil))
    
  end
  
  def lib_main(args = [])
	switcher = {
	  '01' => lambda {|*a| advanced01(*a)},
	  '02' => lambda {|*a| advanced02(*a)},
	  '03' => lambda {|*a| advanced03(*a)},
	  '04' => lambda {|*a| advanced04(*a)},
	  '05' => lambda {|*a| advanced05(*a)},
	  '06' => lambda {|*a| advanced06(*a)},
	  '07' => lambda {|*a| advanced07(*a)},
	  '08' => lambda {|*a| advanced08(*a)},
	  '09' => lambda {|*a| advanced09(*a)},
	  '10' => lambda {|*a| advanced10(*a)},
	  '11' => lambda {|*a| advanced11(*a)},
	  '12' => lambda {|*a| advanced12(*a)},
	  '13' => lambda {|*a| advanced13(*a)},
	  '14' => lambda {|*a| advanced14(*a)},
	  '15' => lambda {|*a| advanced15(*a)}
	}
	usage_str = sprintf("  Usage: %s advanced<n> <arg1> [arg2 ..]\n\n  Available functions: %s", $PROGRAM_NAME, switcher.keys())
	
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
  Advanced = Introrb::Scriptexplore::Advanced
  exit Advanced.lib_main(ARGV)
end

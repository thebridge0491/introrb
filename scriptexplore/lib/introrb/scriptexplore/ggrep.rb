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

module Introrb::Scriptexplore::Ggrep
  extend self
  
  SET_X = 'problems_perl'
  
  def xform_args(args, path_pfx)
    args.map {|f| nil == path_pfx ? f : "#{path_pfx}/#{SET_X}/#{f}"}
  end
  
  #Create files list
  def _create_files_list(paths)
    file_list = []
    paths.each{|path|
      if File.directory?(path)
        dir_files = Dir["#{path}/**"].map{|p| p.chomp}
        dir_files.each{|p| file_list.push(p) if File.file?(p)}
      elsif File.file?(path)
        file_list.push(path)
      end
      }
    file_list
  end
  
  #Create grep pattern match list
  def create_grep_match_list(rexp, paths, is_file_only: false, path_pfx: ENV.fetch('PATH_PFX', nil))
    match_list = []
    _create_files_list(xform_args(paths, path_pfx)).each{|file0|
      not_done = 1
      #f_type = `/usr/bin/file #{file0}`
      #fh = IO.popen((f_type.match('text') ? "/bin/cat #{file0}" : 
      #  "/usr/bin/strings #{file0}"), 'r')
      fh = File.open(file0)
      
      while (not_done && (line = fh.gets))
        begin
          if line.match(rexp)
            match_list.push(file0 + (!is_file_only ? ":#{line}" : "\n"))
            
            not_done = 0 if is_file_only
          end
        rescue ArgumentError => e
          $stderr.puts "###\nError: Non-text file\n#{e}\n###"
          break
        end
      end
      fh.close
      }
    match_list
  end
  
  def lib_main(args = [])
	
	params = args.select{|e| '-l' != e}
	
	# Greps for regular expression in all regular files in cmdline arg 
    # file/directory list as well as files under given directories
    # demo: $ script [-l] 'ba+d' <path>/filea <path>/fileb <path>/dir <path>/data6
    for line in create_grep_match_list(1 > params.length ? "ba+d" : params[0],
        2 > params.length ? ["data_grep/filea", "data_grep/fileb",
        "data_grep/dir", "data_grep/data6"] : params.drop(1),
		is_file_only: args.any?{|e| '-l' == e})
      puts line
    end
    
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  Ggrep = Introrb::Scriptexplore::Ggrep
  exit Ggrep.lib_main(ARGV)
end

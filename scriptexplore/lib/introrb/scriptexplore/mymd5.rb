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

module Introrb::Scriptexplore::Mymd5
  extend self
  
  SET_X = 'problems_perl'
  
  def xform_args(args, path_pfx)
    args.map {|f| nil == path_pfx ? f : "#{path_pfx}/#{SET_X}/#{f}"}
  end
  
  #Compute hash digest (MD5 or SHA1) of file
  def _compute_digest(filenm=__FILE__, is_sha1=false)
    require 'digest'
    
    hash_algo = is_sha1 ? Digest::SHA1.new : Digest::MD5.new
    f = File.open(filenm)
    while (line = f.gets)
      hash_algo.update(line)
    end
    hash_algo.hexdigest
  end
  
  #Print hash digest to file
  def print_digest(rootpath, digestpath=nil, is_sha1: false, path_pfx: ENV.fetch('PATH_PFX', nil))
    outfile = nil == digestpath ? $stdout : File.open(digestpath, 'w')
    
    xform_args([rootpath], path_pfx).map{|p| File.open(p)}.each{|f|
      while (dir = f.gets)
        dir = xform_args([dir.chomp], path_pfx)[0]
	    #dir_list = `/usr/bin/find #{dir} -print`.split.sort
	    dir_list = Dir["#{dir}/**"].sort
	    file_list = []
	    dir_list.grep(/^(.*)$/) {|file0|
		  file_list.push($1) if File.file?($1)
	    }
	    
	    file_list.each { |file0|
		  fgr_prt = _compute_digest(file0, is_sha1)
		  warn "Error on md5sum for file #{file0}: #{$OS_ERROR}\n" unless fgr_prt
		  outfile.puts "#{fgr_prt}\t#{file0}"
		}
      end
      }
    outfile.close
  end
  
  #Update two dictionaries of files -> digest
  def _update_lines_dict(dict1, dict2, digestpath)
    file0 = nil == digestpath ? $stdin : File.open(digestpath)
    
    while (line = file0.gets)
      matches = line.match(/^([^ \t]+)[ \t]*([^ \t]+)\n/)
      if !matches
        next
      end
      digest, file_name = matches.captures()
      
      if !dict2.has_key?(file_name)
        dict2[file_name] = ''
      end
      dict1[file_name] = digest
    end
  end
  
  #Verifies hash digest of file(s)
  def verify_digest(rootpath, digestpath, is_sha1: false)
    require 'tempfile'
    
    cur_file = Tempfile.new
    cur_lines, digest_lines = {}, {}
    
    print_digest(rootpath, cur_file.path, is_sha1: is_sha1)
    _update_lines_dict(cur_lines, digest_lines, cur_file.path)
    _update_lines_dict(digest_lines, cur_lines, digestpath)
    
    for tester in digest_lines.keys.sort
      if !(digest_lines[tester] && cur_lines[tester])
        puts "<old>#{tester}  #{digest_lines[tester]}" if digest_lines[tester]
        puts "<new>#{tester}  #{cur_lines[tester]}" if cur_lines[tester]
      elsif (digest_lines[tester] != cur_lines[tester])
        puts "<old>#{tester}  #{digest_lines[tester]}"
        puts "<new>#{tester}  #{cur_lines[tester]}"
        puts ''
      end
    end
    cur_file.unlink
  end
  
  def lib_main(args = [])
	
	paths = args.select{|e| '-c' != e && '-s' != e}
	
	if args.any?{|e| '-c' == e}
      # Verifies the hash digest (MD5 or SHA1) of all regular files under
      # any directories of command-line arg rootfile against the
      # command-line arg digestfile and indicates the status of changed,
      # added or deleted files in pairs
      #
      #Uses the following symbols to indicate status:
      #    <old>{file} {digest}        # for changed
      #    <new>{file} {digest}
      #    
      #    <new>{file} {digest}        # for added
      #    
      #    <old>{file} {digest}        # for deleted
      # demo: $ script [-s] -c <path>/rootfile.txt <path>/digestfile.txt
      verify_digest(paths.empty? ? "data_md5/rootfile.txt" : paths[0],
        2 > paths.length ? nil : paths[1], is_sha1: args.any?{|e| '-s' == e})
	else
      # Print the hash digest (MD5 or SHA1) of all regular files under any
      # directories of command-line arg file
      # demo: $ script [-s] <path>/rootfile.txt [<path>/digestfile.txt]
      print_digest(paths.empty? ? "data_md5/rootfile.txt" : paths[0],
        2 > paths.length ? nil : paths[1], is_sha1: args.any?{|e| '-s' == e})
	end
    
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  Mymd5 = Introrb::Scriptexplore::Mymd5
  exit Mymd5.lib_main(ARGV)
end

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

module Introrb::Scriptexplore::Ddiff
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
  
  #Create dictionaries of all files(directories 1 & 2) for two directories
  def _create_files_dicts(dir1, dir2)
    files_hash_a, files_a = {}, _create_files_list([dir1])
    files_hash_b, files_b = {}, _create_files_list([dir2])
    
    files_a.each{|file0|
      if File.file?(file0)
        files_hash_a[File.basename(file0)] = file0
        files_hash_b[File.basename(file0)] = nil
      end}
    files_b.each{|file0|
      if File.file?(file0)
        files_hash_b[File.basename(file0)] = file0
        files_hash_a[File.basename(file0)] = nil if !files_hash_a[File.basename(file0)]
      end}
    [files_hash_a, files_hash_b]
  end
  
  #Create diff list
  def create_diff_list(dirs, opt_differ: true, opt_same: true, opt_dir1: true,
        opt_dir2: true, path_pfx: ENV.fetch('PATH_PFX', nil))
    require 'digest'
    
    diff_list = []
    files_hash_a, files_hash_b = _create_files_dicts(*xform_args(dirs, 
		path_pfx))
    
    for tester in files_hash_a.keys.sort
      test_a = files_hash_a[tester] if files_hash_a[tester]
      test_b = files_hash_b[tester] if files_hash_b[tester]
      
      coexist = files_hash_a[tester] && files_hash_b[tester]
      
      diff_list.push("<<< #{tester}") if opt_dir1 && !files_hash_b[tester]
      diff_list.push(">>> #{tester}") if opt_dir2 && !files_hash_a[tester]
      
      if coexist
        #is_diff = nil == `diff -q #{test_a} #{test_b}` ? false : true
        digest_a = Digest::MD5.hexdigest(File.read(test_a))
        digest_b = Digest::MD5.hexdigest(File.read(test_b))
        is_diff = digest_a != digest_b
        diff_list.push("< #{tester} >") if opt_differ && is_diff
        diff_list.push("> #{tester} <") if opt_same && !is_diff
      end
    end
    
    diff_list
  end
  
  def lib_main(args = [])
	
	paths = args.select{|e| !e.match(/^-.*/)}
	opts = args.select{|e| e.match(/^-.*/)}
	opts_hash = 0 == opts.count ? {} : {
	  'opt_differ': opts.any?{|e| e.match(/d/)},
	  'opt_same': opts.any?{|e| e.match(/s/)},
	  'opt_dir1': opts.any?{|e| e.match(/1/)},
	  'opt_dir2': opts.any?{|e| e.match(/2/)}}
	
    # Performs diff on similar named files in two cmdline arg directories and
    # indicates status if file names and/or contents do/don't match.
    #
    # Uses the following symbols around file names to indicate status:
    #   unmatched file in dir1      : <<< file1
    #   unmatched file in dir2      : >>> file2
    #   similar name but different  : < file >
    #   similar name and same       : > file <
    # demo: $ script [-ds12] <path>/dataA <path>/dataB
    for line in create_diff_list(1 > paths.length ? ["data_diff/dataA",
          "data_diff/dataB"] : paths, **opts_hash)
      puts line
    end
    
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  Ddiff = Introrb::Scriptexplore::Ddiff
  exit Ddiff.lib_main(ARGV)
end

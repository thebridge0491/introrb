require 'ffi'

module Introrb; end
module Introrb::Foreignc; end

module Introrb::Foreignc::Classic
  extend FFI::Library
  ffi_lib 'intro_c-practice'
  
  # attach_function [:ruby_name, ]:c_name, [ :params ], :returns
  attach_function :fact_lp, :fact_lp, [:int], :int
  attach_function :fact_i, [:int], :int
  
  attach_function :expt_lp, [:float, :float], :float
  attach_function :expt_i, [:float, :float], :float
  
  extend self
  
  def lib_main(args = [])
    puts "fact(5): #{fact_i(5)}"
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  Introrb::Foreignc::Classic.lib_main(ARGV)
  exit 0
end

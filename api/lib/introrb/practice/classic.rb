require 'log4r'

module Introrb; end

module Introrb::Practice; end

module Introrb::Practice::Classic
  extend self
  
  Logger = Log4r::Logger
  Logger.new('prac')
  
  def fact_i(num)
    Logger['prac'].info 'fact_i'
    iter = lambda {|cnt, acc| 0 >= cnt ? acc : iter.call(cnt - 1, cnt * acc)}
    iter.call(num, 1)
  end
  
  def fact_r(num)
    1 > num ? 1 : num * fact_r(num - 1)
  end
  
  def fact_lp(num)
    acc = 1
    for i in (1 ... num + 1)
      acc *= i
    end
    acc
  end
  
  def expt_i(bs, num)
    iter = lambda {|cnt, acc| 0 >= cnt ? acc : iter.call(cnt - 1, bs * acc)}
    iter.call(Integer(num), 1.0)
  end
  
  def expt_r(bs, num)
    0.0 >= num ? 1.0 : bs * expt_r(bs, num - 1.0)
  end
  
  def expt_lp(bs, num)
    acc = 1.0
    for i in (0 ... Integer(num))
      acc *= bs
    end
    acc
  end
  
  def lib_main(args = [])
    n = 5
    puts "fact(#{n}): #{fact_i(n)}"
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  Introrb::Practice::Classic.lib_main(ARGV)
  exit 0
end

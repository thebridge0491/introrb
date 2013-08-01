require 'log4r'

module Introrb; end

module Introrb::Practice; end

module Introrb::Practice::Sequenceops
  extend self
  
  Logger = Log4r::Logger
  Logger.new('prac')
  
  def swap(idx0, idx1, arr)
    arr[idx0], arr[idx1] = arr[idx1], arr[idx0]
  end
  
  def index_i(data, arr)
    Logger['prac'].info 'index_i'
    iter = lambda do |idx, rst|
      if [] == rst
        nil
      elsif data == rst[0]
        idx
      else
        iter.call(idx + 1, rst.drop(1))
      end
    end
    iter.call(0, arr)
  end
  
  def index_lp(data, arr)
    for i in (0 ... arr.count)
      return i if data == arr[i]
    end
    nil
  end
  
  def reverse_i(arr)
    iter = lambda do |idx, acc|
      0 > idx ? acc : iter.call(idx - 1, acc + [arr[idx]])
    end
    iter.call(arr.count - 1, [])
  end
  
  def reverse_r(arr)
    [] == arr ? [] : [arr[-1]] + reverse_r(arr.take(arr.count - 1))
  end
  
  def reverse_lp(arr)
    newarr = []
    for i in (arr.count - 1 ... -1).step(-1)
      newarr.push(arr[i])
    end
    newarr
  end
  
  def copy_of_i(arr)
    iter = lambda do |idx, acc|
      0 > idx ? acc : iter.call(idx - 1, [arr[idx]] + acc)
    end
    iter.call(arr.count - 1, [])
  end
  
  def copy_of_r(arr)
    [] == arr ? [] : copy_of_r(arr.take(arr.count - 1)) + [arr[-1]]
  end
  
  def copy_of_lp(arr)
    newarr = []
    for i in (0 ... arr.count)
      newarr.push(arr[i])
    end
    newarr
  end
  
  def lib_main(args = [])
    el, arr = 3, [4, 2, 0, 1, 3]
    puts "indexOf(#{el}, #{arr}): #{index_i(el, arr)}"
    0
  end
end


if __FILE__ == $PROGRAM_NAME
  Introrb::Practice::Sequenceops.lib_main(ARGV)
  exit 0
end

require 'spec_helper'

module Introrb::Scriptexplore; end

Classic = Introrb::Scriptexplore::Classic
epsilon = 0.001

describe 'Introrb::Scriptexplore::ClassicSpec' do
  before(:all) do
    # puts 'setup class ...'
  end
  
  after(:all) do
    # puts '... teardown class'
  end  
  
  before(:each) do
    # puts 'setup method ...'
  end
  
  after(:each) do
    # puts '... teardown method'
  end
  
  def in_epsilon(a, b, tolerance = 0.001)
    delta = tolerance.abs
    # (a - delta) <= b && (a + delta) >= b
    !((a + delta) < b) && !((b + delta) < a)
  end
  
  def cartesian_prod(arr1, arr2)
    # arr1.product(arr2).select{|e| true}
    arr1.flat_map{|x| arr2.map{|y| [x, y]}}.select{|e| true}
  end

  describe 'spec_fact' do
    it 'factorial n' do
      [lambda {|n| Classic.fact_lp(n)}, lambda {|n| Classic.fact_i(n)}].each{
          |f|
        expect(120).to eq(f.call(5))
        expect(5040).to eq(f.call(7))
      }
    end
  end

  describe 'spec_expt' do
    it 'raise b to n' do
      params1, params2 = [2.0, 11.0, 20.0], [3.0, 6.0, 10.0]
      cartesian_prod(params1, params2).each{|b, n|
        ans = b ** n
        [lambda {|b, n| Classic.expt_lp(b, n)}, lambda {|b, n| Classic.expt_i(b, n)}].each{|f|
          # expect(ans).must_be_close_to f.call(b, n), (ans * epsilon)
          expect(in_epsilon(ans * epsilon, ans, f.call(b, n)))
      }}
    end
  end
end

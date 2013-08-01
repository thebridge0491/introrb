require 'spec_helper'

module Introrb::Practice; end

Classic = Introrb::Practice::Classic
epsilon = 0.001

describe 'Introrb::Practice::ClassicSpec' do
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

  describe 'spec_fact' do
    it 'factorial n' do
      [5, 7, 9].each{|num|
        #ans = (2 .. num).reduce(1) {|acc, el| acc * el}
        ans = (2 .. num).reduce(1, :*)
        [lambda {|n| Classic.fact_r(n)}, lambda {|n| Classic.fact_i(n)},
	        lambda {|n| Classic.fact_lp(n)}].each{ |f|
          expect(ans).to eq(f.call(num))
        }
      }
    end
  end

  describe 'spec_expt' do
    it 'raise b to n' do
      params1, params2 = [2.0, 11.0, 20.0], [3.0, 6.0, 10.0]
      Util.cartesian_prod(params1, params2).each{|b, n|
        #ans = b ** n
        ans = (1 .. n).reduce(1) {|acc, el| acc * b}
        [lambda {|b, n| Classic.expt_r(b, n)}, lambda {|b, n| Classic.expt_i(b, n)},
            lambda {|b, n| Classic.expt_lp(b, n)}].each{|f|
          # expect(ans).must_be_close_to f.call(b, n), (ans * epsilon)
          expect(Util.in_epsilon(ans * epsilon, ans, f.call(b, n)))
      }}
    end
  end
end

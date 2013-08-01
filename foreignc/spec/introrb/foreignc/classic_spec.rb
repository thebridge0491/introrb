require 'spec_helper'

module Introrb::Foreignc; end

Classic = Introrb::Foreignc::Classic
epsilon = 0.001

describe 'Introrb::Foreignc::ClassicSpec' do
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
      Util.cartesian_prod(params1, params2).each{|b, n|
        ans = b ** n
        [lambda {|b, n| Classic.expt_lp(b, n)}, lambda {|b, n| Classic.expt_i(b, n)}].each{|f|
          # expect(ans).must_be_close_to f.call(b, n), (ans * epsilon)
          expect(Util.in_epsilon(ans * epsilon, ans, f.call(b, n)))
      }}
    end
  end
end

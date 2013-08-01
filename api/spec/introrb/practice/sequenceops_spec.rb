require 'spec_helper'

module Introrb::Practice; end

Seqops = Introrb::Practice::Sequenceops
epsilon = 0.001

arr, revarr = (0 ... 5).to_a, (4 ... -1).step(-1).to_a

describe 'Introrb::Practice::SequenceopsSpec' do
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

  describe 'spec_index' do
    it 'index el arr' do
      [arr, revarr].each{|arr0|
        #ans1, ans2 = arr0.find_index(3), arr0.find_index(-20)
        ans1 = arr0.each_with_index.reduce(nil) {|acc, el_idx|
          nil == acc && 3 == el_idx[0] ? el_idx[1] : acc}
        ans2 = arr0.each_with_index.reduce(nil) {|acc, el_idx|
          nil == acc && -20 == el_idx[0] ? el_idx[1] : acc}
        [lambda {|e, a| Seqops.index_i(e, a)},
	        lambda {|e, a| Seqops.index_lp(e, a)}].each{ |f|
          expect(ans1).to eq(f.call(3, arr0))
          expect(ans2).to eq(f.call(-20, arr0))
        }
      }
    end
  end

  describe 'spec_reverse' do
    it 'reverse arr' do
      [arr, revarr].each{|arr0|
        #ans = arr0.map{|e| e}.to_a.reverse
        #ans = arr0.clone.reverse
        ans = arr0.reduce([]) {|acc, el| [el] + acc}
        [lambda {|a| Seqops.reverse_r(a)}, lambda {|a| Seqops.reverse_i(a)},
            lambda {|a| Seqops.reverse_lp(a)}].each{|f|
          expect(ans).to eq(f.call(Seqops.copy_of_r(arr0)))
      }}
    end
  end
end

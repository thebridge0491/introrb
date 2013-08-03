require 'spec_helper'
require 'set'

module Introrb::Intro; end

epsilon = 0.001

arr, revarr = (0 ... 5).to_a, (4 ... -1).step(-1).to_a

describe 'Introrb::Intro::CollectionsSpec' do
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
  
  describe 'spec_arrays' do
    it 'specs arrays' do
      expect([].push(1)).to eq([1])
      expect([]).not_to eq([0, 1, 2])
      expect(5).to eq(arr.count)
      expect(revarr[0]).to eq(arr[-1])
      expect([2, 1, 0] + [9, 9, 9]).to eq([2, 1, 0, 9, 9, 9])
      expect(arr).to eq(revarr.reverse)
      expect([0, 2, 4]).to eq(arr.select{|e| 0 == e % 2})
      arr1 = arr.clone.delete_if{|e| 2 == e}
      expect(arr1).to eq([0, 1, 3, 4])
      expect([2, 3, 4, 5, 6]).to eq(arr.map{|e| e + 2})
      expect(arr.sort).to eq(revarr.sort)
    end
  end
  
  describe 'spec_sets' do
    it 'specs sets' do
      expect(['i'].to_set).to eq(Set['i'])
      set1, set2 = Set['k', 'p', 'a', 'e', 'u', 'k', 'a'], Set['q', 'p', 'z', 'u']
      expect(set1.sort).to eq(['a', 'e', 'k', 'p', 'u'])
      expect(set1.union(set2).sort).to eq(['a', 'e', 'k', 'p', 'q', 'u', 'z'])
      expect(set1.intersection(set2)).to eq(['p', 'u'].to_set)
      expect(set1.difference(set2)).to eq(['a', 'e', 'k'].to_set)
      expect(set1.union(set2) - set1.intersection(set2)).to eq(['a', 'e', 'k', 'q', 'z'].to_set)
    end
  end
  
  describe 'spec_hashes' do
    it 'specs hashes' do
      arr1 = ['k', 'p', 'a', 'e', 'u', 'k', 'a']
      #hash1 = arr1.each_index.map{|i| "ltr #{i % 5}".to_sym}.zip(arr1).to_h
      hash1 = arr1.each_with_index.map{|e, i| [:"ltr #{i % 5}", e]}.to_h
      expect({'ltr 0': 'a'}).to eq({'ltr 0': 'a'})
      expect(hash1).to eq({'ltr 0': 'k', 'ltr 1': 'a', 'ltr 2': 'a', 'ltr 3': 'e', 'ltr 4': 'u'})
      expect('a').to eq(hash1[:'ltr 2'])
      hash1.delete(:'ltr 2')
      expect(hash1.has_key?(:'ltr 2')).not_to be
      hash1[:'ltr 2'] = 'Z'
      expect(hash1.keys.sort).to eq([:'ltr 0', :'ltr 1', :'ltr 2', :'ltr 3', :'ltr 4'])
    end
  end
end

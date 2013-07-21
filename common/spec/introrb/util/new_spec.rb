require 'spec_helper'

module Introrb::Util; end

epsilon = 0.001

describe 'Introrb::Util::NewSpec' do
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
  
  describe 'spec_version_exists' do
    it 'version exists' do
      expect(::Introrb::Util::VERSION).not_to be_nil
    end
  end

  describe 'spec_method' do
    it 'values are equal' do
      expect(4).to eq(2 * 2)
    end
  end

  describe 'spec_strMethod' do
    it 'strings are equal' do
      expect('Hello').to eq('Hello')
    end
  end

  describe 'spec_dblMethod' do
    it 'doubles are equal' do
      # expect(4.0).to be_within(4.0 * epsilon).of(4.0)
      expect(in_epsilon(4.0 * epsilon, 4.0, 4.0)).to be
    end
  end

  describe 'spec_failedMethod' do
    it 'values are equal' do
      expect(5).to eq(2 * 2)
    end
  end

  describe 'spec_ignoredMethod' do
    it 'method is ignored' do
      skip 'not implemented'
      expect(false).to be
    end
  end

  describe 'spec_expectedThrow' do
    it 'ZeroDivisionError is thrown' do
      expect {
      begin
	    1/0
	  rescue ZeroDivisionError => e
	    throw ZeroDivisionError
	  end
	  }.to throw_symbol(ZeroDivisionError)
    end
  end

  describe 'spec_expectedException' do
    it 'Exception is raised' do
      expect { raise Exception }.to raise_error(Exception)
    end
  end
end

require 'rspec'
require 'simplecov'

require 'introrb/practice'
require 'introrb/util'

Util = Introrb::Util

module SimpleCov::Configuration
  def clean_filters
    @filters = []
  end
end if defined? SimpleCov

if ENV.fetch('COV', false)
  SimpleCov.configure do
    clean_filters
    load_profile 'test_frameworks'
  end
  SimpleCov.start do
    add_filter '/.rvm/'
  end
end if defined? SimpleCov

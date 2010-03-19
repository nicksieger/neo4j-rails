begin
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end
Bundler.require :default, :test

require 'spec'
require 'spec/interop/test'

# Since we're using spec/interop/test, we might as well add our
# helpers to T::U::TC
class Test::Unit::TestCase
  def self.use_transactions
    before :each do
      Neo4j::Transaction.new
    end

    after :each do
      Neo4j::Transaction.failure
    end
  end

  def with_transaction(&block)
    Neo4j::Transaction.run(&block)
  end

  # HAX: including a module of test_ methods doesn't seem to get them
  # registered, so I'm registering them manually
  def self.include_tests(mod)
    include mod
    mod.instance_methods(false).each do |m|
      example(m, {}) {__send__ m}
    end
  end
end

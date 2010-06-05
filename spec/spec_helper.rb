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
      Neo4j::Transaction.finish
    end
  end

  def txn(&block)
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

  after :each do
    txn { fixtures.each { |obj| obj.del rescue nil } }
  end

  def fixtures
    @fixtures ||= []
  end

  def fixture(obj)
    self.fixtures << obj
    obj
  end

  def self.insert_dummy_model
    before :each do
      txn do
        @model = fixture(Neo4j::Model.new)
        @model.save
      end
    end
  end

  module TempModel
    @@_counter = 1
    def self.set(klass)
      name = "Model_#{@@_counter}"
      @@_counter += 1
      const_set(name,klass)
      klass
    end
  end

  def model_subclass(&block)
    TempModel.set(Class.new(Neo4j::Model, &block))
  end
end

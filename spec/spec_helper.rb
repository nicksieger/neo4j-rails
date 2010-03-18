env = File.expand_path('../../.bundle/environment.rb', __FILE__)
abort unless File.exist?(env)
require env
Bundler.require :default, :test

require 'spec'

module Neo4j::SpecHelper
  def with_transaction(&block)
    Neo4j::Transaction.run(&block)
  end
end

class Neo4j::TransactionExampleGroup < ::Spec::Example::ExampleGroup
  before :each do
    Neo4j::Transaction.new
  end

  after :each do
    Neo4j::Transaction.failure
  end

  ::Spec::Example::ExampleGroupFactory.register(:neotx, self)
end

Spec::Runner.configure do |config|
  config.include Neo4j::SpecHelper
end

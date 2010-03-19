require File.expand_path('../../spec_helper', __FILE__)
require 'neo4j/model'

describe Neo4j::Model do
  it "should fail to create a new model without a transaction" do
    lambda { Neo4j::Model.new }.should raise_error
  end
end

describe Neo4j::Model, "lint" do
  use_transactions

  before :each do
    @model = Neo4j::Model.new
  end

  include_tests ActiveModel::Lint::Tests
end

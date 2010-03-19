require File.expand_path('../../spec_helper', __FILE__)
require 'neo4j/model'

class IceCream < Neo4j::Model
  validates_presence_of :flavour
end

describe Neo4j::Model, "new" do
  before :each do
    @model = Neo4j::Model.new
  end
  subject { @model }

  it { should_not be_persisted }

  it "should allow access to properties before it is saved" do
    @model["fur"] = "none"
    @model["fur"].should == "none"
  end

  it "should fail to save new model without a transaction" do
    lambda { @model.save }.should raise_error
  end
end

describe Neo4j::Model, "load" do
  before :each do
    with_transaction do
      @model = Neo4j::Model.new
      @model.save
    end
  end

  it "should load a previously stored node" do
    result = Neo4j::Model.load(@model.id)
    result.should == @model
    result.should be_persisted
  end
end

describe Neo4j::Model, "save" do
  use_transactions
  before :each do
    @model = IceCream.new
    @model[:flavour] = "vanilla"
  end

  it "should store the model in the database" do
    with_transaction do
      @model.save
    end
    @model.should be_persisted
    IceCream.load(@model.id).should == @model
  end

  it "should not save the model if it is invalid" do
    @model = IceCream.new
    @model.save.should_not be_true
    @model.should_not be_valid
    @model.should_not be_persisted
    @model.id.should be_nil
  end
end

describe Neo4j::Model, "lint" do
  before :each do
    @model = Neo4j::Model.new
  end

  include_tests ActiveModel::Lint::Tests
end

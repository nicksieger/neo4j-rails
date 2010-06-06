require File.expand_path('../../spec_helper', __FILE__)
require 'neo4j/model'

class IceCream < Neo4j::Model
  property :flavour
  index :flavour
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
    txn do
      @model = fixture(Neo4j::Model.new)
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
    @model = fixture(IceCream.new)
    @model.flavour = "vanilla"
  end

  it "should store the model in the database" do
    @model.save
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

describe Neo4j::Model, "find" do
  before :each do
    txn do
      @model = fixture(IceCream.new)
      @model.flavour = "vanilla"
      @model.save
    end
  end
  use_transactions

  it "should load all nodes of that type from the database" do
    IceCream.all.should include(@model)
  end

  it "should find a model by one of its attributes" do
    IceCream.find(:flavour => "vanilla").to_a.should include(@model)
  end
end

describe Neo4j::Model, "lint" do
  before :each do
    @model = Neo4j::Model.new
  end

  include_tests ActiveModel::Lint::Tests
end

describe Neo4j::Model, "destroy" do
  insert_dummy_model

  it "should remove the model from the database" do
    txn { @model.destroy }
    txn { Neo4j::Model.load(@model.id).should be_nil }
  end
end

describe Neo4j::Model, "create" do
  use_transactions

  it "should save the model and return it" do
    model = Neo4j::Model.create
    model.should be_persisted
  end

  it "should accept attributes to be set" do
    model = Neo4j::Model.create :name => "Nick"
    model[:name].should == "Nick"
  end

  it "bang version should raise an exception if save returns false" do
    lambda { IceCream.create! }.should raise_error(Neo4j::Model::RecordInvalidError)
  end

  it "should run before and after create callbacks" do
    klass = model_subclass do
      property :created, :type => DateTime
      before_create :timestamp
      def timestamp
        self.created = DateTime.now
      end
      after_create :mark_saved
      attr_reader :saved
      def mark_saved
        @saved = true
      end
    end
    klass.marshal?(:created).should be_true
    model = klass.create!
    model.created.should_not be_nil
    model.saved.should_not be_nil
  end
end

describe Neo4j::Model, "update_attributes" do
  insert_dummy_model

  it "should save the attributes" do
    txn { @model.update_attributes(:a => 1, :b => 2).should be_true }
    txn { @model[:a].should == 1; @model[:b].should == 2 }
  end

  it "should not update the model if it is invalid" do
    klass = model_subclass do
      property :name
      validates_presence_of :name
    end
    model = nil
    txn { model = fixture(klass.create!(:name => "vanilla")) }
    txn { model.update_attributes(:name => nil).should be_false }
    txn { model.name.should == "vanilla" }
  end
end

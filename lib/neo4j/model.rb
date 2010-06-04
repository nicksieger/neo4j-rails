require 'neo4j'
require 'neo4j/extensions/reindexer'
require 'active_model'
require 'neo4j/delayed_create'

class Neo4j::Model
  include Neo4j::NodeMixin
  include Neo4j::DelayedCreate
  include ActiveModel::Conversion
  include ActiveModel::Validations

  class RecordInvalidError < RuntimeError
    attr_reader :record
    def initialize(record)
      @record = record
      super(@record.errors.full_messages.join(", "))
    end
  end

  def persisted?
    @persisted
  end

  def read_attribute_for_validation(key)
    self[key]
  end

  def destroy
    del
  end

  def save!
    unless save
      raise RecordInvalidError.new(self)
    end
  end

  def self.load(*ids)
    result = ids.map {|id| Neo4j.load_node(id) }
    if ids.length == 1
      result.first
    else
      result
    end
  end

  def self.all
    super.nodes
  end

  # Handle Model.find(params[:id])
  def self.find(*args)
    if args.length == 1 && String === args[0] && args[0].to_i != 0
      load(*args)
    else
      super
    end
  end

  def self.create(*args)
    new(*args).tap {|model| model.save }
  end

  def self.create!(*args)
    new(*args).tap {|model| model.save! }
  end
end

require 'neo4j'
require 'neo4j/extensions/reindexer'
require 'active_model'
require 'neo4j/delayed_save'

class Neo4j::Model
  include Neo4j::NodeMixin
  include Neo4j::DelayedSave
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Callbacks
  define_model_callbacks :create, :save, :update, :destroy

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

  def attributes=(attrs)
    attrs.each do |k,v|
      if respond_to?("#{k}=")
        send("#{k}=", v)
      else
        self[k] = v
      end
    end
  end

  def update_attributes(attributes)
    self.attributes = attributes
    save
  end

  def update_attributes!(attributes)
    self.attributes = attributes
    save!
  end

  def destroy
    _run_destroy_callbacks do
      del
    end
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

  def self.inherited(subc) # :nodoc:
    # Make subclasses of Neo4j::Model each have their own root class/indexer
    subc.instance_eval do
      def root_class
        self
      end
    end
  end
end

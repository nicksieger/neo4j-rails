require 'neo4j'
require 'active_model'
require 'neo4j/delayed_create'

class Neo4j::Model
  include Neo4j::NodeMixin
  include Neo4j::DelayedCreate
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    @persisted
  end

  def read_attribute_for_validation(key)
    self[key]
  end

  def self.load(*ids)
    result = ids.map {|id| Neo4j.load_node(id) }
    if ids.length == 1
      result.first
    else
      result
    end
  end
end

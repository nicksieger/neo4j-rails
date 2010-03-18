require 'neo4j'
require 'active_model'

class Neo4j::Model
  include Neo4j::NodeMixin
  include ActiveModel::Conversion
  include ActiveModel::Validations
end

require 'rails/railtie'
require 'neo4j/transaction_management'

module Neo4j
  class Railtie < Rails::Railtie
    railtie_name :neo4j

    config.middleware.use Neo4j::TransactionManagement

    initializer "neo4j.config" do |app|
      Neo4j::Config.setup.merge!(app.config.neo4j.to_hash)
    end
  end
end

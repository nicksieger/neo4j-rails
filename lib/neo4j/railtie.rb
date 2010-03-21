require 'rails/railtie'
require 'neo4j/transaction_management'

module Neo4j
  class Railtie < Rails::Railtie
    railtie_name :neo4j

    initializer "neo4j.config" do |app|
      Neo4j::Config.setup.merge!(app.config.neo4j.to_hash)
      app.config.middleware.use Neo4j::TransactionManagement
    end
  end
end

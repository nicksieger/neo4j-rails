require 'rails/railtie'
require 'neo4j/transaction_management'

module Neo4j
  class Railtie < Rails::Railtie
    initializer "neo4j.config" do |app|
      Neo4j::Config.setup.merge!(app.config.neo4j.to_hash) if app.config.respond_to?(:neo4j)
    end

    initializer "neo4j.tx" do |app|
      app.config.middleware.use Neo4j::TransactionManagement
    end
  end
end

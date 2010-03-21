class Neo4j::TransactionManagement
  def initialize(app)
    @app = app
  end

  def call(env)
    Neo4j::Transaction.new
    @app.call(env)
  ensure
    Neo4j::Transaction.finish if Neo4j::Transaction.running?
  end
end

class Neo4j::TransactionManagement
  def initialize(app)
    @app = app
  end

  def call(env)
    Transaction.new
    @app.call(env)
  ensure
    Transaction.finish if Transaction.running?
  end
end

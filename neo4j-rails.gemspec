# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{neo4j-rails}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Sieger"]
  s.date = %q{2010-04-08}
  s.description = %q{Adapts Neo4j for Rails 3 apps using ActiveModel}
  s.email = ["nick@nicksieger.com"]
  s.files = ["./Gemfile", "./Gemfile.lock", "./lib", "./neo4j-rails.gemspec", "./Rakefile", "./README.markdown", "./spec", "./tmp", "./lib/neo4j", "./lib/neo4j-rails", "./lib/neo4j-rails.rb", "./lib/neo4j/delayed_create.rb", "./lib/neo4j/model.rb", "./lib/neo4j/rails.rb", "./lib/neo4j/railtie.rb", "./lib/neo4j/transaction_management.rb", "./lib/neo4j-rails/version.rb", "./spec/neo4j", "./spec/spec_helper.rb", "./spec/neo4j/model_spec.rb", "./tmp/neo4j", "./tmp/neo4j/active_tx_log", "./tmp/neo4j/neostore", "./tmp/neo4j/neostore.id", "./tmp/neo4j/neostore.nodestore.db", "./tmp/neo4j/neostore.nodestore.db.id", "./tmp/neo4j/neostore.propertystore.db", "./tmp/neo4j/neostore.propertystore.db.arrays", "./tmp/neo4j/neostore.propertystore.db.arrays.id", "./tmp/neo4j/neostore.propertystore.db.id", "./tmp/neo4j/neostore.propertystore.db.index", "./tmp/neo4j/neostore.propertystore.db.index.id", "./tmp/neo4j/neostore.propertystore.db.index.keys", "./tmp/neo4j/neostore.propertystore.db.index.keys.id", "./tmp/neo4j/neostore.propertystore.db.strings", "./tmp/neo4j/neostore.propertystore.db.strings.id", "./tmp/neo4j/neostore.relationshipstore.db", "./tmp/neo4j/neostore.relationshipstore.db.id", "./tmp/neo4j/neostore.relationshiptypestore.db", "./tmp/neo4j/neostore.relationshiptypestore.db.id", "./tmp/neo4j/neostore.relationshiptypestore.db.names", "./tmp/neo4j/neostore.relationshiptypestore.db.names.id", "./tmp/neo4j/nioneo_logical.log.active", "./tmp/neo4j/tm_tx_log.1"]
  s.homepage = %q{http://jruby.org}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Neo4j adapter for Rails 3}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0.0.beta2"])
      s.add_runtime_dependency(%q<neo4j>, [">= 0.4.1"])
    else
      s.add_dependency(%q<rails>, [">= 3.0.0.beta2"])
      s.add_dependency(%q<neo4j>, [">= 0.4.1"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0.0.beta2"])
    s.add_dependency(%q<neo4j>, [">= 0.4.1"])
  end
end

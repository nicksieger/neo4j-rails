# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{neo4j-rails}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Sieger"]
  s.date = %q{2010-04-08}
  s.description = %q{Adapts Neo4j for Rails 3 apps using ActiveModel}
  s.email = ["nick@nicksieger.com"]
  s.files = ["lib/neo4j-rails.rb", "lib/neo4j/delayed_create.rb", "lib/neo4j/model.rb", "lib/neo4j/rails.rb", "lib/neo4j/railtie.rb", "lib/neo4j/transaction_management.rb", "lib/neo4j-rails/version.rb", "spec/spec_helper.rb", "spec/neo4j/model_spec.rb", "Gemfile", "Gemfile.lock", "neo4j-rails.gemspec", "LICENSE.txt", "Rakefile", "README.markdown"]
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

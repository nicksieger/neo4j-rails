require 'rubygems'

require './lib/neo4j-rails/version'
gemspec = Gem::Specification.new do |s|
  s.name = %q{neo4j-rails}
  s.version = Neo4jRails::VERSION
  s.authors = ["Nick Sieger"]
  s.date = Date.today.to_s
  s.description = %{Adapts Neo4j for Rails 3 apps using ActiveModel}
  s.summary = %q{Neo4j adapter for Rails 3}
  s.email = ["nick@nicksieger.com"]
  s.files = FileList["./**/*"].exclude("*.gem")
  s.homepage = %q{http://jruby.org}
  s.has_rdoc = false
  s.add_dependency('rails', ">= 3.0.0.beta1")
  s.add_dependency('neo4j')
end

task :gemspec do
  File.open("neo4j-rails.gemspec", "w") {|f| f << gemspec.to_ruby }
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new

task :default => :spec

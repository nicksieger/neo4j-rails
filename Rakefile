require 'rubygems'
require 'date'

require './lib/neo4j-rails/version'
gemspec = Gem::Specification.new do |s|
  s.name = %q{neo4j-rails}
  s.version = Neo4jRails::VERSION
  s.authors = ["Nick Sieger"]
  s.date = Date.today.to_s
  s.description = %{Adapts Neo4j for Rails 3 apps using ActiveModel}
  s.summary = %q{Neo4j adapter for Rails 3}
  s.email = ["nick@nicksieger.com"]
  s.files = FileList["lib/**/*", "spec/**/*",
                     *%w(Gemfile neo4j-rails.gemspec History.txt LICENSE.txt Rakefile README.markdown)
                    ].select {|f| File.file?(f) }
  s.homepage = %q{http://jruby.org}
  s.has_rdoc = false
  s.add_dependency('rails', ">= 3.0.0.beta2")
  s.add_dependency('neo4j', ">= 0.4.3")
end

task :gemspec do
  File.open("neo4j-rails.gemspec", "w") {|f| f << gemspec.to_ruby }
end

require 'rake/gempackagetask'
Rake::GemPackageTask.new(gemspec) do |pkg|
end
task :package => :spec

task :release => :package do
  if Neo4jRails::VERSION != ENV['VERSION']
    abort "Versions do not match: #{Neo4jRails::VERSION.inspect} != #{ENV['VERSION'].inspect}"
  end
  sh "gem push pkg/neo4j-rails-#{Neo4jRails::VERSION}.gem"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new

task :default => :spec

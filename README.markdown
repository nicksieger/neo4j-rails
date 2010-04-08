# Neo4j-Rails

This is an experimental library for playing with an
ActiveModel-charged version of the Neo4j Ruby library. The intent is
to use it as a full replacement for ActiveRecord inside a Rails 3
application.

Of course you can use Neo4j as is in a Rails application, but this
library uses ActiveModel to make the API and usage even closer to
ActiveRecord.

# Usage

Include the 'neo4j-rails' library in your Gemfile to use in your
project.

    gem "neo4j-rails", :git => "git://github.com/nicksieger/neo4j-rails.git"

Extend Neo4j::Model to create your model node classes.

    class IceCream < Neo4j::Model
      property :flavour
      validates_presence_of :flavour
    end

    IceCream.new.valid?  # => false
    IceCream.new(:flavour => "vanilla").valid?  # => true

# TODO

The library is still in early stages and is mostly a demonstration at
this point. Still missing to complete the ActiveRecord API:

* Neo4j::Model#update_attributes
* Neo4j::Model#destroy
* Finder methods for searching for nodes

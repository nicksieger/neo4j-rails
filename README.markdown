# Neo4j-Rails

This is an experimental library for playing with an
ActiveModel-charged version of the [Neo4j.rb][neo4j] Ruby library. The
intent is to use it as a full replacement for ActiveRecord inside a
Rails 3 application.

Of course you can use Neo4j.rb as is in a Rails application, but this
library uses ActiveModel to make the API and usage even closer to
ActiveRecord. One example of this is the way `Model.new` works.

In Neo4j.rb, `Node.new` requires a transaction and immediately stores
the node in the database.In Neo4j-Rails, object initialization matches
ActiveRecord-style two-step `Model.new` + `Model#save` creation. This
makes it easier to create forms that don't touch the database if
validation fails.

# Usage

Include the 'neo4j-rails' library in your Gemfile to use in your
project.

    gem "neo4j-rails"

Extend Neo4j::Model to create your model node classes.

    class IceCream < Neo4j::Model
      property :flavour
      validates_presence_of :flavour
    end

    IceCream.new.valid?  # => false
    IceCream.new(:flavour => "vanilla").valid?  # => true

Configure the location of the Neo4j database and Lucene index files on
disk. The Lucene search index will normally be created in memory, so
set `store_on_file = true` to save it to disk. Usually these settings
will go in `config/application.rb` or `config/environments/*.rb`.

    Rails.application.configure do
      config.neo4j.storage_path = "/var/neo4j"
      config.lucene.storage_path = "/var/lucene"
      config.lucene.store_on_file = true
    end

# API

Many of the familiar API methods from ActiveRecord are duplicated in
Neo4j::Model. Neo4j::Model includes ActiveModel::Validations,
ActiveModel::Conversions, and ActiveModel::Callbacks.

    class Neo4j::Model
      def valid?; end
      def save; end
      def save!; end
      def update_attributes(attributes); end
      def update_attributes!(attributes); end
      def destroy; end
      def attributes=(attrs); end
      def reload; end
      def self.all; end
      def self.find(*); end
      def self.create(attributes); end
      def self.create!(attributes); end
    end

# License

Neo4j-Rails is available under the terms of the MIT license (see
LICENSE.txt for details).

However, Neo4j-Rails also depends on the [Neo4j.rb library][neo4j], and the MIT
license does not replace or cover the licensing terms of its own
library or its components.

[neo4j]: http://github.com/andreasronge/neo4j

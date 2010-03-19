# Extension to Neo4j::NodeMixin to delay creation until #save is
# called.
module Neo4j::DelayedCreate
  def id
    persisted? ? neo_id : nil
  end

  # Override NodeMixin#init_without_node to save the properties for
  # when #save is called.
  def init_without_node(props) # :nodoc:
    props[:_classname] = self.class.to_s
    @_new_props = props
    @persisted = false
  end

  # Ensure nodes loaded from the database are marked as persisted.
  def init_with_node(node)
    super
    @persisted = true
  end

  # Delegate property access to temporary properties if they exist
  def [](key)
    if @_new_props
      @_new_props[key]
    else
      super
    end
  end

  # Delegate property write to temporary properties if they exist
  def []=(key, value)
    if @_new_props
      @_new_props[key] = value
    else
      super
    end
  end

  def save
    if valid?
      if @persisted
        update
      else
        @_java_node = Neo4j.create_node @_new_props
        @_java_node._wrapper = self
        Neo4j.event_handler.node_created(self)
        @_new_props = nil
        @persisted = true
      end
    end
  end
end

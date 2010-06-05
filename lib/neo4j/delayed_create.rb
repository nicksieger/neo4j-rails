# Extension to Neo4j::NodeMixin to delay creation until #save is
# called.
module Neo4j::DelayedCreate
  def id
    persisted? ? neo_id : nil
  end

  # Override NodeMixin#init_without_node to save the properties for
  # when #save is called.
  def init_without_node(props) # :nodoc:
    raise "Can't use Neo4j::Model with anonymous classes" if self.class.name == ""
    props[:_classname] = self.class.name
    @_new_props = props || {}
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
      _run_save_callbacks do
        if @persisted
          _run_update_callbacks do
            update
          end
        else
          _run_create_callbacks do
            @_java_node = Neo4j.create_node
            @_java_node._wrapper = self
            if @_new_props && !@_new_props.empty?
              @_new_props.each {|k,v| @_java_node[k] = v }
              update_index
            end
            Neo4j.event_handler.node_created(self)
            @_new_props = nil
            @persisted = true
          end
        end
      end
    end
  end
end

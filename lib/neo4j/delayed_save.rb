# Extension to Neo4j::NodeMixin to delay creating/updating properties
# until #save is called.
module Neo4j::DelayedSave
  def id
    persisted? ? neo_id : nil
  end

  # Override NodeMixin#init_without_node to save the properties for
  # when #save is called.
  def init_without_node(props) # :nodoc:
    raise "Can't use Neo4j::Model with anonymous classes" if self.class.name == ""
    props[:_classname] = self.class.name
    @_unsaved_props = props || {}
    @persisted = false
  end

  # Ensure nodes loaded from the database are marked as persisted.
  def init_with_node(node)
    super
    @persisted = true
    @_unsaved_props = {}
  end

  # Delegate property access to temporary properties first
  def [](key)
    if @_unsaved_props.has_key?(key)
      @_unsaved_props[key]
    elsif @_java_node
      @_java_node[key]
    end
  end

  # Delegate property write to temporary properties
  def []=(key, value)
    @_unsaved_props[key] = value
  end

  def reload(*)
    @_unsaved_props.clear
    self
  end
  alias_method :reset, :reload

  def save
    if valid?
      _run_save_callbacks do
        if @persisted
          _run_update_callbacks do
            @_unsaved_props.each {|k,v| @_java_node[k] = v }
            @_unsaved_props.clear
          end
        else
          _run_create_callbacks do
            @_java_node = Neo4j.create_node
            @_java_node._wrapper = self
            @_unsaved_props.each {|k,v| @_java_node[k] = v }
            @_unsaved_props.clear
            update_index
            Neo4j.event_handler.node_created(self)
            @persisted = true
          end
        end
      end
      true
    end
  end
end

module NoIntegrity

  def self.included(a_module)
    a_module.module_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def no_attr_store(storage_attribute = nil)
      if storage_attribute && @no_attr_store.nil?
        alias_no_attr_store(storage_attribute)
        @no_attr_store = storage_attribute
      end

      return @no_attr_store
    end

    def no_attributes
      @no_attributes || { }
    end

    def no_attribute(attribs, options = { })
      @no_attributes ||= { }

      attribs = [attribs] unless attribs.is_a?(Array)

      attribs.each do |attrib|
        @no_attributes[attrib.to_sym] = options
        setup_no_attribute_accessors(attrib, options[:type])
        update_no_attribute_mappings(attrib, options)
      end
    end

    def no_attribute_mappings
      @no_attribute_mappings
    end

    private

    def update_no_attribute_mappings(attrib, options)
      @no_attribute_mappings ||= { }
      @no_attribute_mappings[attrib.to_sym] = options
    end

    def setup_no_attribute_accessors(attrib, coercion_type = nil)
      module_eval <<-STR
        def #{attrib}; get_no_attribute('#{attrib}'); end
        def #{attrib}?; !!get_no_attribute('#{attrib}'); end
        def #{attrib}=(v); set_no_attribute('#{attrib}', coerce_no_attribute_type(v, '#{coercion_type}')); end
      STR
    end

    def alias_no_attr_store(old_name)
      module_eval <<-STR, __FILE__, __LINE__ + 1
        def __no_attr_store; self.#{old_name}; end
        def __no_attr_store=(v); self.#{old_name} = v; end
      STR
    end

  end

  def no_attributes
    self.class.no_attributes
  end

  def no_attribute_mappings
    self.class.no_attribute_mappings
  end

  def update_no_attributes(new_attributes)
    raise "Type mismatch: I received a #{new_attributes.class} when I was expecting a Hash." unless new_attributes.is_a?(Hash)
    new_attributes.each do |key, value|
      self.send("#{key}=", value)
    end
    return self.send(self.class.no_attr_store)
  end

  private

  def get_no_attribute(attribute_name)
    initialize_no_attribute_store!
    no_val = self.__no_attr_store[attribute_name.to_sym]

    no_val.nil? ? no_attribute_mappings[attribute_name.to_sym][:default] : no_val
  end

  def set_no_attribute(attribute_name, value)
    initialize_no_attribute_store!
    self.__no_attr_store[attribute_name.to_sym] = value
  end

  def initialize_no_attribute_store!
    return true if @__initialized_attribute_store
    # Initialize an empty hash if we are something else...
    self.__no_attr_store = { } unless self.__no_attr_store.is_a?(Hash)
    # Symbolize all of the keys
    self.__no_attr_store = Hash[self.__no_attr_store.map { |k, v| [k.to_sym, v] }]
    @__initialized_attribute_store = true
  end

  def coerce_no_attribute_type(value, type)
    return value if (type == nil) || (type == '')
    value = case type
    when 'Boolean';
      case value.to_s
      when "true", "1"; true
      when "false", "0"; false
      else; !!value
      end
    when 'Integer'; value.to_i
    when 'String';  value.to_s
    else
      raise "Unsure of what to do with #{type}!!"
    end

    return value
  end

end
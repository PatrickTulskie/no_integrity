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
    
    def no_attribute(options)
      @no_attributes ||= { }
      if options.is_a?(Hash)
        options.keys.each do |attrib|
          @no_attributes[attrib] = options[attrib]
          setup_no_attribute_functions(attrib, options[attrib])
        end
      elsif options.is_a?(Array)
        options.each do |attrib|
          @no_attributes[attrib] = nil
          setup_no_attribute_functions(attrib, nil)
        end
      elsif options.is_a?(Symbol)
        setup_no_attribute_functions(options)
      end
    end
    
    private
    
    def setup_no_attribute_functions(attrib, coercion_type = nil)
      module_eval <<-STR
        def #{attrib}; get_no_attribute('#{attrib}'); end
        def #{attrib}?; !!get_no_attribute('#{attrib}'); end
        def #{attrib}=(v); set_no_attribute('#{attrib}', coerce_no_attribute_type(v, '#{coercion_type}')); end
      STR
    end
    
    def alias_no_attr_store(old_name)
      module_eval <<-STR, __FILE__, __LINE__ + 1
        def __no_attr_store; self.#{old_name}; end
        def __no_attr_store?; self.#{old_name}?; end
        def __no_attr_store=(v); self.#{old_name} = v; end
      STR
    end
    
  end
  
  def no_attributes
    self.class.no_attributes
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
    return nil unless self.__no_attr_store.is_a?(Hash)
    self.__no_attr_store = normalize_keys(__no_attr_store)
    self.__no_attr_store[attribute_name.to_s]
  end
    
  def set_no_attribute(attribute_name, value)
    self.__no_attr_store = normalize_keys(__no_attr_store)
    if self.__no_attr_store.is_a?(Hash)
      self.__no_attr_store[attribute_name.to_s] = value
    else
      self.__no_attr_store = { attribute_name.to_s => value }
    end
  end
  
  def normalize_keys(store)
    return store if @__performed_key_normalization || !store.is_a?(Hash)
    store.keys.each { |key| store[key.to_s] = store.delete(key) }
    @__performed_key_normalization = true
    return store
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
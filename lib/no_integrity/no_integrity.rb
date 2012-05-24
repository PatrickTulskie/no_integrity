module NoIntegrity
  
  def self.included(a_module)
    a_module.module_eval do
      extend ClassMethods
    end
  end
  
  module ClassMethods
    def no_attr_store(storage_attribute = nil)
      @no_attr_store ||= storage_attribute
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
        def #{attrib}; #{@no_attr_store}.is_a?(Hash) ? #{@no_attr_store}[:#{attrib}] : nil; end
        def #{attrib}?; #{@no_attr_store}.is_a?(Hash) ? !!#{@no_attr_store}[:#{attrib}] : false; end
        def #{attrib}=(v)
          v = coerce_no_attribute_type(v, '#{coercion_type}')
          if #{@no_attr_store}.is_a?(Hash)
            (#{@no_attr_store}[:#{attrib}] = v)
          else
            self.#{@no_attr_store} = { :#{attrib} => v }
          end
        end
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
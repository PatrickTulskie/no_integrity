module NoIntegrity
  
  def self.included(a_module)
    a_module.module_eval do
      extend ClassMethods
    end
  end
  
  module ClassMethods
    def attr_store(storage_attribute = nil)
      @attr_store ||= storage_attribute
    end
    
    def no_attributes(*attrs)
      @no_attributes ||= []
      @no_attributes += attrs
      @no_attributes.uniq!
      @no_attributes.each do |attrib|
        module_eval <<-STR
          def #{attrib}; #{@attr_store}.is_a?(Hash) ? #{@attr_store}[:#{attrib}] : nil; end
          def #{attrib}?; #{@attr_store}.is_a?(Hash) ? !!#{@attr_store}[:#{attrib}] : false; end
          def #{attrib}=(v); #{@attr_store}.is_a?(Hash) ? (#{@attr_store}[:#{attrib}] = v) : self.#{@attr_store} = { :#{attrib} => v }; end
        STR
      end
      return @no_attributes
    end
    
  end
  
  def no_attributes
    self.class.no_attributes
  end
  
  def update_no_attributes(new_attributes)
    raise "Type mismatch: I received a #{new_attributes.class} when I was expecting a Hash." unless new_attributes.is_a?(Hash)
    new_attributes.reject! { |key, value| !no_attributes.include?(key) }
    self.send("#{self.class.attr_store}").merge!(new_attributes)
    return new_attributes
  end
  
end
module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var = "@#{name}".to_sym
        define_method("#{name}_history") do
          eval "@#{name}_history ||= []"
        end
        define_method(name) { instance_variable_get(var) }
        define_method("#{name}=") do |value|
          instance_variable_set(var, value)
          eval "#{name}_history << #{value}"
        end
      end
    end

    def strong_attr_accessor(name, type)
      var = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var) }
      define_method("#{name}=") do |value|
        eval "raise TypeError if !#{value}.is_a? #{type}"
        instance_variable_set(var, value)
      end
    end
  end
end

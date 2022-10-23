module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, type, *args)
      class_variable_set('@@validation_list'.to_sym, []) unless class_variable_defined? :@@validation_list
      unless method_defined? :validation_list
        define_singleton_method('validation_list'.to_sym) do
          class_variable_get('@@validation_list'.to_sym)
        end
      end
      validation_name = "validation_#{name}_#{type}".to_sym
      validation_list << validation_name
      define_method(validation_name) { eval(TYPE_DICT[type].call(name, args[0])) }
    end

    presence = proc { |name| "!@#{name}.nil?" }
    format = proc { |name, format| "!(@#{name} !~ #{format})" }
    type = proc { |name, type| "@#{name}.is_a? #{type}" }
    TYPE_DICT = {
      presence: presence,
      format: format,
      type: type
    }.freeze
  end

  module InstanceMethods
    def validate!
      self.class.validation_list.each do |method|
        raise ValidationError, "Validation error in #{method}" unless send method
      end
    end

    def valid?
      validate!
      true
    rescue ValidationError
      false
    end
  end

  class ValidationError < RuntimeError
  end

  class MethodMissingError < RuntimeError
  end
end

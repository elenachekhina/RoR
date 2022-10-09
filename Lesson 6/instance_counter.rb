module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :instances

    def instances
      @instances ||= 0
    end

    private

    attr_writer :instances
  end

  module InstanceMethods
    protected

    # без send не понимаю как сделать, так как делать attr_writer :instances публичным нельзя, иначе смысла не будет.
    def register_instance
      self.class.send :instances=, self.class.instances + 1
    end
  end
end

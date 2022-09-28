class Entity
  attr_reader :type

  def initialize(*_args)
    self.type = type!
  end

  protected

  attr_writer :type

  def type!
    raise "Only typed #{self.class.name} are available"
  end
end

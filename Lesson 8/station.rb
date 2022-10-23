class Station
  include InstanceCounter
  include Validation
  attr_reader :name, :trains

  validate :name, :format, '/^([a-z]|[а-я]){3,15}([- ]0-9+)?$/i'
  @@all = []
  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!

    @@all << self
    register_instance
  end

  def take_train(train)
    @trains << train
  end

  def train_type(type)
    trains.select { |train| train.type == type }
  end

  def send_train(train)
    trains.delete(train)
  end

  def block_method(&block)
    trains.each { |train| block.call(train) }
  end
end

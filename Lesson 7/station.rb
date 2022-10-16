class Station
  include InstanceCounter
  attr_reader :name, :trains

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

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

  def block_method(&block)
    trains.each { |train| block.call(train) }
  end

  private

  NAME_FORMAT = /^([a-z]|[а-я]){3,15}([-\s]\d+)?$/i.freeze
  def validate!
    raise 'Name has invalid format' if name !~ NAME_FORMAT
  end
end

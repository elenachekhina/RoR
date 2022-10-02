class Station
  include InstanceCounter
  attr_reader :name, :trains

  class << self
    attr_accessor :instance_inside_station
  end
  @instance_inside_station = 123

  @@all = []
  def self.all
    @@all
  end

  def initialize(name)
    @name = name
    @trains = []
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
end

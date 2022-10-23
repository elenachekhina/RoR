class Train
  include ManufacturerCompany
  include InstanceCounter
  include Validation
  attr_reader :speed, :wagons, :number, :station, :type

  validate :number, :format, '/^[a-z0-9]{3}-?[a-z0-9]{2}$/i'
  validate :type, :presence

  @@all = []

  def self.find(number)
    @@all.find { |train| train.number == number }
  end

  def initialize(number)
    @type = type!
    @number = number
    @wagons = []
    @speed = 0
    validate!

    @@all << self
    register_instance
  end

  def add_wagon(wagon)
    wagons << wagon if wagon.type == type && speed.zero?
  end

  def delete_wagon(*_args)
    wagons.pop if speed.zero?
  end

  def gather_speed(speed)
    self.speed = speed
  end

  def stop
    self.speed = 0 unless speed.zero?
  end

  def get_route(route)
    @route = route
    @station = route.start
    notify_station_arrival
  end

  def next_station
    route.next_station(station)
  end

  def previous_station
    route.previous_station(station)
  end

  def go_next_station
    notify_station_departure
    self.station = next_station
    notify_station_arrival
  end

  def go_previous_station
    notify_station_departure
    self.station = previous_station
    notify_station_arrival
  end

  def block_method(&block)
    wagons.each_with_index { |wagon, index| block.call(wagon, index) }
  end

  protected

  attr_writer :speed, :station
  attr_reader :route

  def notify_station_arrival
    station.take_train(self)
  end

  def notify_station_departure
    station.send_train(self)
  end

  def type!; end
end

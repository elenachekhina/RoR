class Route
  include InstanceCounter
  include Validation
  attr_reader :start, :finish

  validate :start, :type, Station
  validate :finish, :type, Station
  def initialize(start, finish)
    @start = start
    @finish = finish
    validate!

    @stations_between = []
    register_instance
  end

  def add_station(station)
    validate_station! station
    @stations_between << station
  end

  def delete_station(station)
    @stations_between.reject! { |st| st == station }
  end

  def stations
    [@start] + @stations_between + [@finish]
  end

  def previous_station(station)
    station = stations[stations.find_index(station) - 1] unless first?(station)
    station
  end

  def next_station(station)
    station = stations[stations.find_index(station) + 1] unless last?(station)
    station
  end

  # методы вынесены в приватные, так как используются только внутри объектов
  def first?(station)
    station == start
  end

  def last?(station)
    station == finish
  end
end

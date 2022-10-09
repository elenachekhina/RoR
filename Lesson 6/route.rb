class Route
  include InstanceCounter
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    validate_station! start
    @finish = finish
    validate_station! finish
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
    station = stations[stations.find_index(station) - 1] unless is_first(station)
    station
  end

  def next_station(station)
    station = stations[stations.find_index(station) + 1] unless is_last(station)
    station
  end

  def valid?
    validate!
    true
  rescue
    false
  end
  private

  def validate_station! station
    raise "It's not a station" if !station.kind_of? Station
  end

  def validate!
    raise "Start and finish can't be the same" if start == finish
  end

  # методы вынесены в приватные, так как используются только внутри объектов
  def is_first(station)
    station == start
  end

  def is_last(station)
    station == finish
  end
end

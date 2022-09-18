class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
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

class Route
  attr_reader :start, :finish

  def initialize(start, finish)
    @start = start
    @finish = finish
    @stations_between = []
  end

  def add_station(station)
    @stations_between << station
  end

  def delete_station(station)
    @stations_between.reject! { |st| st == station }
  end

  def stations
    [@start] + @stations_between + [@finish]
  end
end

class Train
  attr_reader :type, :speed, :wagons, :current_station_index, :route, :number

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
  end

  def gather_speed(speed)
    @speed = speed
  end

  def stop
    @speed = 0
  end

  def add_wagon
    @wagons += 1 if @speed.zero?
  end

  def delete_wagon
    @wagons -= 1 if @speed.zero?
  end

  def get_route(route)
    @route = route
    @current_station_index = 0
    notify_station_arrival
  end

  def go_back
    station = current_station_index - 1 if current_station_index.positive?
    go(station) unless station.nil?
  end

  def go_forward
    station = current_station_index + 1 if current_station_index < route.stations.length - 1
    go(station) unless station.nil?
  end

  def current_station
    route.stations[current_station_index]
  end

  def previous_station
    route.stations[current_station_index - 1] if current_station_index.positive?
  end

  def next_station
    route.stations[current_station_index + 1] if current_station_index < route.stations.length - 1
  end

  private

  def notify_station_arrival
    current_station.take_train(self)
  end

  def notify_station_departure
    current_station.send_train(self)
  end

  def go(station)
    notify_station_departure
    @current_station_index = station
    notify_station_arrival
  end
end

station_1 = Station.new('Start station')
station_2 = Station.new('Finish station')
route_1 = Route.new(station_1, station_2)
puts 'Test 1:'
puts route_1.stations.map(&:name)

station_first = Station.new('First')
station_second = Station.new('Second')
station_third = Station.new('Third')
station_fourth = Station.new('Fourth')

route_1.add_station(station_first)
route_1.add_station(station_second)
route_1.add_station(station_third)
puts 'Test 2:'
puts route_1.stations.map(&:name)

route_1.delete_station(station_second)
puts 'Test 3:'
puts route_1.stations.map(&:name)

route_1.delete_station(station_fourth)
puts 'Test 4:'
puts route_1.stations.map(&:name)

train_g = Train.new('123', 'g', 10)
train_p = Train.new('321', 'p', 21)
train_g.gather_speed(10)
puts 'Test 6:'
puts train_g.speed
train_g.stop
puts 'Test 7:'
puts train_g.speed

train_g.add_wagon
puts 'Test 8:'
puts train_g.wagons

train_g.gather_speed(10)
train_g.add_wagon
puts 'Test 9:'
puts train_g.wagons

train_p.delete_wagon
puts 'Test 10:'
puts train_p.wagons

train_p.get_route(route_1)
puts 'Test 11:'
puts train_p.current_station.name
puts station_1.trains.map(&:number)

train_g.get_route(route_1)
puts 'Test 12:'
puts station_1.trains.map(&:number)

train_p.go_forward
puts 'Test 13:'
puts train_p.current_station.name
puts station_1.trains.map(&:number)
puts station_first.trains.map(&:number)

train_p.go_forward
puts 'Test 14:'
puts train_p.current_station.name

train_p.go_forward
puts 'Test 14:'
puts train_p.current_station.name

train_p.go_forward
puts 'Test 14:'
puts train_p.current_station.name

puts 'Test 15:'
puts train_g.current_station.name
train_g.go_back
puts train_g.current_station.name

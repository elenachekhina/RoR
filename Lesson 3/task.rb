class Station
    attr_reader :name
    def initialize(name)
        @name = name
        @trains = []
    end

    def take_train(train)
        @trains << train
    end

    def trains(type='all')
        if type == 'all'
            @trains.map {|train| train.number}
        else
            @trains.select {|train| train.type == type}.map {|train| train.number}
        end
    end

    def send_train(train_send)
        @trains.reject! {|train| train == train_send}
    end

end

class Route
    attr_reader :start
    attr_reader :finish
    def initialize(start, finish)
        @start = start
        @finish = finish
        @stations_between = []
    end

    def add_station(station)
        @stations_between << station
    end

    def delete_station(station)
        @stations_between.reject! {|st| st == station}
    end

    def get_next_station(station)
        index = get_stations.index(station) + 1
        get_stations[index]
    end

    def get_previous_station(station)
        index = get_stations.index(station) - 1
        get_stations[index] if index >= 0
    end

    def stations
        get_stations.map {|station| station.name}
    end

    private
    def get_stations
        [@start] + @stations_between + [@finish]
    end

end

class Train
    attr_reader :type
    attr_reader :speed
    attr_reader :wagons
    attr_reader :current_station
    attr_reader :previous_station
    attr_reader :next_station
    attr_reader :number
    def initialize(number, type, wagons, speed=0)
        @number = number
        @type = type
        @wagons = wagons
        @speed = speed
    end

    def gather_speed(speed)
        @speed = speed
    end

    def stop
        @speed = 0
    end

    def add_wagon
        @wagons += 1 if @speed == 0
    end

    def delete_wagon
        @wagons -= 1 if @speed == 0
    end

    def get_route(route)
        @route = route
        @current_station = @route.start
        notify_station_arrival
    end

    def go_back
        station = @route.get_previous_station(@current_station)
        puts station
        if !station.nil?
            go(station)
        else
            error_moving('back') 
        end
    end

    def go_forward
        station = @route.get_next_station(@current_station)
        if !station.nil?
            go(station)
        else
            error_moving('forward') 
        end
    end

    def current_station
        @current_station.name
    end

    def previous_station
        @previous_station.name
    end

    def next_station
        @next_station.name
    end

    private
    def get_previous_station
        @route.get_previous_station(@current_station)
    end

    def get_next_station
        @route.get_next_station(@current_station)
    end

    def error_moving(direction)
        "Can't go #{direction}"
    end

    def notify_station_arrival
        @current_station.take_train(self)
    end

    def notify_station_departure
        @current_station.send_train(self)
    end

    def go(station)
        notify_station_departure
        @current_station = station
        notify_station_arrival
        @next_station = get_next_station
        @previous_station = get_previous_station
    end
end

station_1 = Station.new('Start station')
station_2 = Station.new('Finish station')
route_1 = Route.new(station_1, station_2)
puts "Test 1:"
puts route_1.stations

station_first = Station.new('First')
station_second = Station.new('Second')
station_third = Station.new('Third')
station_fourth = Station.new('Fourth')

route_1.add_station(station_first)
route_1.add_station(station_second)
route_1.add_station(station_third)
puts "Test 2:"
puts route_1.stations

route_1.delete_station(station_second)
puts "Test 3:"
puts route_1.stations

route_1.delete_station(station_fourth)
puts "Test 4:"
puts route_1.stations

route_1.delete_station(station_fourth)
puts "Test 5:"
puts route_1.stations

train_g = Train.new('123', 'g', 10)
train_p = Train.new('321', 'p', 21)
train_g.gather_speed(10)
puts "Test 6:"
puts train_g.speed
train_g.stop
puts "Test 7:"
puts train_g.speed

train_g.add_wagon
puts "Test 8:"
puts train_g.wagons

train_g.gather_speed(10)
train_g.add_wagon
puts "Test 9:"
puts train_g.wagons

train_p.delete_wagon
puts "Test 10:"
puts train_p.wagons

train_p.get_route(route_1)
puts "Test 11:"
puts train_p.current_station
puts station_1.trains

train_g.get_route(route_1)
puts "Test 12:"
puts station_1.trains

train_p.go_forward
puts "Test 13:"
puts train_p.current_station
puts station_1.trains

train_p.go_forward
puts "Test 14:"
puts train_p.current_station
puts station_1.trains
puts station_third.trains

route_1.delete_station(station_first)
train_g.go_forward
puts "Test 15:"
puts station_third.trains

puts "Test 16:"
puts station_third.trains('g')


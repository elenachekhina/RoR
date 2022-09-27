class Train < Entity
    attr_reader :speed, :wagons, :number, :station
  
    def initialize(number)
      super(number)
      @number = number
      @wagons = []
      @speed = 0
    end

    def add_wagon(wagon)
      wagons << wagon if wagon.type == self.type and speed.zero?
    end

    def delete_wagon(*args)
      wagons.pop if speed.zero?
    end

    def gather_speed(speed)
      self.speed = speed
    end

    def stop
      self.speed = 0 if !speed.zero?
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

    protected
    attr_writer :speed, :station
    attr_reader :route

    def notify_station_arrival
      station.take_train(self)
    end

    def notify_station_departure
      station.send_train(self)
    end

  end
  
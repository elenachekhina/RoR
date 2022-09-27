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

    def previous_station(station)
      station = stations[stations.find_index(station) - 1] unless is_first(station)
      station
    end

    def next_station(station)
      station = stations[stations.find_index(station) + 1] unless is_last(station)
      station
    end

    private
    # методы вынесены в приватные, так как используются только внутри объектов
    def is_first(station)
      station == start
    end

    def is_last(station)
      station == finish
    end
  end
  
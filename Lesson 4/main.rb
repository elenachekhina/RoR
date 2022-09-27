require_relative 'entity'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'train'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'station'
require_relative 'route'

class Menu
    attr_reader :user_input

    def initialize
        @user_stations = {
            1 => {name: 'A', object: Station.new('A')},
            2 => {name: 'B', object: Station.new('B')},
            3 => {name: 'C', object: Station.new('C')},
            4 => {name: 'D', object: Station.new('D')},
            5 => {name: 'E', object: Station.new('E')},
        }
        @user_trains = {
            1 => {name: '123', object: CargoTrain.new('123')}
        }
        @user_routes = {
            1 => {name: '1', object: Route.new(user_stations[1][:object], user_stations[5][:object])}
        }
        @user_input = nil
    end

    def show_dict(dict)
        puts dict.map {|key, option| "#{key} - #{option}"}
    end

    def start
        loop do
            puts
            puts "Choose the option:"
            show_dict(OPTIONS.transform_values {|value| value[:name]})
            read_user_input(:option)
            break if user_input == 0
            self.send OPTIONS[user_input][:func]
        end
    end

    private
    attr_writer :user_input
    attr_reader :user_stations, :user_trains, :user_routes

    def read_user_input(type=:string)
        self.user_input = gets.chomp.strip
        self.user_input = user_input.to_i if type == :option
    end

    def create_station
        puts "Enter name:"
        read_user_input
        @user_stations[(user_stations.keys.max||0) + 1] = {name: user_input, object: Station.new(user_input)}
    end

    def create_train
        type = choose_option('type', TYPES)
        puts "Enter number:"
        read_user_input
        @user_trains[(user_trains.keys.max||0) + 1] = {name: user_input, object: TRAINS[type].new(user_input)}
    end

    def create_route
        puts "Enter name:"
        read_user_input
        name = user_input

        start_station = choose_object('first station', user_stations)
        finish_station = choose_object('last station', user_stations)
        
        @user_routes[(user_routes.keys.max||0) + 1] = {name: name, object: Route.new(start_station, finish_station)}
        
    end

    def list_user_stations
        puts "Your stations:"
        show_dict(user_stations.transform_values {|value| value[:name]})
    end

    def list_user_routes
        puts "Your routes:"
        show_dict(user_routes.transform_values {|value| value[:name]})
    end

    def list_user_trains
        puts "Your trains:"
        show_dict(user_trains.transform_values {|value| {value[:name] => value[:object].type}})
    end

    def choose_object(name, dict)
        puts "Choose the #{name}:"
        show_dict(dict.transform_values {|value| value[:name]})
        read_user_input(:option)
        dict[user_input][:object]
    end

    def choose_option(name, dict)
        puts "Choose #{name}:"
        show_dict(dict)
        read_user_input(:option)
        dict[user_input]
    end

    def add_del_station
        route = choose_object('route', user_routes)
        action = choose_option('action', ACTIONS)
        station = choose_object('station', user_stations)
        route.send ROUTE_ACTIONS[action], station
    end

    def list_stations
        route = choose_object('route', user_routes)
        puts route.stations.map {|station| station.name}.join(', ')
    end

    def list_trains
        station = choose_object('station', user_stations)
        type = choose_option('type', TYPES)
        puts station.train_type(type)
    end

    def give_route_to_train
        train = choose_object('train', user_trains)
        route = choose_object('route', user_routes)
        train.get_route(route)
    end

    def add_del_wagon
        train = choose_object('train', user_trains)
        action = choose_option('action', ACTIONS)
        wagon = WAGONS[choose_option('wagon', TYPES)].new

        train.send TRAIN_ACTIONS[action], wagon
    end

    def show_wagons
        puts choose_object('train', user_trains).wagons
    end

    def move_train
        train = choose_object('train', user_trains)
        direction = choose_option('direction', MOVES)
        train.send TRAIN_MOVES[direction]
    end

    def show_cur_station
        train = choose_object('train', user_trains)
        puts train.station.name
    end

    OPTIONS = {
        1 => {name: 'Create station', func: :create_station},
        2 => {name: 'Create train', func: :create_train},
        3 => {name: 'Create route', func: :create_route},
        4 => {name: 'Add/Del station to route', func: :add_del_station},
        5 => {name: 'Give route to train', func: :give_route_to_train},
        6 => {name: 'Add/Del wagons to train', func: :add_del_wagon},
        7 => {name: 'Move train', func: :move_train},
        8 => {name: 'List of trains', func: :list_trains},
        9 => {name: 'List of stations', func: :list_stations},
        10 => {name: 'List user stations', func: :list_user_stations},
        11 => {name: 'List user routes', func: :list_user_routes},
        12 => {name: 'List user trains', func: :list_user_trains},
        13 => {name: 'Show wagons', func: :show_wagons},
        14 => {name: 'Show cur station', func: :show_cur_station},
        0 => {name: 'Exit'}
    }

    TYPES = {
        1 => :cargo,
        2 => :passenger
    }

    TRAINS = {
        cargo: CargoTrain,
        passenger: PassengerTrain
    }

    WAGONS = {
        cargo: CargoWagon,
        passenger: PassengerWagon
    }

    ACTIONS = {
        1 => :add,
        2 => :delete
    }

    MOVES = {
        1 => :forward,
        2 => :back
    }

    ROUTE_ACTIONS = {
        :add => :add_station,
        :delete => :delete_station
    }

    TRAIN_ACTIONS = {
        add: :add_wagon,
        delete: :delete_wagon
    }

    TRAIN_MOVES = {
        forward: :go_next_station,
        back: :go_previous_station
    }


end

Menu.new.start

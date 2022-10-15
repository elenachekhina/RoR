class Menu
  attr_reader :user_input

  def initialize
    @user_stations = {}
    @user_trains = {}
    @user_routes = {}
    @user_input = nil
  end

  def start
    loop do
      puts
      puts 'Choose the option:'
      show_dict(OPTIONS.transform_values { |value| value[:name] })
      read_user_input(:option)
      break if user_input.zero?

      send OPTIONS[user_input][:func]
    end
  end

  private

  # Все методы приватные, так как интерфейс для меню очень строгий - только начать
  attr_writer :user_input
  attr_reader :user_stations, :user_trains, :user_routes

  def show_dict(dict)
    puts dict.map { |key, option| "#{key} - #{option}" }
  end

  def read_user_input(type = :string)
    self.user_input = gets.chomp.strip
    self.user_input = user_input.to_i if type == :option
  end

  def create_station
    puts 'Enter name:'
    read_user_input
    @user_stations[(user_stations.keys.max || 0) + 1] = { name: user_input, object: Station.new(user_input) }
  rescue
    retry
  end

  def create_train
    type = choose_option('type', TYPES)
    attempt = 0
    begin
      puts 'Enter number:'
      read_user_input
      @user_trains[(user_trains.keys.max || 0) + 1] = { name: user_input, object: TRAINS[type].new(user_input) }
      puts "Train #{user_trains[user_trains.keys.max]} was successfully created"
    rescue Exception => e
      puts e.inspect
      attempt += 1
      retry if attempt < 3
      puts 'Try next time'
    end
  end

  def create_route
    puts 'Enter name:'
    read_user_input
    name = user_input

    start_station = choose_object('first station', user_stations)
    finish_station = choose_object('last station', user_stations)

    @user_routes[(user_routes.keys.max || 0) + 1] = { name: name, object: Route.new(start_station, finish_station) }
  rescue Exception => e
    puts e.inspect
  end

  def choose_object(name, dict)
    raise ChooseObjectError, "There are not any #{name}s in list" if dict.length.zero?
    puts "Choose the #{name}:"
    show_dict(dict.transform_values { |value| value[:name] })
    read_user_input(:option)
    dict[user_input][:object]
  rescue NoMethodError
    retry if !dict.length.zero?
  end

  def choose_option(name, dict)
    puts "Choose #{name}:"
    show_dict(dict)
    read_user_input(:option)
    raise if dict[user_input].nil?
    dict[user_input]
  rescue
    retry
  end

  def add_del_station
    route = choose_object('route', user_routes)
    action = choose_option('action', ACTIONS)
    station = choose_object('station', user_stations)
    route.send ROUTE_ACTIONS[action], station
  rescue ChooseObjectError => e
    puts e.inspect
  end

  def list_stations
    route = choose_object('route', user_routes)
    puts route.stations.map { |station| station.name }.join(', ')
  rescue ChooseObjectError => e
    puts e.inspect
  end

  def list_trains
    station = choose_object('station', user_stations)
    type = choose_option('type', TYPES)
    puts station.train_type(type)
  rescue ChooseObjectError => e
    puts e.inspect
  end

  def give_route_to_train
    train = choose_object('train', user_trains)
    route = choose_object('route', user_routes)
    train.get_route(route)
  rescue ChooseObjectError => e
    puts e.inspect
  end

  def add_del_wagon
    train = choose_object('train', user_trains)
    action = choose_option('action', ACTIONS)

    if action == :add
      type = choose_option('wagon', TYPES)
      puts 'Enter place:'
      read_user_input
      place = user_input.to_f.modulo(1) > 0? user_input.to_f : user_input.to_i
      wagon = WAGONS[type].new(place)
    end

    train.send TRAIN_ACTIONS[action], wagon
  rescue ChooseObjectError => e
    puts e.inspect
  end

  def move_train
    train = choose_object('train', user_trains)
    direction = choose_option('direction', MOVES)
    train.send TRAIN_MOVES[direction]
  rescue ChooseObjectError => e
    puts e.inspect
  end

  def show_wagons
    train = choose_object('train', user_trains)

    train.block_method do |wagon, index|
      puts "Num: #{index}, Type: #{wagon.type}, Free: #{wagon.free_place}, Taken: #{wagon.taken_place}"
    end

  end

  def show_trains
    station = choose_object('station', user_stations)

    station.block_method do |train|
      puts "Num: #{train.number}, Type: #{train.type}, Wagons: #{train.wagons.length}"
    end

  end

  def take_place
    train = choose_object('train', user_trains)
    puts 'Choose wagon:'
    train.block_method do |wagon, index|
      puts "Num: #{index}, Free: #{wagon.free_place}, Taken: #{wagon.taken_place}"
    end
    read_user_input(:option)
    wagon = train.wagons[user_input]
    num = 1
    if wagon.type == :cargo
      puts "Enter required place:"
      read_user_input
      num = user_input.to_f
    end
    wagon.take_place(num)
  rescue Wagon::FreePlaceError => e
    puts e.inspect
  end

  class ChooseObjectError < RuntimeError
  end

  OPTIONS = {
    1 => { name: 'Create station', func: :create_station },
    2 => { name: 'Create train', func: :create_train },
    3 => { name: 'Create route', func: :create_route },
    4 => { name: 'Add/Del station to route', func: :add_del_station },
    5 => { name: 'Give route to train', func: :give_route_to_train },
    6 => { name: 'Add/Del wagons to train', func: :add_del_wagon },
    7 => { name: 'Move train', func: :move_train },
    8 => { name: 'List of trains', func: :list_trains },
    9 => { name: 'List of stations', func: :list_stations },
    10 => { name: 'Show wagons', func: :show_wagons},
    11 => { name: 'Show trains', func: :show_trains},
    12 => { name: 'Take place', func: :take_place},
    0 => { name: 'Exit' }
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
    add: :add_station,
    delete: :delete_station
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

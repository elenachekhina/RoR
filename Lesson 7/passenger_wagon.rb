class PassengerWagon < Wagon

  def initialize(place)
    super(place) if place.is_a? Integer
  end

  def take_place(num)
    super(1)
  end

  protected

  def type!
    :passenger
  end
end

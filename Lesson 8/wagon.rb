class Wagon
  include ManufacturerCompany
  include Validation
  attr_reader :type, :taken_place

  validate :place, :presence
  validate :type, :presence

  def initialize(place)
    raise NegativePlaceError, 'Quantity of place should not be negative' if place.negative?

    @type = type!
    @taken_place = 0
    @place = place
  end

  def free_place
    place - taken_place
  end

  def take_place(num)
    raise FreePlaceError, 'Not enough free space' if num > free_place

    @taken_place += num
  end

  private

  attr_reader :place

  def type!; end

  class FreePlaceError < RuntimeError
  end

  class NegativePlaceError < RuntimeError
  end
end

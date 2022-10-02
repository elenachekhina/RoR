class Wagon
  include ManufacturerCompany
  attr_reader :type

  def initialize
    @type = type!
  end

  private

  def type!; end
end

class Location
  attr_accessor :x, :y

  def initialize(coordinates)
    @x = coordinates[0].to_i
    @y = coordinates[1].to_i
  end
end

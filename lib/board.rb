class Board
  attr_accessor :x, :y, :valid_directions

  def initialize(x, y)
    @x = x.to_i
    @y = y.to_i
  end

  def valid_directions
    @valid_directions = ["N","E","S","W"]
  end
end

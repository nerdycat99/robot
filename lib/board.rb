class Board
  attr_reader :width, :height, :valid_directions

  def initialize(width:, height:, valid_directions:)
    @width = width.to_i
    @height = height.to_i
    @valid_directions = valid_directions
  end

  def valid_directions_for_display
    valid_directions.join(', ')
  end

  def width_for_display
    width + 1
  end

  def height_for_display
    height + 1
  end
end

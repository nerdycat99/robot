class Coordinates
  attr_accessor :x, :y, :direction, :error_message

  def initialize(x:, y:, direction:)
    @x = x
    @y = y
    @direction = direction.upcase if Game.valid_directions.include? direction.upcase
  end

  def valid_for?(board)
    valid_instructions? && valid_move_for?(board)
  end

  def rotate(rotation_range)
    current_position_in_circle_of_rotation = rotation_range.index(self.direction)
    self.direction =  if current_position_in_circle_of_rotation + 1 > rotation_range.length - 1
                        rotation_range[0]
                      else
                        rotation_range[current_position_in_circle_of_rotation + 1]
                      end
  end

  def display_x
    x + 1
  end

  def display_y
    y + 1
  end

  private

  def valid_instructions?
    if x.nil? || y.nil? || direction.nil?
      self.error_message = "sorry your instructions for positioning the robot were invalid, please try again"
      return false
    end
    true
  end

  def valid_move_for?(board)
    unless x <= board.width && y <= board.height && x >= 0 && y >= 0
      self.error_message = "sorry I can't do that, your instructions would make the robot fall off the table"
      return false
    end
    true
  end
end

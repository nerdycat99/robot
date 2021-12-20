class Robot
  require "coordinates.rb"

  attr_accessor :position, :message

  def update_position_with(coordinates)
    self.position = coordinates
  end

  def place(command, board)
    reset_message
    location_and_direction = coordinates_from(command)
    if location_and_direction.count == 3
      x = location_coordinate(location_and_direction[0])
      y = location_coordinate(location_and_direction[1])
      direction = location_and_direction[2]
      coordinates = Coordinates.new(x: x, y: y, direction: direction)
      update_position_with(coordinates) if coordinates.valid_for?(board)
      self.message = coordinates.error_message
    else
      self.message = "sorry that was not valid, please type 'PLACE X,Y,D' to continue."
    end
  end

  def move(offset:1, board:)
    reset_message
    unless not_placed?
      next_x = position.x
      next_y = position.y

      case position.direction
      when board.valid_directions[0]
        next_y += offset
      when board.valid_directions[1]
        next_x += offset
      when board.valid_directions[2]
        next_y -= offset
      when board.valid_directions[3]
        next_x -= offset
      end

      next_coordinates = Coordinates.new(x: next_x, y: next_y, direction: position.direction)
      update_position_with(next_coordinates) if next_coordinates.valid_for?(board)
      self.message = next_coordinates.error_message
    end
  end

  def change_orientation(rotational_direction)
    reset_message
    position.rotate(rotational_direction) unless not_placed?
  end

  def report
    self.message = "Robot is at x/y coordinates #{position.display_x}/#{position.display_y} and facing #{position.direction}" unless not_placed?
  end


  private

  def reset_message
    self.message = nil
  end

  def not_placed?
    if self.position.nil?
      self.message = "you must PLACE the robot before we can move it."
      return true
    end
    false
  end

  def coordinates_from(command)
    command.slice!(6, command.length).split(',')
  end

  def location_coordinate(coordinate)
    coordinate.to_i - 1 if coordinate !~ /\D/
  end
end

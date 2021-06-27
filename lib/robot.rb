class Robot
  require "location.rb"
  attr_accessor :direction, :location, :board

  def initialize(board)
    @board = board
  end

  def update_position(location, direction)
    self.location = location
    self.direction = direction
  end

  def in_bounds_for_board?(location_x=location.x, location_y=location.y)
    location_x <= board.x && location_y <= board.y && location_x >= 0 && location_y >= 0
  end

  def process(command)
    case
      when command.upcase.eql?('MOVE')
        move
      when command.upcase.start_with?('PLACE ')
        place(command)
      when command.upcase.eql?('LEFT')
        change_orientation(false)
      when command.upcase.eql?('RIGHT')
        change_orientation(true)
      when command.upcase.eql?('REPORT')
        puts report
      when command.upcase.eql?('QUIT')
        return 'thank you for moving the robot'
      else
        puts incorrect_command
      end
    command = (print 'what shall we do next: '; STDIN.gets.rstrip)
    process(command)
  end

  private

  def place(command)
    command.slice!(0,6)
    coordinates = command.split(',')
    input_error = false
    if coordinates.count == 3
      new_direction = coordinates.pop().upcase
      if board.valid_directions.include?(new_direction) && coordinates.all? {|c| valid_coordinate(c) }
        new_location = Location.new(coordinates)
        if in_bounds_for_board?(new_location.x,new_location.y)
          update_position(new_location, new_direction)
        else
          input_error = true
        end
      else
        input_error = true
      end
    else
      input_error = true
    end
    puts incorrect_command if input_error
  end

  def move(offset=1)
    if not_placed?
      puts place_robot
    else
      current_x = location.x
      current_y = location.y
      case direction
      when 'N'
        self.location.y += offset
      when 'E'
        self.location.x += offset
      when 'S'
        self.location.y -= offset
      when 'W'
        self.location.x -= offset
      end
      unless in_bounds_for_board?
        self.location.x = current_x
        self.location.y = current_y
        puts "sorry I can't do that"
      end
    end
  end

  def change_orientation(clockwise)
    if not_placed?
      puts place_robot
    else
      points = clockwise ? board.valid_directions : board.valid_directions.reverse
      points_index = points.index(direction)
      self.direction = points_index + 1 > points.count - 1 ? points[0] : points[points_index + 1]
    end
  end

  def report
    return place_robot if not_placed?
    @report = "Robot is at x/y coordinates #{location.x}/#{location.y} and facing #{direction}"
  end

  def not_placed?
    self.direction.nil? || self.location.nil?
  end

  def place_robot
    @place_robot = "first PLACE the robot"
  end

  def incorrect_command
    @incorrect_command = "incorrect command given, try again"
  end

  def valid_coordinate(value)
    /\A-?\d+\Z/ === value
  end
end

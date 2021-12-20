class Game
  require "board.rb"
  require "robot.rb"

  attr_accessor :robot, :board, :message

  WIDTH = 5
  HEIGHT = 5
  VALID_DIRECTIONS = ["NORTH","EAST","SOUTH","WEST"]
  MOVE_BY = 1

  def initialize(width, height)
    board_width = width || WIDTH
    board_height = height || HEIGHT
    @board = Board.new(width: board_width -1 , height: board_height - 1, valid_directions: VALID_DIRECTIONS)
    @robot = Robot.new()
  end

  def self.valid_directions
    VALID_DIRECTIONS
  end

  def play
    puts "WELCOME TO THE ROBOT GAME"
    puts
    input = (print instructions; STDIN.gets.rstrip)
    process(input)
  end

  def process(input)
    return if robot.nil?
    self.message = nil
    case
      when input.upcase.eql?('MOVE')
        move
      when input.upcase.start_with?('PLACE ')
        place(input)
      when input.upcase.eql?('LEFT')
        change_orientation(clockwise: false)
      when input.upcase.eql?('RIGHT')
        change_orientation(clockwise: true)
      when input.upcase.eql?('REPORT')
        report
      when input.upcase.eql?('QUIT')
        quit
      else
        incorrect_command
      end
    process(handle_input_output)
  end

  def display_width
    board.width_for_display
  end

  def display_height
    board.height_for_display
  end

  private

  def move
    robot.move(offset: MOVE_BY, board: board)
    handle_message
  end

  def place(input)
    robot.place(input, board)
    handle_message
  end

  def change_orientation(clockwise:)
    rotational_direction = clockwise ? board.valid_directions : board.valid_directions.reverse
    robot.change_orientation(rotational_direction)
    handle_message
  end

  def report
    robot.report
    handle_message
  end

  def incorrect_command
    self.message = "incorrect command given, please try again"
  end

  def handle_message
    self.message = robot.message
  end

  def quit
    self.message = 'thank you for playing move the robot'
    self.robot = nil
  end

  def handle_input_output
    puts message if message
    (print 'what shall we do next: '; STDIN.gets.rstrip) unless robot.nil?
  end

  def instructions
    first_line = "Type 'PLACE X,Y,D' to initially place your robot on the board measuring width: #{display_width} and height: #{display_height}.\n"
    second_line = "X is the starting width position, Y the starting height position and D the direction your robot should initially face in (#{board.valid_directions_for_display}).\n"
    third_line = "After initially positioning your robot, you can subsequently type 'MOVE' to advance the robot one space in the direction it is currently facing, turn the robot 'LEFT' or 'RIGHT'\nor type 'REPORT' to get the location of the robot. Type 'QUIT' to end.\n\n"
    prompt = "what shall we do first: "
    @instructions = "#{first_line}#{second_line}#{third_line}#{prompt}"
  end
end

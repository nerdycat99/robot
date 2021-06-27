class Game
  require "board.rb"
  require "robot.rb"

  attr_accessor :robot, :board

  def initialize(x,y)
    @board = Board.new(x,y)
    @robot = Robot.new(board)
  end

  def play
    command = (print instructions; STDIN.gets.rstrip)
    robot.process(command)
  end

  private

  def instructions
    @instructions = "Enter PLACE X,Y,F to position the robot on the board and provide a direction to face in (N,S,E,W).\nYou can also type MOVE to advance the robot one space in the direction it is facing, turn the robot LEFT or RIGHT\nor type REPORT to get the location of the robot. Type QUIT to end.\nwhat shall we do: "
  end
end

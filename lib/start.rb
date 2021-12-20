local_dir = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(local_dir)
require "game.rb"

args = ARGV
width = args[0].to_i unless args[0].nil?
height = args[1].to_i unless args[1].nil?

if args.count == 0 || args.count == 2 && width > 0 && height > 0
  system "clear"
  Game.new(width, height).play
else
  puts "You can stipulate the board size by running 'ruby start.rb X Y' where X and Y are the dimensions of the board. Otherwise just run 'ruby start.rb' to use teh default board size."
end

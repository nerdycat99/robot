local_dir = File.expand_path('../', __FILE__)
$LOAD_PATH.unshift(local_dir)
require "game.rb"

game = Game.new(4,4)
game.play

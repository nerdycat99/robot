require 'spec_helper'

RSpec.describe  Game, type: :class do
  
  describe "initialize" do
    context 'creating the game' do
      let(:x) { 4 }
      let(:y) { 4 }
      let (:game) { Game.new(x,y) }

      it 'creates a board for the game of size 4 x 4' do
        expect(game.board.x).to eql x
        expect(game.board.y).to eql y
      end

      it 'creates a new robot with the board as param' do
        expect(game.robot.board.x).to eql x
        expect(game.robot.board.y).to eql y
      end
    end
  end
end

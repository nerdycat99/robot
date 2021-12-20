require 'spec_helper'

RSpec.describe  Game, type: :class do
  
  describe 'initialize' do
    context 'creating the game' do
      let(:width) { 4 }
      let(:height) { 4 }
      let(:game) { Game.new(width, height) }

      it 'creates a board with dimensions that are 1 less than arguments provided' do
        expect(game.board.width).to eql width - 1
        expect(game.board.height).to eql height - 1
      end

      it 'creates a new robot with the board as param' do
        expect(game.robot).not_to be nil
      end

      it 'has a width and height as per the user input / default' do
        expect(game.display_width).to eql game.board.width + 1
        expect(game.display_height).to eql game.board.height + 1
      end
    end
  end

  describe 'process' do
    let(:width) { 4 }
    let(:height) { 4 }
    let(:game) { Game.new(width, height) }

    context 'when provided with valid input' do
      let(:input) { 'QUIT'}
      let(:output) { 'thank you for playing move the robot' }
      it 'provides the player with appropriate feedback' do
        allow_any_instance_of(Game).to receive(:handle_input_output).and_return(input)
        game.process input
        expect(game.message).to eql output
      end
    end
  end
end

require 'spec_helper'

RSpec.describe  Robot, type: :class do

  let (:valid_directions) { ["NORTH","EAST","SOUTH","WEST"] }
  let (:board) { Board.new(width: 4,height: 4, valid_directions: valid_directions) }

  describe 'valid_for?' do
    context 'when the instructions the coordinates were created with were valid' do
      context 'and the coordinates are valid for the board' do
        subject { Coordinates.new(x: 2, y: 2, direction: 'WEST') }
        it 'returns true' do
          expect(subject.valid_for? board).to eql true
        end
      end

      context 'but the coordinates are NOT valid for the board' do
        subject { Coordinates.new(x: 6, y: 2, direction: 'WEST') }
        it 'returns false' do
          expect(subject.valid_for? board).to eql false
        end
      end
    end

    context 'when the instructions the coordinates were created with were invalid' do
      context 'empty x or y coordinates' do
        subject { Coordinates.new(x: nil, y: 2, direction: 'WEST') }
        it 'returns false' do
          expect(subject.valid_for? board).to eql false
        end
      end
      context 'invalid direction' do
        subject { Coordinates.new(x: nil, y: 2, direction: 'QWERTY') }
        it 'returns false' do
          expect(subject.valid_for? board).to eql false
        end
      end
    end
  end

  describe 'rotate' do
    context 'the rotational range provided is clockwise (robot moving right)' do
      let(:clockwise_rotation_range) { ["NORTH","EAST","SOUTH","WEST"] }
      context 'the current direction is in the middle of the rotational range' do
        subject { Coordinates.new(x: 2, y: 2, direction: 'SOUTH') }

        it 'sets the direction to next position in rotational range' do
          subject.rotate clockwise_rotation_range
          expect(subject.direction).to eql 'WEST'
        end
      end

      context 'the current direction is at the end of the rotational range' do
        subject { Coordinates.new(x: 2, y: 2, direction: 'WEST') }

        it 'sets the direction back to the first position in rotational range' do
          subject.rotate clockwise_rotation_range
          expect(subject.direction).to eql 'NORTH'
        end
      end
    end

    context 'the rotational range provided is anti-clockwise (robot moving left)' do
      let(:anticlockwise_rotation_range) { ["WEST", "SOUTH","EAST","NORTH"] }
      context 'the current direction is in the middle of the rotational range' do
        subject { Coordinates.new(x: 2, y: 2, direction: 'SOUTH') }

        it 'sets the direction to next position in rotational range' do
          subject.rotate anticlockwise_rotation_range
          expect(subject.direction).to eql 'EAST'
        end
      end

      context 'the current direction is at the end of the rotational range' do
        subject { Coordinates.new(x: 2, y: 2, direction: 'NORTH') }

        it 'sets the direction back to the first position in rotational range' do
          subject.rotate anticlockwise_rotation_range
          expect(subject.direction).to eql 'WEST'
        end
      end
    end
  end
end

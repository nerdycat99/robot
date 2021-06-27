require 'spec_helper'

RSpec.describe  Robot, type: :class do
  
  let (:new_board) { Board.new(4,4) }
  let (:robot_location) { Location.new([2,2]) }
  let (:robot_direction) { 'N' }
  subject { Robot.new new_board }

  describe "initialize" do
    it 'creates an instance of a robot with a board' do
      expect(subject.board).to eql new_board
    end
  end

  describe "update_position" do
    it 'assigns a location object and direction to the robot' do
      subject.update_position robot_location, robot_direction
      expect(subject.location).to eql robot_location
      expect(subject.direction).to eql robot_direction
    end
  end

  describe "in_bounds_for_board?" do
    let (:out_of_bounds_location) { Location.new([6,6]) }

    it 'returns true when the robot locations are within the size of the board' do
      subject.update_position robot_location, robot_direction
      expect(subject.in_bounds_for_board?).to eql true
    end

    it 'returns false when the robot locations are NOT within the size of the board' do
      subject.update_position out_of_bounds_location, robot_direction
      expect(subject.in_bounds_for_board?).to eql false
    end
  end

  describe "place" do
    let (:good_x) { 1 }
    let (:good_y) { 1 }
    let (:good_direction) { 'W' }
    let (:out_of_bounds_x) { 7 }
    let (:out_of_bounds_y) { 9 }
    let (:bad_x) { 'w' }
    let (:bad_y) { 'q' }
    let (:bad_direction) { 'O' }

    context "when the user provides valid coordinates and a valid direction" do
      let (:command) { "PLACE #{good_x},#{good_y},#{good_direction}" }

      it "places the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command)
        expect(subject.location.x).to eql good_x
        expect(subject.location.y).to eql good_y
        expect(subject.direction).to eql good_direction
      end
    end

    context "when the user provides one invalid coordinate and a valid direction" do
      let (:command) { "PLACE #{bad_x},#{good_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command)
        expect(subject.location).to eql nil
        expect(subject.direction).to eql nil
      end
    end

    context "when the user provides both invalid coordinate and a valid direction" do
      let (:command) { "PLACE #{bad_x},#{bad_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command)
        expect(subject.location).to eql nil
        expect(subject.direction).to eql nil
      end
    end

    context "when the user provides valid coordinates but an invalid direction" do
      let (:command) { "PLACE #{good_x},#{good_y},#{bad_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command)
        expect(subject.location).to eql nil
        expect(subject.direction).to eql nil
      end
    end

    context "when the user provides one out of bound coordinates and a valid direction" do
      let (:command) { "PLACE #{out_of_bounds_x},#{good_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command)
        expect(subject.location).to eql nil
        expect(subject.direction).to eql nil
      end
    end

    context "when the user provides both out of bound coordinates and a valid direction" do
      let (:command) { "PLACE #{out_of_bounds_x},#{out_of_bounds_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command)
        expect(subject.location).to eql nil
        expect(subject.direction).to eql nil
      end
    end

    context "when the user provides the correct command without commas" do
      let (:command) { "PLACE #{good_x}#{good_y}#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command)
        expect(subject.location).to eql nil
        expect(subject.direction).to eql nil
      end
    end

    context "when the user provides an incorrect command" do
      let (:command) { "please place #{good_x},#{good_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command)
        expect(subject.location).to eql nil
        expect(subject.direction).to eql nil
      end
    end
  end

  describe "move" do

    context 'when the user has not yet placed the robot' do
      it "does not move the robot to a new location" do
        subject.send(:move, 1)
        expect(subject.location).to eql nil
      end
    end

    context 'when the user has placed the robot' do
      let (:x) { 1 }
      let (:y) { 1 }
      let (:x1) { 4 }
      let (:y1) { 4 }

      context 'and the move is still in bounds for the board' do
        let (:command) { "PLACE #{x},#{y},N" }
        before { subject.send(:place, command) }

        it "moves the robot to a new location" do
          expect { subject.send(:move, 1) }.to change { subject.location.y }.to y+1
        end
      end

      context 'and the move is out of bounds for the y coordinate' do
        let (:command_north) { "PLACE #{x},#{y1},N" }
        before { subject.send(:place, command_north) }

        it "does not move the robot to a new location" do
          expect(subject.location.y).to eql y1
        end
      end

      context 'and the move is out of bounds for the y coordinate' do
        let (:command_east) { "PLACE #{x1},#{y},E" }
        before { subject.send(:place, command_east) }

        it "does not move the robot to a new location" do
          expect(subject.location.x).to eql x1
        end
      end
    end

    describe 'report' do
      it 'does not output the location of the robot if it has NOT been placed' do
        expect(subject.send(:report)).to eql "first PLACE the robot"
      end

      context 'when the robot has been placed' do
        let (:x) { 2 }
        let (:y) { 3 }
        let (:direction) { 'S' }
        let (:command) { "PLACE #{x},#{y},#{direction}" }
        before { subject.send(:place, command) }

        it 'outputs the location of the robot if it has NOT been placed' do
          expect(subject.send(:report)).to eql "Robot is at x/y coordinates #{x}/#{y} and facing #{direction}"
        end
      end
    end
  end

  describe 'change_orientation' do
    it 'does not change the orientation of the robot if it has NOT been placed' do
      expect(subject.send(:report)).to eql "first PLACE the robot"
    end

    context 'when the robot has been placed' do
      let (:command) { "PLACE 2,2,N" }
      before { subject.send(:place, command) }

      context 'and the user wants to rotate clockwise (Right)' do
        it 'rotates the direction from North to East' do
          subject.send(:change_orientation, true)
          expect(subject.direction).to eql 'E'
        end
      end

      context 'and the user wants to rotate anti-clockwise (Left)' do
        it 'rotates the direction from North to West' do
          subject.send(:change_orientation, false)
          expect(subject.direction).to eql 'W'
        end
      end
    end
  end
end

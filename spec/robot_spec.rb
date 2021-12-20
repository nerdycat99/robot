require 'spec_helper'

RSpec.describe  Robot, type: :class do

  let (:valid_directions) { ["NORTH","EAST","SOUTH","WEST"] }
  let (:new_board) { Board.new(width: 4,height: 4, valid_directions: valid_directions) }
  let (:coordinates) { Coordinates.new(x: 2, y: 2, direction: 'WEST') }
  let (:robot_direction) { 'N' }
  subject { Robot.new }

  describe "initialize" do
    it 'creates an instance of a robot' do
      expect(subject).not_to be nil
    end
  end

  describe "update_position_with" do
    it 'assigns a valid set of coordinates to hold the robots position' do
      subject.update_position_with coordinates
      expect(subject.position.x).to eql coordinates.x
      expect(subject.position.y).to eql coordinates.y
      expect(subject.position.direction).to eql coordinates.direction
    end
  end

  describe "place" do
    let (:good_x) { 1 }
    let (:good_y) { 1 }
    let (:good_direction) { 'WEST' }
    let (:out_of_bounds_x) { 7 }
    let (:out_of_bounds_y) { 9 }
    let (:bad_x) { 'w' }
    let (:bad_y) { 'q' }
    let (:bad_direction) { 'OPLM' }

    context "when the user provides valid coordinates and a valid direction" do
      let (:command) { "PLACE #{good_x},#{good_y},#{good_direction}" }

      it "places the robot at the correct location for the input given, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position.x).to eql good_x - 1
        expect(subject.position.y).to eql good_y - 1
        expect(subject.position.direction).to eql good_direction
      end

      it "places the robot at the specified location from a users perspective, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position.display_x).to eql good_x
        expect(subject.position.display_y).to eql good_y
        expect(subject.position.direction).to eql good_direction
      end
    end

    context "when the user provides one invalid coordinate and a valid direction" do
      let (:command) { "PLACE #{bad_x},#{good_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position).to eql nil
        expect(subject.message).to eql "sorry your instructions for positioning the robot were invalid, please try again"
      end
    end

    context "when the user provides both invalid coordinate and a valid direction" do
      let (:command) { "PLACE #{bad_x},#{bad_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position).to eql nil
        expect(subject.message).to eql "sorry your instructions for positioning the robot were invalid, please try again"
      end
    end

    context "when the user provides valid coordinates but an invalid direction" do
      let (:command) { "PLACE #{good_x},#{good_y},#{bad_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position).to eql nil
        expect(subject.message).to eql "sorry your instructions for positioning the robot were invalid, please try again"
      end
    end

    context "when the user provides one out of bound coordinate and a valid direction" do
      let (:command) { "PLACE #{out_of_bounds_x},#{good_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position).to eql nil
        expect(subject.message).to eql "sorry I can't do that, your instructions would make the robot fall off the table"
      end
    end

    context "when the user provides both out of bound coordinates and a valid direction" do
      let (:command) { "PLACE #{out_of_bounds_x},#{out_of_bounds_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position).to eql nil
        expect(subject.message).to eql "sorry I can't do that, your instructions would make the robot fall off the table"
      end
    end

    context "when the user provides the correct command without commas" do
      let (:command) { "PLACE #{good_x}#{good_y}#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position).to eql nil
        expect(subject.message).to eql "sorry that was not valid, please type 'PLACE X,Y,D' to continue."
      end
    end

    context "when the user provides an incorrect command" do
      let (:command) { "please place #{good_x},#{good_y},#{good_direction}" }
      
      it "does not place the robot at the specified location, facing the specificed direction" do
        subject.send(:place, command, new_board)
        expect(subject.position).to eql nil
        expect(subject.message).to eql "sorry your instructions for positioning the robot were invalid, please try again"
      end
    end
  end

  describe "move" do
    context 'when the user has not yet placed the robot' do
      it "does not move the robot to a new location" do
        subject.send(:move, offset:1, board: new_board)
        expect(subject.position).to eql nil
        expect(subject.message).to eql "you must PLACE the robot before we can move it."
      end
    end

    context 'when the user has placed the robot' do
      let (:x) { 1 }
      let (:y) { 1 }
      let (:x1) { 4 }
      let (:y1) { 4 }

      context 'and the move is still in bounds for the board' do
        let (:command) { "PLACE #{x},#{y},NORTH" }
        before { subject.send(:place, command, new_board) }

        it "moves the robot to a new location" do
          expect { subject.send(:move, offset:1, board: new_board) }.to change { subject.position.display_y }.to y+1
        end
      end

      context 'and the move would be out of bounds for the y coordinate' do
        let (:command_north) { "PLACE #{x},#{y1},NORTH" }
        before { subject.send(:place, command_north, new_board) }

        it "does not move the robot to a new location" do
          expect(subject.position.display_y).to eql y1
        end
      end

      context 'and the move would be out of bounds for the x coordinate' do
        let (:command_east) { "PLACE #{x1},#{y},EAST" }
        before { subject.send(:place, command_east, new_board) }

        it "does not move the robot to a new location" do
          expect(subject.position.display_x).to eql x1
        end
      end
    end
  end

  describe 'report' do
    it 'does not output the location of the robot if it has NOT yet been placed' do
      subject.send(:report)
      expect(subject.message).to eql "you must PLACE the robot before we can move it."
    end

    context 'when the robot has been placed' do
      let (:x) { 2 }
      let (:y) { 3 }
      let (:direction) { 'SOUTH' }
      let (:command) { "PLACE #{x},#{y},#{direction}" }
      before { subject.send(:place, command, new_board) }

      it 'outputs the location of the robot if it has NOT been placed' do
        expect(subject.send(:report)).to eql "Robot is at x/y coordinates #{x}/#{y} and facing #{direction}"
      end
    end
  end

  describe 'change_orientation' do
    let(:rotational_direction) { ["NORTH","EAST","SOUTH","WEST"] }

    context 'when the robot has not yet been placed' do
      it 'does NOT change the orientation of the robot' do
        subject.change_orientation rotational_direction
        expect(subject.message).to eql "you must PLACE the robot before we can move it."
      end
    end

    context 'when the robot has been placed' do
      let (:command) { "PLACE 2,2,NORTH" }
      before { subject.send(:place, command, new_board) }

      it 'does change the orientation of the robot' do
        subject.change_orientation rotational_direction
        expect(subject.position.direction).to eql 'EAST'
      end
    end
  end
end

## MOVE THE ROBOT USER INSTRUCTIONS

Allows the user to position a robot on a platform (5x5 by default) facing in any direction of the compass and to then move the robot on that board in any direction and receive a notification at any time as to the current position and heading of the robot.

To start run 'ruby start.rb' from the lib folder and follow the instructions. Alternatively you can use 'ruby start.rb X Y' (without commas) to stipulate the board size (where X is the board width from 1 upwards and Y it's height from 1 upwards).

Using the default board, x1/y1 is the bottom south west corner of the platform, x5/y5 is the north east corner.

After starting a game you must first position the robot on the board using the command 'PLACE X,Y,F'; where X is the position horizontally, Y the position vertically and F the initial direction to face the robot in (North, East, South, West).

After placing the robot on the platform it can be moved one square at a time using 'MOVE' or rotated left/right by typing 'LEFT' or 'RIGHT' to rotate the robot.

To find out the current location and direction of the robot type 'REPORT' and you can quit at any time by typing 'QUIT'.


## Initial Setup

After downloading run bundle install, this works as a CLI app so no need to start rails server etc.


## To run the test

Run the test file by running 'bundle exec rspec' from the root folder of this project.

clear;
clear Plotting;
clear PlottingTest;
clear SensorModel;
clear drawTire;
clear Control;
clear Dynamics;
clear drawTrack;
clear drawPoolEnvironment;
clear drawCar;
clear drawChassis;
clear controlCircle;
clear MotorModels;
clf;

global controlArray;
global controlIndex;
global velocity;
global dt;
global includeUncertainty;
global sigmaSteering;
global sigmaDrive;
global sigmaPos;
global sigmaPosTime;
global muPosTime;

global driveTable;
global steerTable;

% driveTable = [77, 0.9; 78 1.1; 79 1.5; 80 1.9]; % sample data
% steerTable = [75, 84; 76, 86]; % sample data

%driveTable = [78 4.6; 80 7.8; 82 11.0; 84 13.1;]; % sample data pwm, speed;

%steerTable = [60, 45; 62, 45; 64, 55; 66, 60;...
%68, 70; 70 75; 72 80; 74 90;...
%                76 95; 78 105; 80 110; 82 115;...
%                84 120; 86 125; 88 130;]; % sample data pwm, angle
%ERIK CAR
driveTable = [78 92; 80 1.56; 82 2.19; 84 2.61];
steerTable = [54, 45; 56, 45; 58, 55; 60, 60;
  62, 70; 64, 75; 66, 80; 68, 85;
  70, 90; 72, 95; 74, 105;  76, 110; 
  80, 115; 82, 120; 84, 125; 86, 130];

includeUncertainty = true;
sigmaSteering = deg2rad(5); %steering angle
sigmaDrive = 0.2; %m/s
sigmaPos = 0.1;
sigmaPosTime = 0.1;
muPosTime = 0.7;

velocity = 2;
dt = 0.01;
carLocation = [1.3 7.5]';  %Car location
%carLocation = [15, 10]';
%carLocation = [11.6,10]';

thetaC = -pi/2; %initial angle of the car

X = [carLocation(1) carLocation(2) thetaC]'; %x, y, thetaC
U = [velocity, 0]; %, vel, thetaS
seed = rng('shuffle');

% circ/line(0/1), C_x/W1_x, C_y/W1_y, R/W2_x, CW/CCW (0,1) / W2_y,
% Nx(halfplane), Ny(Halfplane), Px(halfplane), Py(Halfplane)
% controlArray = [1, 1, 9, 1, 2, 0, -1, 1, 2; 
%             0, 2.1, 2.1, 1, 1, 1, 0, 2, 1
%             1, 2, 1, 6, 2, 1, 0, 6, 2
%             1, 6, 2, 10, 1.5, 1, 0, 9.8, 1.5
%             0, 9.9, 2.6, 1, 1, 0, 1, 10.8, 2.5
%             1, 11, 2.5, 11, 5, 0, 1, 11, 5
%             0, 10, 4.9, 1, 1, 0, -1, 9, 5
%             0, 7.9, 5.1, 1, 0, -1, 0, 8, 4
%             1, 8, 4, 4, 4.5, -1, 0, 4.2, 4.5
%             0, 4.1, 5.6, 1, 0, 0, 1, 3, 5.3
%             1, 3, 5.5, 3, 8, 0, 1, 3, 7.6
%             0, 4.1, 7.9, 1, 0, 1, 0, 3.8, 9
%             1, 4, 9, 10, 9, 1, 0, 10.1, 9
%             0, 10, 10.5, 1.5, 1, -1, 0, 10, 12
%             1, 10, 12, 6, 10, -1, 0, 6, 10
%             1, 6, 10, 2, 10, -1, 0, 2, 10
%             0, 2, 9, 1, 1, 0, -1, 1, 9];
% controlArray = [0,10,10,1.5,0,-1,0,0,0;
%                0,0,0,0,0,0,0,0,0];
% controlArray = [0,10,10,0.5,0,0,-1,10.5,10;
%                 1,10.5,10,10.5,9,0,-1,10.5,9;
%                 0,10,9,0.5,0,0,1,9.5,9;
%                 1,9.5,9,9.5,10,0,1,9.5,10]
% circ/line(0/1), C_x/W1_x, C_y/W1_y, R/W2_x, CW/CCW (0,1) / W2_y,
% Nx(halfplane), Ny(Halfplane), Px(halfplane), Py(Halfplane)
controlArray = [1, 1.1, 9, 1, 2, 0, -1, 1, 4; 
                0, 3, 3.3, 2, 1, 1, 0, 4, 1%2.3,1
                1, 2.5, 1.5, 5.8, 1.6, 1, 0, 5.8, 2
                1, 5.8, 1.6, 9, 1.5, 1, 0, 8.9, 1.4       
                %1, 9, 1.2, 11, 2, 0, 1, 11, 2
                0, 9.1 , 3.5, 2, 1, 1, 1, 11, 2.7
                1, 10.9, 2, 10.9, 5, 0, 1, 11, 4                
                0, 9.5, 4.5, 1.35, 1, -1, -1, 8.2, 5
                0, 6.8, 5.3, 1.4, 0, -1, 0, 6.9, 4.5
                1, 7.5, 3.6, 3, 4.2, -1, 0, 4.8, 5
                0, 5, 5.5, 1.6, 0, 0, 1, 3, 5.3
                1, 3.2, 5.5, 3.3, 7.5, 0, 1, 3, 6.6
                0, 4.8, 6.6, 1.5, 0, 1, 0, 4.1, 8
                1, 4.1, 8.1, 9.7, 8.6, 1, 0, 9, 8.5
                0, 9, 10, 1.5, 1, -1, 0, 9, 11
                1, 9, 11.5, 6, 10.4, -1, 0, 6, 10
                1, 6, 10.4, 2, 10.2, -1, 0, 3, 10
                0, 2.6, 8.8, 1.5, 1, 0, -1, 1, 9];

    controlIndex = 1;
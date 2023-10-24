% The general parameteres for the drivetrain are defined here. These
% include the coupling stiffness between each gearbox stage, wind turbine
% rotor speed, and damping parameteres for the entire gearbox and for the main
% shaft. A vector called "DTparameters" will contain the values specified
% here and it is one of the inputs to the BuilDrivetrain class.

Jr = 3.9e7;           % Wind turbine rotor inertia
K1 = 8.67637e8;       % LSS stiffness [Nm/rad]
K2 = 4.21e8;        % LSS to ISS coupling stiffness [Nm/rad]
K3 = 4.64e9;        % ISS to HSS coupling stiffness [Nm/rad]
K4 = 3.58e7;        % HSS to generator coupling stiffness [Nm/rad]
l1 = 0.7;
l2 = 0.7;
l3 = 0.3;
% 
% K2 = 2.8172e9;        % LSS to ISS coupling stiffness [Nm/rad]
% K3 = 0.4111e10;        % ISS to HSS coupling stiffness [Nm/rad]
% K4 = 0.0119e10;        % HSS to generator coupling stiffness [Nm/rad]

%omegaWT = 1.2671;     % [rad/s] Low-speed shaft speed. This value is used to set the initial conditions
DTparameters(1) = 3;            % number of stages
DTparameters(2) = 2;            % Coupling type. 1: Torsion only, 2: lateral and torsion 
DTparameters(3) = 0;            % alpha parameters for damping of the gearbox
DTparameters(4) = 0.0083;       % beta parameters for damping of the gearbox
DTparameters(5) = 0;                % alpha parameters for damping of the coupling with the rotor
DTparameters(6) = 7.0725e-03;       % beta parameters for damping of the coupling with the rotor
DTparameters(7:9) = [l1,l2,l3];
DTparameters(10) = K1;
DTparameters(11) = K2;
DTparameters(12) = K3;
DTparameters(13) = K4;
DTparameters(14) = Jr;
clear K1 K2 K3 K4 Jr


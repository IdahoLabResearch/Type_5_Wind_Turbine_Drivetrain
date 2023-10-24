%***************************************************************************************
% ------------------------- Planetary stage No. 1 for a 5MW drivetrain -----------------
%
% Created by: Juan Gallego-Calderon, March 2014.
% Based on the data from the paper:
% Dabrowski, D., Natarajan, A.,"Assessment of Gearbox Operational Loads and
% Reliability under High Mean Wind Speeds"
%***************************************************************************************

%% Physical quantities
Zg              = 82;            % Number of teeth - gear
Zp              = 23;            % Number of teeth - pinion

module      = 22.1;             % Normal module [mm]
alpha       = 20;             % Pressure angle [deg]
beta        = 10;             % Helix angle [deg]

rho         = 7850;           % material density [kg/m^3]
face_width  = 329e-3;         % Face width [mm]

rp_gear         = 1814.8/2*1e-3; % pitch radii of the gear [m]
rp_pinion       = 509/2*1e-3; % pitch radii of the pinion [m]
rb_gear         = rp_gear*cos(deg2rad(alpha)); % base radius of the gear [m]
rb_pinion       = rp_pinion*cos(deg2rad(alpha)); % base radius of the pinion [m]


% Scaling factors from the 750kW to 5MW
kUpm        = (5e6/750e3)^(3/2);
kUpI        = (5e6/750e3);

m_gear          = 6860;             % mass of the gear [kg]
m_pinion        = 1707;             % mass of the pinion [kg]
I_gear          = 3371;          % inertia of the gear [kg*m^2]
I_pinion        = 45;          % inertia of the pinion [kg*m^2]
kg_mesh         = 3.2e9;       % average mesh stiffness [N/m]

kb              = 1e9;             % bearing stiffness [N/m]

kb_pinion 		= 8.2e8 + 1.3e8 + 7.3e7;
kb_gear			= 1.2e9 + 5e8 + 3.3e8;
% Getting the geometric parameteres to represent the helical gears as spur
% gears using the module and number of teeth

ComplexityFlag  = 2;             % regarding the conmplexity of the model:
            % 1 - 1D Torsional
            % 2 - 2D Translational/rotational
%% Create geometrical parameters vector to be used as an input to the model            
geoParameters_Parallel_No1 = [rb_gear,rb_pinion,m_gear,m_pinion,I_gear,I_pinion,kg_mesh,kb_gear,kb_pinion,alpha,beta,Zg,Zp,ComplexityFlag,rp_gear,rp_pinion];

%% Dynamic simulation parameters
if ComplexityFlag == 1
    q0Parallel_No1   = [0,0,0,0];         % initial condition vector for state-space model
elseif ComplexityFlag == 2;
    q0Parallel_No1   = [zeros(1,3),...
                        0,rp_gear+rp_pinion,0];
                    %q0Parallel_No1 = zeros(1,6);
end

zetaParallel = [0,0];           % vector that contains alpha q0(1) and beta q0(2) parameters to defin Raleygh damping

%*************************************************************************
clear rb_gear rb_pinion m_gear m_pinion I_gear I_pinion kg_mesh kb alpha beta Zg Zp ComplexityFlag rp_gear rp_pinion
%*************************************************************************

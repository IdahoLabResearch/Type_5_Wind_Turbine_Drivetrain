%
% --------------------------------------------------------------------------------------
% Example to use the gearbox classes to build a wind turbine drivetrain.
% Created by: Juan Gallego-Calderon, March 2014.
%
%***************************************************************************************

%clear all; close all; clc

% These scripts define the parameteres for each of the stages of the
% gearbox, along with the generator and the general properties of the
% drivetrain -- usually given by the type of wind turbine.
% The scripts can be used for any type of model (1D or 2D), the difference
% is in the definition of the complexity flag. Therefore, special attention
% must be given to this variable on each of the input files depending on
% the desired complexity level of the models.
% run inputPlanetaryStage_1_JinPaper
% run inputPlanetaryStage_1_JinPaper
run input_PlanetaryStage_1
run input_ParallelStage_1
run input_ParallelStage_2
run inputGenerator
run input_DriveTrain_2D

omegaWT = 1.88;     % [rad/s] Low-speed shaft speed. This value is used to set the initial conditions
% Tlss0 = 5e6/omegaWT;

% Create objects for each stage
PlanetaryStage_No1    = PlanetaryGear(geoParameters_Planetary_No1,q0Planetary_01,zetaPlanetary_01,omegaWT);
ParallelStage_No1     = ParallelGear(geoParameters_Parallel_No1,q0Parallel_No1,zetaParallel,omegaWT*PlanetaryStage_No1.n_total);
ParallelStage_No2 	  = ParallelGear(geoParameters_Parallel_No2,q0Parallel_No2,zetaParallel,omegaWT*PlanetaryStage_No1.n_total*ParallelStage_No1.n_total);

% The following script defines the number of stages, the coupling
% stiffnesses between the stages, damping parameteres of the gearbox and
% main shaft, and rotor speed (rated).

% Sets the parameteres of the generator model
% Get the input parameteres of the generator into the objeect
GenModel     = Generator(ParametersGen_DFIG_5MW);
% Define the control gains for the generator
GenModel      = MachineControl(GenModel, ControlParameters_DFIG_5MW);
% Define the model constants that are used in Simulink
GenModel      = MachineDynamicModel(GenModel);

% Generate the system matrices
if PlanetaryStage_No1.ComplexityFlag == 1 && ParallelStage_No1.ComplexityFlag == 1 && ParallelStage_No2.ComplexityFlag == 1
% if PlanetaryStage.ComplexityFlag == 1
     PlanetaryStage_No1 = Build_PlanetaryGear(PlanetaryStage_No1);
     ParallelStage_No1  = Build_1D_PlanetaryGear(ParallelStage_No1);
     ParallelStage_No2  = Build_1D_ParallelGear(ParallelStage_No2);
else
    PlanetaryStage_No1 = Build_PlanetaryGear(PlanetaryStage_No1);
    ParallelStage_No1  = Build_2D_ParallelGear(ParallelStage_No1,DTparameters(2));
    ParallelStage_No2  = Build_2D_ParallelGear(ParallelStage_No2,1);
end

%% Build the gearbox
DriveTrain5MW = BuildDrivetrain(DTparameters);
% The GLOBAL system matrices are build. IMPORTANT!!! the order in which the
% inputs objects to the next function are arranged, is the same order of the
% stages in the gearbox from LSS to HSS

DriveTrain5MW = GearboxSystemMatrices(DriveTrain5MW,PlanetaryStage_No1,ParallelStage_No1,ParallelStage_No2,GenModel);
DriveTrain5MW = ModalAnalysis(DriveTrain5MW);


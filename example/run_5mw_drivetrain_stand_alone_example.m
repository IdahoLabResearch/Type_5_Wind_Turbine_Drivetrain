% Run stand-alone Drivetrain example
% clear all; clc; close all;

res_FileName = './res/drivetrain_5mw_stand_alone';

% Initialize 5MW drivetrain and simulation parameters
Tend = 200;

run Gearbox5MW_init
ss_RefPower = -GenModel.Pn/GenModel.eta;    % The steady state power

%
om_step = 1.1;  % percentage to step up/down in reference speed at the Low-speed Shaft
po_step = 0;    % percentage to step up/down reference power

clear Fault
Ts_sim_F = 1e-3;
GridLossTime = 1000;
SwitchFAULT = Tend+1;
FaultTimes = [SwitchFAULT Tend];
gridcode = cellstr(['Denmark';'Ireland';'USA    ';'Quebec ']);
[t_gr,LVRTprofile,gr] = GenerateVoltageProfile(gridcode{1},FaultTimes,Ts_sim_F);
FaultDelta  = gr.FaultDuration;
SwitchFAULT_Clears = SwitchFAULT + gr.FaultDuration + gr.RecoveryTime;
Fault.time = [];
Fault.signals.values = LVRTprofile;
Fault.signals.dimensions = 1;


%simout = sim('Drivetrain5MW_DFIG','StopTime',num2str(Tend),'SaveTime','on','TimeSaveName','tout');

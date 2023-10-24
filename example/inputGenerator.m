%***************************************************************************************
% ------------------------- Example input for the generator class --------------------
%
% Created by: Juan Gallego-Calderon, March 2014.
%
%%***************************************************************************************

type = 2;                                   % Type of generatro: (1) PMSG, (2) DFIG
Pn = 5e6;                                   % rated power [W]        
Tn = 4e3;                                   % rated torque [Nm]
Un = 480;                                   % line-to-line RMS value [V]
Vsq = -Un/sqrt(3)*sqrt(2);                  % stator voltage in q-axis [V]
Vsd = 0;                                    % stator voltage in d-axis [V]
Vrd = 0;                                    % rotor voltage in d-axis [V]
Vrq = 0;                                    % rotor voltage in q-axis [V]
Unl = Un/sqrt(3);                           % line-to-neutral RMS value [V]
polepair = 3;                               % pole pairs
f = 60;                                     % line frequency [Hz]
om_sync = rpm2radsec(120*f/(2*polepair));   % synchronous speed
Rs = 2.55e-4;                               % stator resistance [ohm]
Rr = 4.35e-4;                               % rotor resistance [ohm]. Rr = 0 for PMSG
Xd = 0;                                     % d-axis reactance [ohm] (PMSG only, otherwise zero)
Xq = 0;                                     % q-axis reactance [ohm] (PMSG only, otherwise zero)
Xs = 4.5e-3;                                % stator reactance [ohm] (DFIG only, otherwise zero)
Xr = 6.0e-3;                                % rotor reactance [ohm] (DFIG only, otherwise zero)
Xm = 4.25;                                  % mutual reactance [ohm] (DFIG only, otherwise zero)
slip = -1.062/100;                          % operational slip (DFIG only, otherwise zero)
%I_gen = 534.116;                           % generator rotor inertia [kg*m^2]
I_gen = 5.022512671631969e+02;              % generator rotor inertia [kg*m^2]
eta = 94.4;                                 % Generator efficiency [%]

%% Create geometrical parameters vector to be used as an input to the model            
ParametersGen_DFIG_5MW = [type,Pn,Tn,Un,Vsq,Vsd,Vrd,Vrq,Unl,om_sync,polepair,f,Rs,Rr,Xd,Xq,Xs,Xr,Xm,slip,I_gen,eta];
%*************************************************************************
clear type Pn Tn Un Vsq Vsd Vrd Vrq Unl nsync polepair f Rs Rr Xd Xq Xs Xr Xm slip I_gen
%*************************************************************************
% From using the PID tuner tool in Simulink
% outter loop - Active power     / inner loop - Rotor current Iq
KpP     = 0.00957890098810026;    KpIq   = 0.435207128511693;
KiP    = 139.222439658911;        KiIq   = 202.904901169888;
Pmaxim = 6.5e6;      Iq_max = 10.3e4;

% outter loop - Reactive power   / inner loop - Rotor current Id
KpQ     = 0.01;    KpId    = 0.0171332427828938;
KiQ    = 10;       KiId   = 10.7511072442759;
Qmaxim = 1e12;     Id_max = 10.3e4;

KQ     = 0.01;    KId    = 1;
TiQ    = 0.1;    TiId   = 0.05;

ControlParameters_DFIG_5MW = [KpP, KiP, KpIq, KiIq, Pmaxim, Iq_max, KpQ, KiQ, KpId, KiId, Qmaxim, Id_max];
%clear KP TiP KIq TiIq Pmaxim Iq_max KQ TiQ KId TiId Qmaxim Id_max
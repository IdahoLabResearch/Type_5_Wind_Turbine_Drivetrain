% Model parameter values are set here
%


%%% --- All data are contained in this file ---

% global mbase   tbase   kd   td   kg   tg
% global velm    gmax gmin dturb pgc   blg  tbd  dbbd tbs  dbbs blb  hdam
% global ggv     pgv  qgv  bgv  bgvmin      deff buf  buv  bvlm
% global tw 
% global eff     s     ss   ds 
% global gout    gv   ag   bc    bb    ab   hscroll   bh gy
% global t       delt
% global pinit   pmech pelec plocal delec;
% 
% global tpe ke tsp h  pref
% global re  rg fd  kp ki
% global gbias  bbias
% 
% global ggv    pgv  bgv

mbase = 8.9;                         % generator MVA base
tbase = 8.3;                         % turbine real power base, MW
h   = 0.83;                          % rotating inertia constant
tpe = 0.5;                          % governor elec. power detector t.c.
tsp = 0.05;                         % governor speed detector time constant
fd = 0;                             % 0 for speed mode, 1 for load mode
re = .05;                           % governor droop - load control mode
% td = .05;                           % derivative gain filter tie constant
kg = 5;                             % gate servo pilot gain
tg = 0.05;                          % gate servo pilot tc
velm = 0.2;                         % gate velocity limit
gmax = 1;                           % max gate stroke
gmin = 0;                           % min gate stroke
dturb = 0.5;                        % turbine damping at g=1
pgc = 0.0;                          % motoring power at g=0                                              
hdam = 1.0;                         % available head
deff = 1.0;                         % off-cam efficiency penalty factor
buf = 0.1;                          % top of buffer region
buv = 0.03;                         % buffer gate closing rate
tw  = 3;                            % water inertia time constant
tbd = 0.;                           % blade pilot servo time constant
tbs = 0.;                           % blade servo time constant
dbbd = 0.0;                         % deliberate blade cam deadband
dbbs = 0.0;                         % blade servo mechanical deadband
blg  = 0.0;                         % gate lineage backlash
blb  = 0.0;                         % blade linkage backlash
bvlm = 1.01;                        % blade servo velocity limit
bgvmin = .8;                        % turbine flow factor as min blade stroke


ggv = [   0   30   40   50   60   70   80   90   95 100 ]/100;
pgv = [ -.4 1.63 2.35 2.98 3.61 4.95 5.98 6.68 6.75 6.8 ]/8.3; % divided by 8.3 to make it per u
bgv = [   0 9.50 16.0 22.5 30.0 53.5 77.1 87.6 93.0 100 ]/100;


figure(1);  clf;
plot(ggv,pgv,'r', ggv,bgv,'b');  grid on;
xlabel(' Gate servo stroke, pu');
ylabel('Power, Blade servo stroke, pu');
legend('Power', 'Blade', 'location', 'northwest');
orient landscape
set( gcf, 'PaperPosition',[0.25,0.25,10.5,7.5]);
print('-dpdf','IFLcurves.pdf'); 

%%

% %====== parameters for grid connected mode of operation =====
% 
% kp = 2.5;                           % governor porportional gain
% ki = .25;                           % governor integral gain
% kd = 0;                             % governor derivative gain
% td = .05;                           % derivative gain filter tie constant
% 
% delec = 1.;                         % electrical damping coefficient
% ke = 5;                             % electrical synchronizing coefficient
% rg = .06;                           % governor droop - speed cpntrol mode
% 
% pinit  = 4;                          
% plocal = 0;
% bbias = -.0

%%
%  =============  override standard model parameters as appropriate (when
%  in isolated mode of operation) [Feb 2020 John's code]==========
% 
% kp = 1.0;
% ki = 0.1;
% kd = 0.0;
% td = .05;                           % derivative gain filter tie constant
% 
% delec = 0.0;
% ke = 0;
% 
% bbias = -.0
% rg = 0;                           % governor droop - speed control mode







%%
%  =============  override standard model parameters as appropriate (when
%  in isolated mode of operation) [December 2017 Field Test/ Matt Roberts]==========


%== 1MW + load steps ==
pinit  = 4;                          
plocal = 4;
bbias = -.0;

ke=0;
delec = 0.0;
bbias = -.0
rg = 0.02;                           % governor droop - speed cpntrol mode
td = 0.05;                           % derivative gain filter tie constant

%kp=0.5;
%ki=0.05;
%kd=0.4;

% from april 19 P=1.5, I= 0.08, D= 0.75, droop=0
kp = 1.5;
ki = 0.08;
kd = 0.75;
delec = 0.0;
rg=0;


% set up initial operating condition

ke = 0;
pinit  = 0.5533;                          
plocal = 0.5533;   
bbias = -.0

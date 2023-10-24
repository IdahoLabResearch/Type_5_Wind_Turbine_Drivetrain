% 4-pole, 60 Hz, Synchronous generator specification for DeWind 8.2.
%Nominal speed of wind rotor: 18 RPM. Speed range: 11.1 ~ 20.7 RPM
Pgen = 2e6; %Default is the rated watts. This dispatch power should come from the load flow analysis
N = 1800; %rated rpm of the 4-pole synchronous generator's rotor

nu = 1; %Angular Speed Ratio. %Deafult is 1.
%Nameplate Range for DeWind 8.2: 1.62 ~ 0.87
%Feasible zones 0.8819 <= speed ratio <= 1.073
% 1.141 <= speed ratio <= 1.268
%fzero gives feasible solution of \Phi = 0 in stator exit angle for the given nu

%Initialization Notes: 
%Given: w_mech = 188.5 rad/sec for a 4-pole, 60 Hz, (N = 1800) RPM synchronous machine
%w_gen = 120*pi rad/sec; w_gen : w_mech = 3600 : N
%Tmech [N.m] = (30/pi) x Power [W] / N [RPM]
%Low speed to high speed Gear Ratio = 1:100 for DeWind 8.2  
%wi = Gear Ratio*w_ref; Ti = T_rotor/(Gear Ratio)

%Calculate tgen and wt_0 from Pgen and N
tgen = (30*Pgen/(pi*N)); % [N-m] turbine torque. (-) sign represents "turbine" side of the torque converter.
%This value is much higher than 150 N.m 
wt_0 = (N/3600)*120*pi; % [rad/sec] turbine angular velocity for 2 MW, 1800 RPM synchronous machine.
%wi_0 > 39.8 rad/sec for Voith WinDrive
pa = 2.73; %Geometric parameter amplification set to bring Phi near zero at unity speed ratio.
bias_i = 43.0693;
bias_t = 3.3333;
inlet_bias_i = 3.5588;
inlet_bias_t = 0.0980;
inlet_bias_s = 2.5098;

wi_0 = (1.0/nu)*wt_0;

% Determine tt.
if (nu > 1)
    tt = -tgen/nu^2; %Square law of downscaling torque.
%     tt = -tgen/nu; %Unit power law of downscaling torque.    
else
    tt = -tgen;
end

%Autombile Torque Converter Ri_exit > Rt_exit > Rs_exit
% Ri_exit =  0.1101; % impeller/pump exit radius [m] 
%( "adjusted value" from Hrovat-1985 paper =  0.4700 ft)
%("Error Minimized value" from Pohl-2003 paper = 0.0991 m )
Ri_exit =  0.0991*pa;

% Rt_exit =  0.0668; % turbine exit radius [m] 
%( "adjusted value" from Hrovat-1985 paper =  0.2575 ft )
%("Error Minimized value" from Pohl-2003 paper = 0.0735 m )
Rt_exit =  0.0735*pa; 

% Rs_exit =  0.0605; % stator exit radius [m] 
%( "adjusted value" from Hrovat-1985 paper =  0.2477 ft )
%("Error Minimized value" from Pohl-2003 paper = 0.0665 m )
Rs_exit =  0.0665*pa;


%% Coupler Parameter
%K4 = 3.58e3; %Coupling stiffness
K4 = 35800000*(2/5);  %Coupling stiffness
%% Torque Converter Parameters for intialization

p = 840; % fluid density [kg/m^3]. Typical value: 800~900 kg/m^3
% p = 850;

% Ao = 0.0097; %cross-sectional flow area [m^2]
%("Error Minimized value" from Pohl-2003 paper = 0.0107)
Ao = 0.0107*(pa^2); 


% Lf = 1; % [m], equivalent fluid inertia length 
%(0.2594 m from Pohl-2003 paper)
%(0.28 m from Asl - 2014 paper)
Lf = 0.2594*pa; 

%Exit angles in radian
% alpha_i_exit = deg2rad(18.01); % impeller exit angles 
%( "adjusted value" from Hrovat-1985 paper =  30.68 degree)
%("Error Minimized value" from Pohl-2003 paper = 16.21 degree )
% alpha_i_exit = deg2rad(16.21);

%set to bring Phi near zero at unity speed ratio.
alpha_i_exit = deg2rad(16.21 + bias_i);

% alpha_t_exit =  deg2rad(-59.04); % turbine exit angles 
%( "adjusted value" from Hrovat-1985 paper =  -60.45 degree)
% alpha_t_exit =  deg2rad(-60.45); 
%("Error Minimized value" from Pohl-2003 paper = -53.14 degree )
% alpha_t_exit =  deg2rad(-53.14);

%set to bring Phi near zero at unity speed ratio. 
alpha_t_exit =  deg2rad(-53.14 - bias_t);

% alpha_s_exit = deg2rad(64.96); % stator exit angle "adjusted value" from Hrovat-1985 paper, since Asl-2014 have wrong value
%("Error Minimized value" from Pohl-2003 paper = 55.62 degree )
% alpha_s_exit = deg2rad(55.62); %0.9708 rad
%We want to intialize alpha_s_exit

% f = 0.25; % fluid friction factor. Typical value: 0.2 ~ 0.3 from
% Hrovat-1985 paper
%("Error Minimized value" from Pohl-2003 paper = 0.197)
f = 0.197;
 
%Shock loss coefficients
% Cshi = 1; % shock loss coefficients 
%("adjusted value" from Hrovat-1985 paper = 0.32 )
%("Error Minimized value" from Pohl-2003 paper = 1.011 )
Cshi = 1.011;

% Csht = 1; % shock loss coefficients 
%("adjusted value" from Hrovat-1985 paper = 1.27 )
%("Error Minimized value" from Pohl-2003 paper = 1.8 )
Csht = 1.8;

% Cshs = 1; % shock loss coefficients 
%("adjusted value" from Hrovat-1985 paper = 0.92 )
%("Error Minimized value" from Pohl-2003 paper = 0.773 )
Cshs = 0.773;

% alpha_i_inlet = deg2rad(-9.47); % impeller inlet angles 
%( "adjusted value" from Hrovat-1985 paper =  -15.47 degree)
%("Error Minimized value" from Pohl-2003 paper = -40.7 degree )
alpha_i_inlet = deg2rad(-40.7 - inlet_bias_i);

% alpha_t_inlet =  deg2rad(60.17); % turbine inlet angles  
%( "adjusted value" from Hrovat-1985 paper =  60.17 degree)
%("Error Minimized value" from Pohl-2003 paper = 59.19 degree )
alpha_t_inlet =  deg2rad(59.19 + inlet_bias_t);

% alpha_s_inlet = deg2rad(0.32); % stator inlet angles     
%( "adjusted value" from Hrovat-1985 paper =  0.32 degree)
%("Error Minimized value" from Pohl-2003 paper = 60.36 degree )
alpha_s_inlet = deg2rad(60.36 + inlet_bias_s);

      
%Turbine torque determines hydraulic fluid's volumatric flow rate.
        
%Approach 2: Calculate Q0, given wt, wi, and tt0 = tt.

at = p*(Rt_exit*tan(alpha_t_exit)-Ri_exit*tan(alpha_i_exit))/Ao;
bt = p*(wt_0*Rt_exit^2-wi_0*Ri_exit^2);
ct = -tt;

rt = roots([at bt ct]); 
Q0 = max(rt); %Captures the positive flow rate.

%Calculate hydraulic fluid's flow velocity, V_0

V_0 = Q0/Ao;

%Solve \Phi to calculate stator exit angle
             
%Impeller torque and flow velocity determines Stator exit angle. 
     
%Approach 2: Calculate alpha_s_exit_0, given tt0 = tt and rest of the parameters.

myfun = @(x) TorqueConverter_Phi(V_0, f, Cshi, Csht, Cshs, Ri_exit, Rt_exit, Rs_exit, wi_0, wt_0, ...
   x, alpha_t_exit, alpha_i_exit, alpha_s_inlet, alpha_t_inlet, alpha_i_inlet);

alpha_s_exit_0 = fzero(@(x) myfun(x),0);
% alpha_s_exit_0 = 1.2144;

Phi_calc = TorqueConverter_Phi(V_0, f, Cshi, Csht, Cshs, Ri_exit, Rt_exit, Rs_exit, wi_0, wt_0, ...
     alpha_s_exit_0, alpha_t_exit, alpha_i_exit, alpha_s_inlet, alpha_t_inlet, alpha_i_inlet);

%Calulate steady state impeller torque, ti0 = ti
ti = p*Q0*(wi_0*Ri_exit^2 ...
    + V_0*(Ri_exit*tan(alpha_i_exit) - Rs_exit*tan(alpha_s_exit_0)));

%% Other parameters
 
% Si = -0.001; %characteristic area constant for impeller/pump [m^2]
Si = -1.0859e-3; %from Pohl-2003 paper

% St = -0.00002; %characteristic area constant for turbine [m^2]
St = -2.1537e-5; %from Pohl-2003 paper

% Ss = 0.002; %characteristic area constant for stator [m^2]
Ss = 2.4747e-3; %from Pohl-2003 paper

Ii= 0.0926; % impeller/pump moment of inertia [kg.m^2]
It = 0.0267; % turbine moment of inertia [kg.m^2]
Is = 0.012; % stator moment of inertia [kg.m^2]

%Inlet radius is needed according to Deur-2002 paper. From page 68 (of 81), Master thesis "Y. Li and M. Sundén, "Modelling and measurement of transient torque converter characteristics," Master's thesis, 2016."
% we can say that 

Ri_inlet = Rs_exit;% impeller inlet radius
Rt_inlet = Ri_exit;% turbine inlet radius 
Rs_inlet = Rt_exit;% stator inlet radius

%Calculate Phi across 
% alpha_s_exit = linspace(0,1.33,10);
% for i = 1:length(alpha_s_exit)
% Phi_calc(i) = TorqueConverter_Phi(V_0, f, Cshi, Csht, Cshs, Ri_exit, Rt_exit, Rs_exit, wi_0, wt_0, ...
%     alpha_s_exit(i), alpha_t_exit, alpha_i_exit, alpha_s_inlet, alpha_t_inlet, alpha_i_inlet);
% 
% end
% 
% plot(alpha_s_exit,Phi_calc); 
%COMMENT: Plot of \Phi shifts down from fully positive (nu = 0.87) to zero 
%crossing (nu = 1.0) and then to negative (nu = 1.67) as T2I angular speed ratio increases 


%DriveTrain5MW.zetaShaft = DriveTrain5MW.zetaShaft*1000;






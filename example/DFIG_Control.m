% State-space model of generator controller
run inputGenerator_DFIG_5MW

GenModel     = Generator(ParametersGen_DFIG_5MW);  
% Define the control gains for the generator
GenModel      = MachineControl(GenModel,ControlParameters_DFIG_5MW);
% Define the model constants that are used in Simulink
GenModel      = MachineDynamicModel(GenModel);
GenModel      = SteadyStateDFIG(GenModel);

f = GenModel.f;
Lm = GenModel.Xm/(2*pi*f);
Ls = GenModel.Xs/(2*pi*f);
Lr = GenModel.Xr/(2*pi*f);
Rs = GenModel.Rs;
Rr = GenModel.Rr;
wse = GenModel.omegaE;
wre = GenModel.omegaR;
D = Lm^2 - Ls*Lr;
ii=1;
J = GenModel.I_gen;
pf = GenModel.polepair;

%% steady-state quantities
flux_sd_0 = -1.455;
flux_sq_0 = 1.1555e-3;
flux_rd_0 = -1.047;
flux_rq_0 = -0.2443;

Ak = (1/J)*(3/2)*(pf^2)*Lm/D;

% state-space model
A_dfig = [     Rs*Lr/D         -wse          -Rs*Lm/D            0           0;
            wse          Rs*Lr/D            0           -Rs*Lm/D        0;
         -Rr*Lm/D           0            Rr*Lm/D        wre-wse     flux_rq_0;
             0           -Rr*Lm/D        wse-wre        Rr*Lm/D     flux_rd_0;
        -Ak*flux_rq_0    Ak*flux_rd_0     Ak*flux_sq_0    -Ak*flux_sd_0      0];

B_dfig = diag([1 1 1 1 -pf/J]);

C_dfig = zeros(5,5);
C_dfig(1:4,1:4) = GenModel.modelDFIG.Q;
C_dfig(5,1:4)   = 3/2*pf*Lm/D*wre*[flux_sq_0    flux_rd_0   -flux_sd_0  -flux_rq_0];

D_dfig = zeros(size(C_dfig));    

% GenEig = eig(A_dfig)

sysDFIG = ss(A_dfig,B_dfig,C_dfig,D_dfig,'StateName',{'flux_sd' 'flux_sq' 'flux_rd' 'flux_rq' 'omega_re'},'OutputName',{'isd' 'isq' 'ird' 'irq' 'Tm'},'InputName',{'usd' 'usq' 'urd' 'urq' 'TL'});

[omgaGen, Z, P] = damp(sysDFIG);
tfDFIG = tf(sysDFIG);
[Y1,T1] = step(sysDFIG);
[Mag1,Ph1,W1] = bode(sysDFIG);
TFINAL1 = T1(end);

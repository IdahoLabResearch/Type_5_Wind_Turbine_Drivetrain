function [Phi] = TorqueConverter_Phi(V, f, Cshi, Csht, Cshs, Ri, Rt, Rs, wi, wt, ...
    alpha_s_exit, alpha_t_exit, alpha_i_exit, alpha_s_inlet, alpha_t_inlet, alpha_i_inlet)


%%%%This code will calculate \Phi, and \Psi according to eqs. (23), (24) of 
%Hrovat-1985 paper%%%%

% %Calculate Shock Velocities
% Vshi = -Rs*wi + V*(tan(alpha_s_exit)-tan(alpha_i_inlet));
% Vsht = Ri*(wi - wt) + V*(tan(alpha_i_exit) - tan(alpha_t_inlet));
% Vshs = Rt*wt + V*(tan(alpha_t_exit) - tan(alpha_s_inlet));
% 
% %Calculate Fluid Velocity relative to blade squared
% %Following Fig. 2 and eq.(3) of Hrovat-1985 paper,
% %1 + tan(a)^2 = sec(a)^2
% Viss = V^2*(sec(alpha_i_exit))^2;
% Vtss = V^2*(sec(alpha_t_exit))^2;
% Vsss = V^2*(sec(alpha_s_exit))^2;
% 
% %Calculate \Psi
% Psi = 0.5*(Cshi*Vshi^2 + Csht*Vsht^2 + Cshs*Vshs^2 + f*(Viss + Vtss + Vsss));
% 
% % Calculate \Phi
% Phi = Ri^2*wi^2 + Rt^2*wt^2 - Ri^2*wt*wi + wi*V*(Ri*tan(alpha_i_exit) - Rs*tan(alpha_s_exit))...
%     + wt*V*(Rt*tan(alpha_t_exit) - Ri*tan(alpha_i_exit))- Psi;

%%%Calculation based on the Hrovat - 2002 paper. This will need inlet radius information. 
%%From page 68 (of 81), Master thesis "Y. Li and M. Sundén, "Modelling and measurement of transient torque converter characteristics," Master's thesis, 2016."
%following continuity holds.

Rii = Rs;% impeller inlet radius
Rti = Ri;% turbine inlet radius 
Rsi = Rt;% stator inlet radius
% 
%Calculate A
A = ((2-Csht)*Ri^2 - Cshi*Rii^2)/2;
%Calculate B
B = ((2-Cshs)*Rt^2 - Csht*Rti^2)/2;
%Calculate E
E = -Ri*(Ri-Rti*Csht);
%Calculate G
G = (1-Csht)*Ri*tan(alpha_i_exit) - (1-Rii*Cshi/Rs)*Rs*tan(alpha_s_exit)...
    + Csht*Ri*tan(alpha_t_inlet) - Cshi*Rii*tan(alpha_i_inlet);
%Calculate H
H = (1-Cshs)*Rt*tan(alpha_t_exit) - (1-Rti*Csht/Ri)*Ri*tan(alpha_i_exit)...
    + Cshs*Rt*tan(alpha_s_inlet) - Csht*Rti*tan(alpha_t_inlet);
%Calculate J
J = -(Csht*(tan(alpha_i_exit) - tan(alpha_t_inlet))^2 ...
    + Cshs*(tan(alpha_t_exit) - tan(alpha_s_inlet))^2 ...
    + Cshi*(tan(alpha_s_exit) - tan(alpha_i_inlet))^2 + f)/2;
%Calculate \Phi
Phi = A*wi^2 + B*wt^2 +E*wi*wt + V*(G*wi + H*wt) + J*V^2;

end

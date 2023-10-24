%
%  initialization
%

% global mbase   tbase   kd   td   kg   tg
% global velm    gmax gmin dturb pgc   blg  tbd  dbbd tbs  dbbs blb  hdam
% global ggv     pgv  qgv  bgv  bgvmin      deff buf  buv  bvlm
% global tw 
% global eff     s     ss   ds 
% global gout    gv   ag   bc    bb    ab   hscroll   bh
% global t       delt
% global pmech   pinit pelec plocal delec
% 
% global tpe ke tsp h  pref
% global re  rg fd  kp ki
% global gbias bbias


for i = 1 : 10                                      % build flow-area versus gate table 
    qgv(i) = ggv(i) * (bgvmin+(1-bgvmin)*bgv(i));
end;

pelec = pinit/mbase                                 % scale elec power to generator Mbase
pmech = pinit/tbase                                 % scale mech power to turbine Tbase


dtp = deff*bbias*bbias                              % apply off-cam power decrememnt
pmt = pmech + dtp

flow = interp( pmt, pgv, qgv, 10 )                  % look up flow for this initial power

is = -1;   a = 0;                                           % find which segment of gate/blade curve

if ( (pmt/hdam) < pgv(1) ) 
    is = 1;
    a = 0;
    g = ggv(1) + ((pmt/hdam)-pgv(1))*(ggv(2)-ggv(1))/(pgv(2)-pgv(1))
else
    for i = 2 : 10                                              % is active
    if (( pmt/hdam >= pgv(i-1)) && (pmt/hdam <= pgv(i)) )
        d = ggv(i-1);                                       % get d,e,a coeffs for this segment
        e = bgv(i-1);
        a = (bgv(i) - bgv(i-1)) / (ggv(i) - ggv(i-1));
        is = i-1;
        break;
    end;
end;


if ( is < 0 ) disp("Overloaded"); return;  end;                    % flag turbine overload

B = bgvmin                                                  % solve the quadratic for gate opening
A = 1 - B;

if ( a > 0 )
    aqc = A * a
    bqc = B + A*e - A*a*d + A*bbias
    cqc = - flow / sqrt(hdam)
    g = (-bqc+sqrt(bqc*bqc-4*aqc*cqc))/(2*aqc)
    
    bb = interp( g, ggv, bgv, 10 );
    disp(sprintf("Blade initialized at bb = %10.4f", bb ));
else
    disp("Found flat blade segment");
    g = interp( flow/sqrt(hdam), qgv, ggv, 10 );
end;                                                                % g is estimate of gate opening


for i = 1 : 10                                                      % refine the gate estimate in case gate and
    bc = bgvmin + (1-bgvmin) * (interp(g, ggv, bgv,10)+bbias);      % blade lie on different segments
    af = g * bc;                                                    % (do 5 iterations)
    flow = sqrt(hdam)*af;                                           % (Iterate on g)
    ph = hdam * interp(flow, qgv, pgv, 10);
    disp([g bc flow]);
    g = g + 0.9*(pmt-ph);
end;

end;
gout = g;                                                   



% initialize state variables
s(8) = flow;
s(4) = 0;
s(5) = g;  

s(7) = bb;                            
bb = s(7);  s(6) = s(7);  bh = s(7);                        

gv = g; % g is estimate of gate opening

hscroll = hdam;
pref = 1;
s(9) = pinit/tbase;


s(1) = 1;

if ( fd >  0 ) pref = 1 + s(9) * re;  end;
if ( fd == 0 ) pref = 1 + gout * rg;  end;    

s(2) = 0;
if ( fd >  0 ) s(2) = gout - kp * ( pref - 1 );  end;
if ( fd == 0 ) s(2) = gout - kp * ( pref - 1 - rg * gout );  end;

s(3) = 0;

s(10) = 1;
if ( ke > 0 ) s(11) = ( pinit/mbase - plocal/mbase) / ke;
else          s(11) = 0;
end;

err = 0;


for i = 1 : 11                                               % initialize
    ds(i) = 0;                                               % integration       
    ss(i) = s(i);                                            % process
end



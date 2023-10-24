%
% linear interpolation via table of n points 
% input is a
% independent variable is x
% dependent variable is y
% 
function z = interp( a, x, y, n )
z = 0;

if ( a >  x(n) ) z = y(n); return;  end;
if ( a <= x(1) ) z = y(1); return;  end;
for i = 1 : n-1
    if ( a <= x(i+1) )
        z = y(i) + (a-x(i))*(y(i+1)-y(i))/(x(i+1)-x(i));
        return;
    end
end
    
end
    

function [ fun ] = f( bvp )
%F Right hand side of the PDE
%   Detailed explanation goes here

    if (bvp == 1)
        fun = @(x,y) sin(pi*x)*sin(pi*y);
    elseif (bvp == 2)
        fun = @(x,y) cos(pi*x)*cos(pi*y);
    end        

end
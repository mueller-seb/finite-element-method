function [ fun ] = u( bvp )
%U Analytical solution u of the BVP
%   Detailed explanation goes here

    if (bvp == 1)
        fun = @(x, y) sin(pi*x)*sin(pi*y) / (2*pi^2);
    elseif (bvp == 2)
        fun = @(x, y) cos(pi*x)*cos(pi*y) / (2*pi^2);
    end

end


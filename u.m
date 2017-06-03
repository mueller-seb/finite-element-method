function [ value ] = u( bvp, x, y )
%U Summary of this function goes here
%   Detailed explanation goes here

if (bvp == 1)
    value = sin(pi*x)*sin(pi*y) / (2*pi^2);
elseif (bvp == 2)
    value = cos(pi*x)*cos(pi*y) / (2*pi^2);
else
    value = NaN;
end

end


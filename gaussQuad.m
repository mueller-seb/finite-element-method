function [ value ] = gaussQuad( func, nodes, N )
%INT Summary of this function goes here
%   Detailed explanation goes here

n = size(nodes, 2);

if (n == 3)
    value = fastTriGaussQuad(func, nodes, N);
elseif (n == 4)
    value = qdrGaussQuad(func, nodes, N);
end

end


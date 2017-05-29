function [ U3D ] = exactSolution( bvp, n )
%EXACTSOLUTION Summary of this function goes here
%   Detailed explanation goes here
x = linspace(0, 1, n+1);
y = linspace(0, 1, n+1);
[X, Y] = meshgrid(x, y);
if (bvp == 1)
    U = sin(pi*X) .* sin(pi*Y) / (2*pi^2);
elseif (bvp == 2)
    U = cos(pi*X) .* cos(pi*Y) / (2*pi^2);
end
U3D = cat(3, X, Y, U);
end


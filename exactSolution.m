function [ U3D ] = exactSolution( bvp, Omega, n )
%EXACTSOLUTION Summary of this function goes here
%   Detailed explanation goes here
x = linspace(Omega(1), Omega(2), n(1)+1);
y = linspace(Omega(3), Omega(4), n(2)+1);
[X, Y] = meshgrid(x, y);
if (bvp == 1)
    U = sin(pi*X) .* sin(pi*Y) / (2*pi^2);
elseif (bvp == 2)
    U = cos(pi*X) .* cos(pi*Y) / (2*pi^2);
end
U3D = cat(3, X, Y, U);
end


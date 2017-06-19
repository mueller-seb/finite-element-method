function [  ] = scalarFunctionPlot( b ) %NOT USED
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

x = linspace(0,1,11);
y = linspace(0,1,11);
Z = zeros(11);
for i = 0:10
    for j = 0:10
        Z(i+1,j+1) = b.evaluate(i/10, j/10);
    end
end
[X, Y] = meshgrid(x, y);
U = cat(3, X, Y, Z);

contour3(U(:,:,1), U(:,:,2), U(:,:,3));


end


function [ z ] = fastTriGaussQuad( fun, nodes, N )
%FASTTRIGAUSSQUAD SYMMETRICAL Gaussian quadrature on general triangle
%elements. 
%   Detailed explanation goes here

X = [nodes.x]';
Y = [nodes.y]';
xw = TriGaussPoints(N);  % get quadrature points and weights 

% calculate the area of the triangle
A=abs(X(1)*(Y(2)-Y(3))+X(2)*(Y(3)-Y(1))+X(3)*(Y(1)-Y(2)))/2.0;

% find number of Gauss points
NP=length(xw(:,1)); 

z = 0.0;
    for j = 1:NP
        x = X(1)*(1-xw(j,1)-xw(j,2))+X(2)*xw(j,1)+X(3)*xw(j,2);
        y = Y(1)*(1-xw(j,1)-xw(j,2))+Y(2)*xw(j,1)+Y(3)*xw(j,2);
        z = z + fun(x,y)*xw(j,3);
    end
z = A*z;

%return
end


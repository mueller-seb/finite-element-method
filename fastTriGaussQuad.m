function [ z ] = fastTriGaussQuad( fun, nodes, N )
%FASTTRIGAUSSQUAD SYMMETRICAL Gaussian quadrature on general triangle
%elements. 
%   N is order of Gauss quadrature, not the number of weight points Ng

% procedure is from http://math2.uncc.edu/~shaodeng/TEACHING/math5172/Lectures/Lect_15.PDF
% but one can also use my own, non symmetrical implementation in
% triGaussQuad.m instead by selecting it in the gaussQuad switch.

X = [nodes.x]';
Y = [nodes.y]';
xw = TriGaussPoints(N);  % get quadrature points and weights 

% Determinant of Jacobian = area of the triangle
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


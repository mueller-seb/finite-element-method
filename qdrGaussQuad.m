function [ value ] = qdrGaussQuad( fun, nodes, N )
%QDRGAUSSQUAD 2-dim Gaussian quadrature of order N for general quadrilateral elements K.
%
%   Transforms the quadrilateral element K to the standard quadrilateral
%   element Rst using nodal shape functions N first and then applies the
%   Gaussian quadrature on Rst.

%   Gaussian quadrature using N points (of order N) can provide the exact integral if
%   f(x) is a polynomial of degree 2N − 1 or less.

%get N Gaussian quadrature points and weights
xw = GaussPoints(N);

X = [nodes.x]';
Y = [nodes.y]';

%Nodal shape functions of transformation
function sN = shapeN(xi, eta)
    sN = 0.25*[(1-xi)*(1-eta), (1+xi)*(1-eta), (1+xi)*(1+eta), (1-xi)*(1+eta)];
end

%Jacobian of the transformation
function value = J(xi, eta)
   dxdxi = 0.25*(-X(1)*(1-eta)+X(2)*(1-eta)+X(3)*(1+eta)-X(4)*(1+eta));
   dxdeta = 0.25*(-X(1)*(1-xi)-X(2)*(1+xi)+X(3)*(1+xi)+X(4)*(1-xi));
   dydxi = 0.25*(-Y(1)*(1-eta)+Y(2)*(1-eta)+Y(3)*(1+eta)-Y(4)*(1+eta));
   dydeta = 0.25*(-Y(1)*(1-xi)-Y(2)*(1+xi)+Y(3)*(1+xi)+Y(4)*(1-xi));
   value = det([dxdxi, dydxi; dxdeta, dydeta]);
end
    
    value = 0;
    for i = 1:size(xw, 1)
        for j = 1:size(xw, 1)
            sN = shapeN(xw(i,1), xw(j,1));
            x = sN*X;
            y = sN*Y;
            value = value + xw(i,2)*xw(j,2)*fun(x,y)*abs(J(xw(i,1), xw(j,2)));
        end
    end
end


function [ value ] = sqrGaussQuad( fun, nodes, N )
%SQRGAUSSQUAD This function evaluates \int_a^b \int_c^d f(x) dx using the Gaussian quadrature  of order N.
%   Gaussian quadrature using N points can provide the exact integral if f(x) is a polynomial of degree 2N − 1 or less

%   This function evaluates \int_a^b f(x) dx using 
%   the Gaussian quadrature  of order N.

X = [nodes.x]';
Y = [nodes.y]';
xw = GaussPoints(N);  % get quadrature points and weights 

function N = shapeN(xi, eta)
    N = 0.25*[(1-xi)*(1-eta), (1+xi)*(1-eta), (1+xi)*(1+eta), (1-xi)*(1+eta)];
end

%J(xi, eta) = det(partial(x,y)/partial(xi, eta))
J(xi, eta) = det([0.25*(-X(1)+X(2)+X(3)-X(4)), 0.25*(-Y(1)+Y(2)+Y(3)-Y(4));
                  0.25*(-X(1)-X(2)+X(3)+X(4)), 0.25*(-Y(1)-Y(2)+Y(3)+Y(4))])
    
    value = 0;
    for i = 1:N
        for j = 1:N
            x = xMin + 0.5*(xMax-xMin)*(1+xw(i,1));
            y = yMin + 0.5*(yMax-yMin)*(1+xw(j,1));
            value = value + fun(x,y)*xw(i,2)*xw(j,2);
        end
    end
    value = 0.5^2*(xMax-xMin)*(yMax-yMin)*value;
end


function [ value ] = triGaussQuad( fun, nodes, N )
%GAUSSQUAD Gaussian quadrature for triangles by double transformation
%   Standard rectangle is first transformated to standard triangle and then
%   to the individual triangle

%N Gaussian quadrature points x and weights w
xw = GaussPoints(N);

X = [nodes.x]';
Y = [nodes.y]';

    function value = xi(a, b)
        value = (1+a)*(1-b)/4;
    end

    function value = eta(a, b)
        value = (1+b)/2;
    end

    function det = J(a, b)
        det = (1-b)/8;
    end

    function N = shapeN(xi, eta)
        N = [1-xi-eta, xi, eta];
    end
    
    function x = P(xi, eta)
        N = shapeN(xi, eta);
        x = N*X;
    end

    function y = Q(xi, eta)
        N = shapeN(xi, eta);
        y= N*Y;
    end
        

A_K = abs(X(1)*(Y(2)-Y(3))+X(2)*(Y(3)-Y(1))+X(3)*(Y(1)-Y(2)))/2;

sum = 0;
for i=1:size(xw, 1)
    for j=1:size(xw, 1)
        a = xw(i, 1);
        b = xw(j, 1);
        sum = sum + xw(i,2)*xw(j,2)*fun(P(xi(a,b), eta(a,b)), Q(xi(a,b), eta(a,b)))*abs(J(a,b));
        sum = sum*2*A_K;
    end
end
    
value = sum;

end


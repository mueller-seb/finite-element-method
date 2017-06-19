function [ value ] = triGaussQuad( fun, nodes, N )
%TRIGAUSSQUAD 2-dim Gaussian quadrature of order N for general triangle elements T.

%   Transforms the triangle element T to the standard triangle
%   element Tst using nodal shape functions N first and then transforms
%   the standard triangular element Tst to the standard quadrilateral element Rst. Then
%   applies the Gaussian quadrature for Rst.

%   Gaussian quadrature using N points (of order N) can provide the exact integral if
%   f(x) is a polynomial of degree 2N − 1 or less.

%get Gaussian quadrature points x and weights w
xw = GaussPoints(N);

X = [nodes.x]';
Y = [nodes.y]';

%1st Transformation: from standard quadriliteral element Rst to the standard triangle element Tst
    function value = xi(a, b)
        value = (1+a)*(1-b)/4;
    end

    function value = eta(a, b)
        value = (1+b)/2;
    end

 %Jacobian of the 1st transformation
    function det = J(a, b)
        det = (1-b)/8;
    end

%2nd Transformation: from standard triangle element Tst to arbitrary triangle element T
    function sN = shapeN(xi, eta)
        sN = [1-xi-eta, xi, eta];
    end
    
    function x = P(xi, eta)
        sN = shapeN(xi, eta);
        x = sN*X;
    end

    function y = Q(xi, eta)
        sN = shapeN(xi, eta);
        y= sN*Y;
    end

   %Jacobian of the 2nd transformation     
    A_K = abs(X(1)*(Y(2)-Y(3))+X(2)*(Y(3)-Y(1))+X(3)*(Y(1)-Y(2)))/2;

value = 0;
for i=1:size(xw, 1)
    for j=1:size(xw, 1)
        a = xw(i, 1);
        b = xw(j, 1);
        value = value + xw(i,2)*xw(j,2)*fun(P(xi(a,b), eta(a,b)), Q(xi(a,b), eta(a,b)))*abs(J(a,b));
    end
end

value = value*2*A_K;


end


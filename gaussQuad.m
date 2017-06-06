function [ value ] = gaussQuad( func, nodes, N )
%INT Gaussian quadrature switch for both triangle and square element types
%   N is the order of Gaussian quadrature (NOT number weight points Ng)

%dim(P_N) = 1 for triangle shape functions (linear), dim(P_N) = 2 for square
%shape functions (bilinear) and quadratic polynomials (1+x+y+xy+x^2+y^2)

n = size(nodes, 2);
if (n == 2)
    value = lineGaussQuad(func, nodes, N);
elseif (n == 3)
   value = fastTriGaussQuad(func, nodes, N);
   %value = triGaussQuad(func, nodes, N);
elseif (n == 4)
    value = qdrGaussQuad(func, nodes, N);
end

end


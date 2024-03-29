function [ value ] = lineGaussQuad( fun, nodes, N )
%LINEGAUSSQUAD Summary of this function goes here
%   Detailed explanation goes here
    xw = GaussPoints(N);  % get quadrature points and weights 
    
    X = [nodes.x];
    Y = [nodes.y];
    
    %Transformation, xi from -1 to 1
    function xy = gamma(xi) 
        xy = 0.5 * [X; Y] * [1-xi; 1+xi];
    end
    
    functDet = norm([0.5*(-X(1)+X(2)); 0.5*(-Y(1)+Y(2))]);
    

    %y = 0;
    %for j = 1:N
    %    x = a + 0.5*(b-a)*(1+xw(j,1));
    %    y = y + f(x)*xw(j,2);
    %end
    %y = 0.5*(b-a)*y;
    
    value = 0;
    for j=1:N
       XY = gamma(xw(j,1));
       value = value + fun(XY(1), XY(2)) * xw(j,2);
    end
    value = value * functDet;
end


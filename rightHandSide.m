function [ f_h ] = rightHandSide( N, funSpace, bvp )
%RIGHTHANDSIDE Calculates right hand side vector f_h
%   Detailed explanation goes here

n = size(funSpace.basisFunctions, 2);
f_h = zeros(n, 1);

for i=1:n
    phi_i = funSpace.basisFunctions(i);
    f_i = 0;
    for shapeFun_i = phi_i.shapeFunctions(1:end)
        nodes = shapeFun_i.domain.nodes;
        if (bvp == 1)
            fun = @(x,y) shapeFun_i.evaluate(x,y)*sin(pi*x)*sin(pi*y);
        elseif (bvp == 2)
            fun = @(x,y) shapeFun_i.evaluate(x,y)*cos(pi*x)*cos(pi*y);
        end
        f_i = f_i + gaussQuad(fun, nodes, N);
    end
    f_h(i,1) = f_i;
end

end


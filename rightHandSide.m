function [ f_h ] = rightHandSide( gaussOrder, funSpace )
%RIGHTHANDSIDE Calculates right hand side vector f_h
%   Detailed explanation goes here

n = size(funSpace.basisFunctions, 2);
f_h = zeros(n, 1);
F = f(funSpace.bvp);

for i=1:n
    phi_i = funSpace.basisFunctions(i);
    f_i = 0;
    for shapeFun_i = phi_i.shapeFunctions(1:end)
        nodes = shapeFun_i.domain.nodes;
        fun = @(x,y) shapeFun_i.evaluate(x,y)*F(x,y);
        f_i = f_i + gaussQuad(fun, nodes, gaussOrder);
    end
    f_h(i,1) = f_i;
end

end


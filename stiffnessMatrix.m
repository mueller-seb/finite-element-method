function [ A_h ] = stiffnessMatrix( funSpace, bvp )
%STIFFNESSMATRIX assembles stiffness matrix A_h
%   Detailed explanation goes here

n = size(funSpace.basisFunctions, 2);
A_h = zeros(n);

for i=1:n
    for j=1:n
        phi_i = funSpace.basisFunctions(i);
        phi_j = funSpace.basisFunctions(j);
        a_ij = 0;
        for shapeFun_i = phi_i.shapeFunctions(1:end)
            gradShapeFun_i = shapeFun_i.gradient;
            for shapeFun_j = phi_j.shapeFunctions(1:end)
                if (shapeFun_i.domain == shapeFun_j.domain)
                    nodes = shapeFun_i.domain.nodes;
                    gradShapeFun_j = shapeFun_j.gradient;
                    if (bvp == 1)
                        fun = @(x,y) dot(gradShapeFun_i.evaluate(x,y), gradShapeFun_j.evaluate(x,y)); %scalar product of gradients
                    end
                    a_ij = a_ij + gaussQuad(fun, nodes);
                end
            end
        end
        A_h(i,j) = a_ij;
    end
end

end


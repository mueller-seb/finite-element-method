function [ A_h ] = stiffnessMatrix2( ansFunSpace, gradAnsFunSpace, bvp )
%STIFFNESSMATRIX assembles stiffness matrix A_h
%   Detailed explanation goes here
N = 4;
n = size(gradAnsFunSpace.basisFunctionVectors, 2);
A_h = zeros(n);

for i=1:n
    for j=1:n
        gradPhi_i = gradAnsFunSpace.basisFunctionVectors(i);
        gradPhi_j = gradAnsFunSpace.basisFunctionVectors(j);
        a_ij = 0;
        M = size(gradPhi_i.shapeFunctionVectors, 2);
        N = size(gradPhi_j.shapeFunctionVectors, 2);
        for k=1:M %gradShapeFun_i = gradPhi_i.shapeFunctionVectors(1:end)
            gradShapeFun_i = gradPhi_i.shapeFunctionVectors(k);
            for l=1:N %gradShapeFun_j = gradPhi_j.shapeFunctionVectors(1:end)
                gradShapeFun_j = gradPhi_j.shapeFunctionVectors(l);
                if (gradShapeFun_i.domain == gradShapeFun_j.domain)
                    nodes = gradShapeFun_i.domain.nodes;
                    if (bvp == 1)
                        fun = @(x,y) dot(gradShapeFun_i.evaluate(x,y), gradShapeFun_j.evaluate(x,y)); %scalar product of gradients
                    elseif (bvp == 2)
                        shapeFun_i = ansFunSpace.basisFunctions(i).shapeFunctions(k);
                        shapeFun_j = ansFunSpace.basisFunctions(j).shapeFunctions(l);
                        fun = @(x,y) dot(gradShapeFun_i.evaluate(x,y), gradShapeFun_j.evaluate(x,y)) + (shapeFun_i.evaluate(x,y)*shapeFun_j.evaluate(x,y));
                    end
                    a_ij = a_ij + gaussQuad(fun, nodes, N);
                end
            end
        end
        A_h(i,j) = a_ij;
    end
end

end


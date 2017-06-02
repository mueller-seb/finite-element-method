function [ A_h ] = stiffnessMatrix( N, bvp, ansFunSpace, gradAnsFunSpace )
%STIFFNESSMATRIX Assembles stiffness matrix A_h
%   Detailed explanation goes here

n = size(gradAnsFunSpace.basisFunctionVectors, 2);
A_h = zeros(n);

if (nargin == 4) %gradients of ansatz function space already calculated (less CPU-intensive, more memory intensive)

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

elseif (nargin == 3) %gradients of ansatz function space not calculeted yet (more CPU-intensive, less memory intensive)
    
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
                    elseif (bvp == 2)
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

end
clc
clear variables
close all

intervals = 2;
neumann = 1;

M = triangleMesh(intervals)
S = ansatzFunctionSpace(M, neumann)

n = size(S.basisFunctions, 2);
A = zeros(n)

for i=1:n
    for j=1:n
        phi_i = S.basisFunctions(i);
        phi_j = S.basisFunctions(j);
        a_ij = 0;
        for shapeFun_i = S.basisFunctions(i).shapeFunctions(1:end)
            gradShapeFun_i = shapeFun_i.gradient;
            for shapeFun_j = S.basisFunctions(j).shapeFunctions(1:end)
                if (shapeFun_i.domain == shapeFun_j.domain)
                    nodes = shapeFun_i.domain.nodes;
                    gradShapeFun_j = shapeFun_j.gradient;
                    fun = @(x,y) dot(gradShapeFun_i.evaluate(x,y), gradShapeFun_j.evaluate(x,y)); %scalar product of gradients
                    a_ij = a_ij + integral2(fun, min([nodes.x]), max([nodes.x]), min([nodes.y]), max([nodes.y]));
                end
            end
        end
        A(i,j) = a_ij;
    end
end
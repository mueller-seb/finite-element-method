function [ A_h ] = stiffnessMatrix( gaussOrder, ansFunSpace, gradAnsFunSpace )
%STIFFNESSMATRIX Assembles stiffness matrix A_h
%   This is much more efficient if gradients of the ansatz function space is already given (gradAnsFunSpace). Otherwise gradients of basis
%   functions of the ansatz function space are computed multiple times during the queue.

n = size(ansFunSpace.scalarFunctions, 2);
A_h = zeros(n);
bvp = ansFunSpace.bvp; 

if (nargin == 3) %gradients of ansatz function space are given (less CPU-intensive, more memory intensive)
    
for i=1:n
    for j=1:n
        gradPhi_i = gradAnsFunSpace.vectorFunctions(i);
        gradPhi_j = gradAnsFunSpace.vectorFunctions(j);
        a_ij = 0;
        M = size(gradPhi_i.shapeVectorFunctions, 2);
        N = size(gradPhi_j.shapeVectorFunctions, 2);
        for k=1:M
            gradShapeScalarFun_i = gradPhi_i.shapeVectorFunctions(k);
            for l=1:N
                gradShapeScalarFun_j = gradPhi_j.shapeVectorFunctions(l);
                if (gradShapeScalarFun_i.domain == gradShapeScalarFun_j.domain)
                    nodes = gradShapeScalarFun_i.domain.nodes;
                    if (bvp == 1)
                        fun = @(x,y) dot(gradShapeScalarFun_i.evaluate(x,y), gradShapeScalarFun_j.evaluate(x,y)); %scalar product of gradients
                    elseif (bvp == 2)
                        shapeScalarFun_i = ansFunSpace.scalarFunctions(i).shapeScalarFunctions(k);
                        shapeScalarFun_j = ansFunSpace.scalarFunctions(j).shapeScalarFunctions(l);
                        fun = @(x,y) dot(gradShapeScalarFun_i.evaluate(x,y), gradShapeScalarFun_j.evaluate(x,y)) + (shapeScalarFun_i.evaluate(x,y)*shapeScalarFun_j.evaluate(x,y));
                    end
                    a_ij = a_ij + gaussQuad(fun, nodes, gaussOrder);
                end
            end
        end
        A_h(i,j) = a_ij;
    end
end

elseif (nargin == 2) %gradients of ansatz function space not given (more CPU-intensive, less memory intensive)
    
for i=1:n
    for j=1:n
        phi_i = ansFunSpace.scalarFunctions(i);
        phi_j = ansFunSpace.scalarFunctions(j);
        a_ij = 0;
        for shapeScalarFun_i = phi_i.shapeScalarFunctions(1:end)
            gradShapeScalarFun_i = shapeScalarFun_i.gradient;
            for shapeScalarFun_j = phi_j.shapeScalarFunctions(1:end)
                if (shapeScalarFun_i.domain == shapeScalarFun_j.domain)
                    nodes = shapeScalarFun_i.domain.nodes;
                    gradShapeScalarFun_j = shapeScalarFun_j.gradient;
                    if (bvp == 1)
                        fun = @(x,y) dot(gradShapeScalarFun_i.evaluate(x,y), gradShapeScalarFun_j.evaluate(x,y)); %scalar product of gradients
                    elseif (bvp == 2)
                        fun = @(x,y) dot(gradShapeScalarFun_i.evaluate(x,y), gradShapeScalarFun_j.evaluate(x,y)) + (shapeScalarFun_i.evaluate(x,y)*shapeScalarFun_j.evaluate(x,y));
                    end
                    a_ij = a_ij + gaussQuad(fun, nodes, gaussOrder);
                end
            end
        end
        A_h(i,j) = a_ij;
    end
end

end

end
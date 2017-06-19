function [ A_h ] = stiffnessMatrix( gaussOrder, ansFunSpace, gradAnsFunSpace )
%STIFFNESSMATRIX Assembles stiffness matrix A_h
% Algorithm is much more efficient if gradients of basis funtions in the ansatz function space are already given as gradAnsFunSpace.
% Otherwise gradients are computed multiple times during the queues.
% Calculation of integrals is sped up by considering only common domains of the basis functions instead of integrating over Omega. 
% Matrix is sparse, most entries are zero. Integrals are calculated only if basis nodes are neighbours (distance <= sqrt(2)).

n = size(ansFunSpace.scalarFunctions, 2);
A_h = zeros(n);
bvp = ansFunSpace.bvp;
elementType = ansFunSpace.Mesh.elementType;

if (nargin == 3) %gradients of basis functions of ansatz function space are given (less CPU-intensive, more memory intensive)
for i=1:n %go through gradients of all basis functions phi_i
    for j=1:i %go through gradients of all basis functions phi_j
        gradPhi_i = gradAnsFunSpace.vectorFunctions(i);
        gradPhi_j = gradAnsFunSpace.vectorFunctions(j);
        a_ij = 0;
        if (ismember(elementType, [1,2]))
            numBasisNodes = ansFunSpace.Mesh.subIntervals+[1,1];
            if (bvp == 1)
                numBasisNodes = numBasisNodes-[2,2]; %no basis functions defined on boundary points
            end
            nodeI = [mod(i, numBasisNodes(1)); ceil(i/numBasisNodes(1))];
            nodeJ = [mod(i, numBasisNodes(1)); ceil(j/numBasisNodes(1))];
            if (nodeI(1) == 0)
                nodeI(1) = numBasisNodes(1);
            end
            if (nodeJ(1) == 0)
                nodeJ(1) = numBasisNodes(1);
            end
        end
        if (~((elementType ~= 3) && (norm(nodeI-nodeJ) > sqrt(2)))) %Pythagoras: check if basis nodes are neighbours
            M = size(gradPhi_i.shapeVectorFunctions, 2);
            N = size(gradPhi_j.shapeVectorFunctions, 2);
            for k=1:M %go through all shape functions of gradient(phi_i)
                gradShapeScalarFun_i = gradPhi_i.shapeVectorFunctions(k);
                for l=1:N %go through all shape functions of gradient(phi_j)
                    gradShapeScalarFun_j = gradPhi_j.shapeVectorFunctions(l);
                    if (gradShapeScalarFun_i.domain == gradShapeScalarFun_j.domain) %Check if both shape functions are defined on the same domain. If so, proceed with calculating the integral on this domain. Otherwise the integrand would be zero.
                        nodes = gradShapeScalarFun_i.domain.nodes;
                        if (bvp == 1)
                            fun = @(x,y) dot(gradShapeScalarFun_i.evaluate(x,y), gradShapeScalarFun_j.evaluate(x,y)); %(grad(phi_i), grad(phi_j))
                        elseif (bvp == 2)
                            shapeScalarFun_i = ansFunSpace.scalarFunctions(i).shapeScalarFunctions(k);
                            shapeScalarFun_j = ansFunSpace.scalarFunctions(j).shapeScalarFunctions(l);
                            fun = @(x,y) dot(gradShapeScalarFun_i.evaluate(x,y), gradShapeScalarFun_j.evaluate(x,y)) + (shapeScalarFun_i.evaluate(x,y)*shapeScalarFun_j.evaluate(x,y)); %(grad(phi_i), grad(phi_j)) + phi_i * phi_j
                        end
                        a_ij = a_ij + gaussQuad(fun, nodes, gaussOrder);
                    end
                end
            end
        end
        A_h(i,j) = a_ij;
        A_h(j,i) = a_ij;
    end
end

%NOT USED
elseif (nargin == 2) %gradients of basis functions of ansatz function space not given (more CPU-intensive, less memory intensive)
    
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
                        fun = @(x,y) dot(gradShapeScalarFun_i.evaluate(x,y), gradShapeScalarFun_j.evaluate(x,y));
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
classdef ansatzFunctionSpace < scalarFunctionSpace
    %ANSATZFUNCTIONSPACE Basis of ansatz functions V_h
    %   Detailed explanation goes here
    
    properties
        Mesh
        bvp
    end
    
    methods
        function obj = ansatzFunctionSpace(Mesh, bvp, higherPolynomials)
            obj@scalarFunctionSpace;
            obj.scalarFunctions = basisFunction.empty;
            obj.Mesh = Mesh;
            obj.bvp = bvp;

            for node = obj.Mesh.nodes(1:end)
                 if(~(node.isBoundaryPoint && (obj.bvp == 1)))
                     obj.scalarFunctions(end+1) = basisFunction(node, higherPolynomials, obj.bvp);
                 end
            end
        end
        
        function gradAnsFunSpace = gradient(obj)
            N = size(obj.scalarFunctions, 2);
            gradBasisFuns = vectorFunction.empty(0, N);
            for i=1:N
                gradBasisFuns(i) = obj.scalarFunctions(i).gradient;
            end
            gradAnsFunSpace = vectorFunctionSpace(gradBasisFuns);
        end
        
        function divgradAnsFunSpace = laplace(obj)
            divgradAnsFunSpace = obj.gradient.divergence;
        end
            
    end
    
end


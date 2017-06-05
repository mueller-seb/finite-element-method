classdef ansatzFunctionSpace < handle
    %ANSATZFUNCTIONSPACE Basis of ansatz functions
    %   Detailed explanation goes here
    
    properties
        Mesh
        bvp
        basisFunctions = basisFunction.empty;
    end
    
    methods
        function obj = ansatzFunctionSpace(Mesh, bvp, higherPolynomials, basisFunctions)
            obj.Mesh = Mesh;
            obj.bvp = bvp;
            if (nargin == 3)
                for i=obj.Mesh.nodes(1:end)
                    if(~(i.isBoundaryPoint && (bvp == 1)))
                        obj.basisFunctions(end+1) = basisFunction(i, higherPolynomials);
                    end
                end
            elseif (nargin == 4)
                obj.basisFunctions = basisFunctions;
            end
        end
        
        function gradAnsFunSpace = gradient(obj)
            N = size(obj.basisFunctions, 2);
            gradBasisFuns = basisFunctionVector.empty(0, N);
            for i=1:N
                gradBasisFuns(i) = obj.basisFunctions(i).gradient;
            end
            gradAnsFunSpace = ansFunSpaceVec(obj.Mesh, gradBasisFuns);
        end
        
        function divgradAnsFunSpace = laplace(obj)
            divgradAnsFunSpace = obj.gradient.divergence;
        end
            
    end
    
end


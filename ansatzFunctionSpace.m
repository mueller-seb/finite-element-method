classdef ansatzFunctionSpace < handle
    %ANSATZFUNCTIONSPACE Creates basis for ansatz functions
    %   Detailed explanation goes here
    
    properties
        Mesh
        basisFunctions = basisFunction.empty;
    end
    
    methods
        function obj = ansatzFunctionSpace(Mesh, zeroOnBoundary, basisFunctions)
            obj.Mesh = Mesh;
            %obj.basisFunctions = basisFunction.empty(0, size(Mesh.nodes, 2));
            if (nargin == 2)
                for i=obj.Mesh.nodes(1:end)
                    if(~(i.isBoundaryPoint && zeroOnBoundary))
                        obj.basisFunctions(end+1) = basisFunction(i);
                    end
                end
            elseif (nargin == 3)
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


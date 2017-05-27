classdef ansatzFunctionSpace
    %ANSATZFUNCTIONSPACE Creates basis for ansatz functions
    %   Detailed explanation goes here
    
    properties
        Mesh
        basisFunctions = basisFunction.empty;
    end
    
    methods
        function obj = ansatzFunctionSpace(Mesh, zeroOnBoundary)
            obj.Mesh = Mesh;
            %obj.basisFunctions = basisFunction.empty;
            for i=obj.Mesh.nodes(1:end)
                if(~(i.isBoundaryPoint && zeroOnBoundary))
                    obj.basisFunctions(end+1) = basisFunction(i);
                end
            end          
        end
    end
    
end


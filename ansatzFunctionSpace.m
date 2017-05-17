classdef ansatzFunctionSpace
    %ANSATZFUNCTIONSPACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        meshref
        basisFunctions = basisFunction.empty;
    end
    
    methods
        function obj = ansatzFunctionSpace(meshref, zeroOnBoundary)
            obj.meshref = meshref;
            %obj.basisFunctions = basisFunction.empty;
            for i=obj.meshref.nodes(1:end)
                if(~(i.isBoundaryPoint && zeroOnBoundary))
                    obj.basisFunctions(end+1) = basisFunction(i);
                end
            end          
        end
    end
    
end


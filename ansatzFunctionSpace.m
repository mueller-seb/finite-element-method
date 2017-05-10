classdef ansatzFunctionSpace
    %ANSATZFUNCTIONSPACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        meshdata
        basisFunctions
    end
    
    methods
        function obj = ansatzFunctionSpace(meshdata, zeroOnBoundary)
            obj.meshdata = meshdata;
            obj.basisFunctions = basisFunction.empty;
            for i=obj.meshdata.nodes(1:end)
                if(~(i.isBoundaryPoint && zeroOnBoundary))
                    obj.basisFunctions(end+1) = basisFunction(obj.meshdata, i.ID);
                end
            end          
        end
    end
    
end


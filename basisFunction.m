classdef basisFunction
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        basisNodeID
        shapeFunctions
        diam
    end
    
    methods
        function obj = basisFunction(shapeFunctions)
            obj.shapeFunctions = shapeFunctions;
        end
    end
    
end


classdef scalarFunctionSpace < handle
    %SCALARFUNCTIONSPACE Space of scalar functions
    %   Detailed explanation goes here
    
    properties
        scalarFunctions = scalarFunction.empty
    end
    
    methods
        function obj = scalarFunctionSpace(scalarFunctions)
            if (nargin > 0)
                obj.scalarFunctions = scalarFunctions;
            end
        end
    end
    
end


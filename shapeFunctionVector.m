classdef shapeFunctionVector < handle
    %SHAPEFUNCTIONVECTOR Vector of shape functions
    %   Detailed explanation goes here
    
    properties
        shapeFunX = shapeFunction.empty(0, 1);
        shapeFunY = shapeFunction.empty(0, 1);
        domain
    end
    
    methods
        function obj = shapeFunctionVector(shapeFunX, shapeFunY)
            if (shapeFunX.domain == shapeFunY.domain)
                obj.shapeFunX = shapeFunX;
                obj.shapeFunY = shapeFunY;
                obj.domain = shapeFunX.domain;
            end
        end
        
        function value = evaluate(obj, x, y)
            value = [obj.shapeFunX.evaluate(x,y); obj.shapeFunY.evaluate(x,y)];
        end
        
        function div = divergence(obj)
            div = obj.shapeFunX.deriveX + obj.shapeFunY.deriveY;
        end
    end
    
end


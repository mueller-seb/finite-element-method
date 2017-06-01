classdef shapeFunctionVector < handle
    %SHAPEFUNCTIONVECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shapeFunX
        shapeFunY
        domain
    end
    
    methods
        function obj = shapeFunctionVector(shapeFunX, shapeFunY)
            obj.shapeFunX = shapeFunX;
            obj.shapeFunY = shapeFunY;
            if (shapeFunX.domain == shapeFunY.domain)
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


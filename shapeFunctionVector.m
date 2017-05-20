classdef shapeFunctionVector
    %SHAPEFUNCTIONVECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        shapeFunX
        shapeFunY
    end
    
    methods
        function obj = shapeFunctionVector(shapeFunX, shapeFunY)
            obj.shapeFunX = shapeFunX;
            obj.shapeFunY = shapeFunY;
        end
        
        function value = evaluate(obj, x, y)
            value = [obj.shapeFunX.evaluate(x,y); obj.shapeFunY.evaluate(x,y)];
        end
    end
    
end


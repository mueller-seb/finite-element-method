classdef shapeVectorFunction < handle
    %SHAPEVECTORFUNCTION Vector of shape scalar functions
    %   Detailed explanation goes here
    
    properties
        shapeScalarFunX = shapeScalarFunction.empty(0, 1);
        shapeScalarFunY = shapeScalarFunction.empty(0, 1);
        domain
    end
    
    methods
        function obj = shapeVectorFunction(shapeScalarFunX, shapeScalarFunY)
            if (shapeScalarFunX.domain == shapeScalarFunY.domain)
                obj.shapeScalarFunX = shapeScalarFunX;
                obj.shapeScalarFunY = shapeScalarFunY;
                obj.domain = shapeScalarFunX.domain;
            end
        end
        
        function value = evaluate(obj, x, y)
            value = [obj.shapeScalarFunX.evaluate(x,y); obj.shapeScalarFunY.evaluate(x,y)];
        end
        
        function div = divergence(obj)
            div = obj.shapeScalarFunX.deriveX + obj.shapeScalarFunY.deriveY;
        end
    end
    
end


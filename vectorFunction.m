classdef vectorFunction < handle
    %VECTORFUNCTION Vector field defined on Omega
    %   Detailed explanation goes here
    
    properties
        shapeVectorFunctions = shapeVectorFunction.empty;
    end
    
    methods
        function obj = vectorFunction(shapeVectorFunctions)
            obj.shapeVectorFunctions = shapeVectorFunctions;
        end
        
        function value = evaluate(obj, x, y)
            for shapeVecFun = obj.shapeVectorFunctions(1:end)
                if (shapeVecFun.evaluate(x, y) ~= zeros(2,1))
                    value = shapeVecFun.evaluate(x, y);
                    break;
                else
                    value = [0; 0];
                end
            end
        end
        
        function div = divergence(obj)
            N = size(obj.shapeVectorFunctions, 2);
            divShapeVecFun = shapeScalarFunction.empty(0, N);
            for i = 1:N
                divShapeVecFun(i) = obj.shapeVectorFunctions(i).shapeScalarFunX.deriveX + obj.shapeVectorFunctions(i).shapeScalarFunY.deriveY;
            end
            div = scalarFunction(divShapeVecFun);
        end
    end
    
end


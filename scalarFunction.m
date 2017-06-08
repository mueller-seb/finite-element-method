classdef scalarFunction < handle
    %SCALARFUNCTION Scalar function defined on Omega
    %   Detailed explanation goes here
    
    properties
        shapeScalarFunctions = shapeScalarFunction.empty;
    end
    
    methods
        function obj = scalarFunction(shapeScalarFunctions)
            if (nargin > 0) %necessary for basisFunction
                obj.shapeScalarFunctions = shapeScalarFunctions;
            end
        end
        
        function value = evaluate(obj, x, y)
            for shapeScalarFun = obj.shapeScalarFunctions(1:end)
                if (shapeScalarFun.evaluate(x, y) ~= 0)
                    value = shapeScalarFun.evaluate(x, y);
                    break;
                else
                    value = 0;
                end
            end
        end
        
        function sum = plus(obj1, obj2)
            sumShapeScalarFuns = obj1.shapeScalarFunctions;
            for shapeScalarFun = obj2.shapeScalarFunctions(1:end)
                i = find(sumShapeScalarFuns == shapeScalarFun);
                    if (~isempty(i)) 
                        sumShapeScalarFuns(i) = sumShapeScalarFuns(i) + shapeScalarFun;
                    else
                        sumShapeScalarFuns(end+1) = shapeScalarFun;
                    end
            end
            sum = scalarFunction(sumShapeFuns);
        end
        
        function derivation = deriveX(obj)
            N = size(obj.shapeScalarFunctions, 2);
            derivedShapeScalarFuns = shapeScalarFunction.empty(0, N);
            for i = 1:N
                derivedShapeScalarFuns(i) = obj.shapeScalarFunctions(i).deriveX;
            end
            derivation = scalarFunction(derivedShapeScalarFuns);
        end
        
        function derivation = deriveY(obj)
            N = size(obj.shapeScalarFunctions, 2);
            derivedShapeScalarFuns = shapeScalarFunction.empty(0, N);
            for i = 1:N
                derivedShapeScalarFuns(i) = obj.shapeScalarFunctions(i).deriveY;
            end
            derivation = scalarFunction(derivedShapeScalarFuns);
        end
        
        function gradScalarFun = gradient(obj)
            N = size(obj.shapeScalarFunctions, 2);
            gradShapeScalarFuns = shapeVectorFunction.empty(0, N);
            for i = 1:N
                gradShapeScalarFuns(i) = obj.shapeScalarFunctions(i).gradient;
            end
            gradScalarFun = vectorFunction(gradShapeScalarFuns);
        end
        
        function divgrad = laplace(obj)
            divgrad = obj.gradient.divergence; 
        end
    end    
end
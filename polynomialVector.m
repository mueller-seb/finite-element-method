classdef polynomialVector
    %POLYNOMIALVECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        polynomialX
        polynomialY
    end
    
    methods
        function obj = polynomialVector(polynomialX, polynomialY)
            obj.polynomialX = polynomialX;
            obj.polynomialY = polynomialY;
        end
        
        function value = evaluate(obj, x, y)
            value = [obj.polynomialX.evaluate(x, y); obj.polynomialY.evaluate(x, y)];
        end
        
        function div = divergence(obj)
            div = obj.polynomialX.deriveX + obj.polynomialY.deriveY;
        end
    end
    
end


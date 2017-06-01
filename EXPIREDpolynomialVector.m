classdef polynomialVector %NOT USED ANY MORE
    %POLYNOMIALVECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        polynomialX
        polynomialY
    end
    
    methods
        function obj = polynomialVector(polynomialX, polynomialY) %not used
            obj.polynomialX = polynomialX;
            obj.polynomialY = polynomialY;
        end
        
        function value = evaluate(obj, x, y) %not used
            value = [obj.polynomialX.evaluate(x, y); obj.polynomialY.evaluate(x, y)];
        end
        
        function div = divergence(obj) %not used
            div = obj.polynomialX.deriveX + obj.polynomialY.deriveY;
        end
    end
    
end


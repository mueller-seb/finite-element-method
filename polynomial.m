classdef polynomial < handle
    %POLYNOMIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        coefficients
        %         Polynomial coefficients ordered by
        %         
        %         [1,    y,      y^2,   y^3,  ...;
        %          x,    xy,     xy^2,  xy^3  ...;
        %          x^2,  x^2y,   ...             ;
        %          x^3,  ...                     ;
        %          ...                           ]
    end
    
    methods
        function obj = polynomial(coefficients)
            obj.coefficients = coefficients;
        end
        
        function value = evaluate(obj, x, y)
            value = 0;
            for i=1:size(obj.coefficients, 1)
                for j=1:size(obj.coefficients, 2)
                    value = value + obj.coefficients(i,j)*x^(i-1)*y^(j-1);
                end
            end
        end
        
        function sum = plus(obj1, obj2)
            dim = [size(obj1.coefficients); size(obj2.coefficients)];
            sumCoefficients = zeros(max(dim));
            sumCoefficients(1:dim(1,1), 1:dim(1,2)) = obj1.coefficients;
            sumCoefficients(1:dim(2,1), 1:dim(2,2)) = sumCoefficients(1:dim(2,1), 1:dim(2,2)) + obj2.coefficients;
            sum = polynomial(sumCoefficients);
        end
        
        function difference = minus(obj1, obj2) %not used
            subtrahend = polynomial(-obj2.coefficients);
            difference = plus(obj1, subtrahend);
        end
        
        function derivation = deriveX(obj)
            degX = size(obj.coefficients, 1);
            if (degX > 1)
                derivation = polynomial(obj.coefficients(2:end, :) .* (1:degX-1)');
            else
                derivation = polynomial(0);
            end
        end
        
        function derivation = deriveY(obj)
            degY = size(obj.coefficients, 2);
            if (degY > 1)
                derivation = polynomial(obj.coefficients(:, 2:end) .* (1:degY-1));
            else
                derivation = polynomial(0);
            end            
        end
        
        function grad = gradient(obj) %not used
            grad = polynomialVector(obj.deriveX, obj.deriveY);
        end
                
        function divgrad = laplace(obj) %not used
            divgrad = divergence(gradient(obj));
        end

    end
    
end


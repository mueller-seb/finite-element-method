classdef polynomial
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
            for i=1:size(obj.coefficients, 1)
                for j=1:size(obj.coefficients, 2)
                    value = value + obj.coefficients(i,j)*x^(i-1)*y^(j-1);
                end
            end
        end
    end
    
end


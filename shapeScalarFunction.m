classdef shapeScalarFunction < handle
    %SHAPESCALARFUNCTION Polynomial defined shape on one domain
    %   Coefficients calculation in the static methods part
    
    properties
        domain
        polynomial = polynomial.empty(0, 1);
    end
    
    methods
        function obj = shapeScalarFunction(domain, polynomial)
            obj.domain = domain;
            obj.polynomial = polynomial;
        end
        
        function value = evaluate(obj, x, y)
            if obj.domain.contains(x, y)
                value = obj.polynomial.evaluate(x,y);
            else
                value = 0;
            end
        end
        
        function sum = plus(obj1, obj2)
            if (obj1.domain == obj2.domain)
                sum = shapeScalarFunction(obj1.domain, (obj1.polynomial + obj2.polynomial));
            else
                sum = [obj1, obj2];
            end
        end
        
        function scaling = scale(obj, factor)
            scaling = shapeScalarFunction(obj.domain, scale(obj.polynomial, factor));
        end
        
        function derivation = deriveX(obj)
            derivation = shapeScalarFunction(obj.domain, obj.polynomial.deriveX);
        end
        
        function derivation = deriveY(obj)
            derivation = shapeScalarFunction(obj.domain, obj.polynomial.deriveY);
        end
        
        function grad = gradient(obj)
            grad = shapeVectorFunction(obj.deriveX, obj.deriveY);
        end
        
        function divgrad = laplace(obj)
            divgrad = obj.gradient.divergence;            
        end
    end
    
    methods (Static)
        function polyCoefficients = calcCoefficients(fixPoints, fixPointValues)
         
                n = size(fixPointValues, 2); %3=linear, 4=bilinear, 6=quadratic, 8
                if (size(fixPoints, 2) == n)
                    X = [fixPoints.x]';
                    Y = [fixPoints.y]';
                    A = [ones(n, 1), X, Y];
                    b = fixPointValues';
                    %  [x1;     [y1;
                    %X= x2;   Y= y2;
                    %   ...;     ...;
                    %   x6]      y6]
                    %  [1, x1, y1, x1y1, x1^2, y1^2;                               [b1;
                    %A= 1, x2, y2, x2y2, x2^2, y2^2; = [1; X; Y; XY; X^2; Y^2];  b= b2;
                    %   1, x3, y3, x3y3, x3^2, y3^2;                                b3;
                    %   1, x4, y4, x4y4, x4^2, y4^2;                                b4;
                    %   1, x5, y5, x5y5, x5^2, y5^2;                                b5;
                    %   1, x6, y6, x6y6, x6^2, y6^2;]                               b6]
                    %                      [c1;
                    %   Ac = b => c = A\b = c2;
                    %                       ...;
                    %                       c6]
                    %       [1,   Y,    Y^2;     [c1, c3, c6;
                    %coeff=  X,   XY,   XY^2;   = c2, c4, 0;
                    %        X^2, X^2Y, X^2Y^2]   c5, 0,  0]
                    switch n
                        case 3 %linear case with 3 coefficients
                            c=A\b;
                            coeff = [c(1), c(3);
                                     c(2), 0  ];
                        case 4 %bilinear case with 4 coefficients
                            A=[A, X.*Y];
                            c=A\b;
                            coeff = [c(1), c(3);
                                     c(2), c(4)];
                        case 6 %quadratic case qith 6 coefficients (for higher polynomials in triangles)
                            A=[A, X.*Y, X.*X, Y.*Y];
                            c=A\b;
                            coeff = [c(1), c(3), c(6);
                                     c(2), c(4), 0;
                                     c(5), 0,    0];
                        case 8 %case with 8 coefficients (for higher polynomials in squares)
                            A=[A, X.*Y, X.*X, Y.*Y, X.^2.*Y, X.*Y.^2];
                            c=A\b;
                            coeff = [c(1), c(3), c(6);
                                     c(2), c(4), c(8);
                                     c(5), c(7), 0];
                    end
                    polyCoefficients = coeff;
                end
          end
    end
end


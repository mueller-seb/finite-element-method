classdef solution < handle
    %SOLUTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ansatzFunctionSpace = ansatzFunctionSpace.empty(0, 1);
        u_h
    end
    
    methods
        function obj = solution(ansatzFunctionSpace, u_h)
            obj.ansatzFunctionSpace = ansatzFunctionSpace;
            obj.u_h = u_h;
        end
        
        function u = evaluate(obj, x, y)
            u = 0;
            i = 1;
            for phi_i = obj.ansatzFunctionSpace.basisFunctions(1:end)
                u = u + obj.u_h(i)*phi_i.evaluate(x, y);
                i = i + 1;
            end           
        end
        
        %Generates 3-dim array of x, y and u(x, y)
        function U3D = discreteSolution(obj, n) %n number of subintervals
            U = zeros(n+1);
            for i = 0:n
                for j = 0:n
                    U(i+1, j+1) = obj.evaluate(i*(1.0/n), j*(1.0/n));
                end
            end
            x = linspace(0, 1, n+1);
            y = linspace(0, 1, n+1);
            [X, Y] = meshgrid(x, y);
            U3D = cat(3, X, Y, U);
        end
        
        function solutionShapeFun = shapeFunction(obj, domain) %returns assembled shape function of the solution on a single domain (for efficiency in a posteriori est.)
            solutionShapeFun = shapeFunction(domain, polynomial(0));
            i=1;
            for basisFun = obj.ansatzFunctionSpace.basisFunctions(1:end)
                for shapeFun = basisFun.shapeFunctions(1:end)
                    if (shapeFun.domain == domain)
                        solutionShapeFun = solutionShapeFun + shapeFun.scale(obj.u_h(i));
                    end
                end
                i = i+1;
            end
        end
        
    end    
end


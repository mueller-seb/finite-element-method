classdef basisFunction < handle
    %BASISFUNCTION Creates basis function phi outgoing from a basis node 
    %   Assembles several shape functions (one for each adjacent domain) to
    %   one basis function
    
    properties
        basisNode
        shapeFunctions = shapeFunction.empty;
    end
    
    methods
        function obj = basisFunction(basisNode, shapeFunctions)

            obj.basisNode = basisNode;
            
            if (nargin == 2)
                obj.shapeFunctions = shapeFunctions;
            elseif (nargin == 1)
                adjDomains = basisNode.adjDomains;
                for domain = adjDomains(1:end)

                    nodes = domain.nodes;
                    fixPointValues = zeros(1, size(nodes, 2));
                    fixPointValues(find(nodes == basisNode)) = 1;
                    shapeFunPoly = polynomial(shapeFunction.calcCoefficients(nodes, fixPointValues));
                    obj.shapeFunctions(end+1) = shapeFunction(domain, shapeFunPoly);
                end
            end
        end
        
        function value = evaluate(obj, x, y)
            %value = 0;
            %for i = obj.shapeFunctions(1:end)
            %    value = value+i.evaluate(x,y);
            %end
            for i = obj.shapeFunctions(1:end)
                if (i.evaluate(x, y) ~= 0)
                    value = i.evaluate(x, y);
                    break;
                else
                    value = 0;
                end
            end
        end
        
        function sum = plus(obj1, obj2)
            sumShapeFuns = obj1.shapeFunctions;
            for shapeFun = obj2.shapeFunctions(1:end)
                i = find(sumShapeFuns == shapeFun);
                    if (~isempty(i)) 
                        sumShapeFuns(i) = sumShapeFuns(i) + shapeFun;
                    else
                        sumShapeFuns(end+1) = shapeFun;
                    end
            end
            sum = basisFunction(obj1.basisNode, sumShapeFuns);
        end
        
        function derivation = deriveX(obj)
            derivedShapeFuns = shapeFunction.empty(0, size(obj.shapeFunctions, 2));
            for i = 1:size(obj.shapeFunctions, 2)
                derivedShapeFuns(i) = obj.shapeFunctions(i).deriveX;
            end
            derivation = basisFunction(obj.basisNode, derivedShapeFuns);
        end
        
        function derivation = deriveY(obj)
            derivedShapeFuns = shapeFunction.empty(0, size(obj.shapeFunctions, 2));
            for i = 1:size(obj.shapeFunctions, 2)
                derivedShapeFuns(i) = obj.shapeFunctions(i).deriveY;
            end
            derivation = basisFunction(obj.basisNode, derivedShapeFuns);
        end
        
        function gradBasisFun = gradient(obj)
            N = size(obj.shapeFunctions, 2);
            gradShapeFuns = shapeFunctionVector.empty(0, N);
            for i = 1:N
                gradShapeFuns(i) = obj.shapeFunctions(i).gradient;
            end
            gradBasisFun = basisFunctionVector(obj.basisNode, gradShapeFuns);
        end
        
        function divgrad = laplace(obj)
            divgrad = obj.gradient.divergence; 
        end
    end
    
end


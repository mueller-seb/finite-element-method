classdef basisFunction < handle
    %BASISFUNCTION Creates basis function phi outgoing from a basis node.
    %   Basis function is 1 on basis node and 0 on adjacent mesh nodes.
    %   If higher polynomials are used, midpoints are defined on each edge
    %   of the domain.
    %   Constructor assembles shape functions (one for each adjacent domain of the basis node) to
    %   one basis function.
    
    properties
        basisNode = node.empty(0, 1);
        shapeFunctions = shapeFunction.empty;
    end
    
    methods
        function obj = basisFunction(basisNode, higherPolynomials, shapeFunctions)

            obj.basisNode = basisNode;
                        
            if (nargin == 3)
                obj.shapeFunctions = shapeFunctions;
            
            elseif (nargin == 2)
                adjDomains = basisNode.adjDomains;
                for domain = adjDomains(1:end)
                    if (~higherPolynomials)
                        nodes = domain.nodes;
                        fixPointValues = zeros(1, size(nodes, 2));
                        fixPointValues(find(nodes == basisNode)) = 1;
                        shapeFunPoly = polynomial(shapeFunction.calcCoefficients(nodes, fixPointValues));
                        obj.shapeFunctions(end+1) = shapeFunction(domain, shapeFunPoly);
                    else
                        N = 2*size(domain.nodes, 2);
                        nodes = node.empty(0, N);
                        fixPointValues = zeros(1, N);
                        for j=1:2:N
                            nodes(j) = domain.nodes(ceil(j/2));
                        end
                        for j=2:2:N-1
                           nodes(j) = midpoint(nodes(j-1), nodes(j+1));
                        end
                        nodes(N) = midpoint(nodes(N-1), nodes(1));
                        
                        j = find(nodes==basisNode);
                        if (j~=N)
                            k = j+1;
                        else
                            k = 1;
                        end
                        if (j~=1)
                            i = j-1;
                        else
                            i = N;
                        end 
                        fixPointValues(j) = 1;
                        fixPointValues(i) = 0.5;
                        fixPointValues(k) = 0.5;
                        shapeFunPoly = polynomial(shapeFunction.calcCoefficients(nodes, fixPointValues));
                        obj.shapeFunctions(end+1) = shapeFunction(domain, shapeFunPoly); 
                    end
                end
            end
        end
        
        function value = evaluate(obj, x, y)
            for shapeFun = obj.shapeFunctions(1:end)
                if (shapeFun.evaluate(x, y) ~= 0)
                    value = shapeFun.evaluate(x, y);
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
            N = size(obj.shapeFunctions, 2);
            derivedShapeFuns = shapeFunction.empty(0, N);
            for i = 1:N
                derivedShapeFuns(i) = obj.shapeFunctions(i).deriveX;
            end
            derivation = basisFunction(obj.basisNode, derivedShapeFuns);
        end
        
        function derivation = deriveY(obj)
            N = size(obj.shapeFunctions, 2);
            derivedShapeFuns = shapeFunction.empty(0, N);
            for i = 1:N
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


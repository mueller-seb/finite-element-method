classdef basisFunction
    %BASISFUNCTION Creates basis function phi outgoing from a basis node 
    %   Assembles several shape functions (one for each adjacent domain) to
    %   one basis function
    
    properties
        basisNode
        shapeFunctions = shapeFunction.empty;
    end
    
    methods
        function obj = basisFunction(basisNode)

            obj.basisNode = basisNode;

            adjDomains = basisNode.adjDomains;
            for domain = adjDomains(1:end)

                nodes = domain.nodes;
                fixPointValues = zeros(1, size(nodes, 2));
                fixPointValues(find(nodes == basisNode)) = 1;
                shapeFunPoly = polynomial(shapeFunction.calcCoefficients(nodes, fixPointValues));
                obj.shapeFunctions(end+1) = shapeFunction(domain, shapeFunPoly);
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
    end
    
end


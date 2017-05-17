classdef basisFunction
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %meshdata
        basisNode
        shapeFunctions = shapeFunction.empty;
    end
    
    methods
        function obj = basisFunction(basisNode)
            %obj.meshdata = meshdata;
            obj.basisNode = basisNode;
            %obj.shapeFunctions = shapeFunction.empty;
            adjDomains = basisNode.adjDomains;
            for domain = adjDomains(1:end)
                %nodes = meshdata.domains(i).nodeIDs;
                nodes = domain.nodes;
                fixPointValues = zeros(1, size(nodes, 2));
                fixPointValues(find(nodes == basisNode)) = 1;
                obj.shapeFunctions(end+1) = shapeFunction(domain, nodes, fixPointValues);
            end
        end
        function value = evaluate(obj, x, y)
            for i = obj.shapeFunctions(1:end)
                value = value+i.evaluate(x,y);
            end
        end            
    end
    
end


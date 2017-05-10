classdef basisFunction
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        meshdata
        basisNodeID
        shapeFunctions
    end
    
    methods
        function obj = basisFunction(meshdata, basisNodeID)
            obj.meshdata = meshdata;
            obj.basisNodeID = basisNodeID;
            obj.shapeFunctions = shapeFunction.empty;
            adjDomainIDs = meshdata.nodes(basisNodeID).adjDomainIDs;
            for i=adjDomainIDs(1:end)
                nodeIDs = meshdata.domains(i).nodeIDs;
                fixPointValues = zeros(1, size(nodeIDs, 2));
                fixPointValues(find(nodeIDs==basisNodeID)) = 1;
                obj.shapeFunctions(end+1) = shapeFunction(meshdata, i, nodeIDs, fixPointValues);
            end
        end
        function val = evaluate(obj, x, y)
            for i=obj.shapeFunctions(1:end)
                val = val+i.evaluate(x,y);
            end
        end            
    end
    
end


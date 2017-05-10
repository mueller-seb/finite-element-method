classdef basisFunction
    %BASISFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mesh
        basisNodeID
        shapeFunctions
    end
    
    methods
        function obj = basisFunction(mesh, basisNodeID)
            obj.mesh = mesh;
            obj.basisNodeID = basisNodeID;
            adjDomainIDs = mesh.nodes(basisNodeID).adjDomainIDs;
            for i=adjDomainIDs(1:end)
                nodeIDs = mesh.domains(i).nodeIDs;
                fixPointValues = zeros(size(nodeIDs,1));
                fixPointValues(find(nodeIDs==basisNodeID)) = 1;
                obj.shapeFunctions(end+1) = shapeFunction(mesh, i, nodeIDs, fixPointValues);
            end
        end
        function value = evaluate(obj, x, y)
            
        end            
    end
    
end


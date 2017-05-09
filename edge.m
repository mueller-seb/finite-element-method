classdef edge
    %EDGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodeIDs
        ID
    end
    
    methods
        function obj = edge(nodeIDs, ID)
            obj.nodeIDs = nodeIDs;
            obj.ID = ID;
        end
    end
    
end


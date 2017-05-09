classdef triangle
    %TRIANGLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodeIDs = int16.empty(0,3)
        ID
    end
    
    methods
        function obj = triangle(nodeIDs, ID)
            if nargin > 0
                obj.nodeIDs = nodeIDs;
                obj.ID = ID;
            end
        end
    end
    
end


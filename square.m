classdef square < handle
    %SQUARE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodes = node.empty(0, 4)
        ID
    end
    
    methods
        function obj = triangle(nodes, ID)
            if nargin > 0 %necessary for assigning the n-th array element while 1st to (n-1)-th elements aren't assigned yet
                obj.nodes = nodes;
                obj.ID = ID;
            end
        end
        function isInside = contains(obj, x, y)
            
                isInside = true;
            else
                isInside = false;
            end            
        end
    end
    
end


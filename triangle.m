classdef triangle
    %TRIANGLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodeIDs = int16.empty(0,3)
        ID
    end
    
    methods
        function obj = triangle(nodeIDs, ID)
            if nargin > 0 %necessary for assigning the n-th array element while 1st to (n-1)-th elements aren't assigned yet
                obj.nodeIDs = nodeIDs;
                obj.ID = ID;
            end
        end
        function isInside = contains(x, y)
            %algorithm taken from http://mathworld.wolfram.com/TriangleInterior.html
            %v0 = [node
            
            
        end
    end
    
end


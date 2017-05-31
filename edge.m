classdef edge < handle
    %EDGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodes
        n
        ID
    end
    
    methods
        function obj = edge(nodes, ID)
            obj.nodes = nodes;
            obj.ID = ID;
            obj.n = obj.normVec;
        end
        
%p1=(x1, y1); p2=(x2, y2)
%C = [x1, x2; y1, y2]
%g = p2-p1 = [x2; y2] - [x1; y1] = [x2-x1; y2-y1] = [g1; g2]
%n = [g2, -g1]

        function n = normVec(obj)
            C = [[obj.nodes.x]; [obj.nodes.y]];
            g = C(:,2)-C(:,1);
            n = [g(2,1); -g(1,1)];
            n = n/norm(n, 2);
        end
    end
    
end


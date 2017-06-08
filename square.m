classdef square < handle
    %SQUARE Domain of type square
    %   Detailed explanation goes here
    
    properties
        nodes = node.empty(0, 4)
        edges = edge.empty(0, 4)
        ID
    end
    
    methods
        function obj = square(nodes, ID)
            if nargin > 0 %necessary for assigning the n-th array element while 1st to (n-1)-th elements aren't assigned yet
                obj.nodes = nodes;
                obj.ID = ID;
            end
        end
        
        function isInside = contains(obj, x, y)
            X = [obj.nodes.x];
            Y = [obj.nodes.y];
            if (min(X) <= x) && (x <= max(X)) && (min(Y) <= y) && (y <= max(Y))
                isInside = true;
            else
                isInside = false;
            end            
        end
        
        function diam = diameter(obj)
            diam = sqrt(obj.edges(1).length^2+obj.edges(2).length^2);
        end
        
        function edges = createEdges(obj, edgeIndex)
            obj.edges(1) = edge(obj.nodes(1:2), edgeIndex);
            obj.edges(2) = edge(obj.nodes(2:3), edgeIndex+1);
            obj.edges(3) = edge(obj.nodes(3:4), edgeIndex+2);
            obj.edges(4) = edge([obj.nodes(4), obj.nodes(1)], edgeIndex+3);
            edges = obj.edges;
        end
    end
    
end


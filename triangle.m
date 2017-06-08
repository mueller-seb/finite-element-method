classdef triangle < handle
    %TRIANGLE Domain of type triangle
    %   Detailed explanation goes here
    
    properties
        nodes = node.empty(0, 3)
        edges = edge.empty(0, 3)
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
            %calculating barycentric coordinates by solving equation system
            %v = v1 + (v2-v1)*c1 + (v3-v1)*c2 with v=[x; y] and vertices vi
            %for coefficients c1 and c2
            v = [x; y];
            vertices = [[obj.nodes.x]; [obj.nodes.y]];
            v1 = vertices(1:2,1);
            v2 = vertices(1:2,2);
            v3 = vertices(1:2,3);
            
            c = [v2-v1, v3-v1]\(v-v1);
            
            if (c(1)>=0 && c(2)>=0 && (c(1)+c(2)<=1))
                isInside = true;
            else
                isInside = false;
            end            
        end
        
        function diam = diameter(obj)
        %formula from http://www.mathopenref.com/trianglecircumcircle.html
            a = obj.edges(1).length;
            b = obj.edges(2).length;
            c = obj.edges(3).length;
            diam = (a*b*c)/sqrt((a+b+c)*(b+c-a)*(c+a-b)*(a+b-c));
        end
        
        function edges = createEdges(obj, edgeIndex)
            obj.edges(1) = edge(obj.nodes(1:2), edgeIndex);
            obj.edges(2) = edge(obj.nodes(2:3), edgeIndex+1);
            obj.edges(3) = edge([obj.nodes(3), obj.nodes(1)], edgeIndex+3);
            edges = obj.edges;
        end
    end
    
end


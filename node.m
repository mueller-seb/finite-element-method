classdef node < handle
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        isBoundaryPoint
        adjDomains
        ID
    end
    
    methods
        function obj = node(x, y, isBoundaryPoint, adjDomains, ID)
            if (nargin>0)
                obj.x = x;
                obj.y = y;
                obj.isBoundaryPoint = isBoundaryPoint;

                if (nargin==5)
                    obj.adjDomains = adjDomains;
                    obj.ID = ID;
                end
            end
        end
        
        function sum = plus(obj1, obj2)
            sum = node(obj1.x+obj2.x, obj1.y+obj2.y, (obj1.isBoundaryPoint && obj2.isBoundaryPoint));
        end
        
        function scaled = scale(obj, factor)
            scaled = node(factor*obj.x, factor*obj.y, ((obj.x == 0) || (obj.y == 0)));
        end

        function mp = midpoint(obj1, obj2)
            mp = scale(obj1+obj2, 0.5);
        end
    end
    
end


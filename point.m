classdef point < handle
    %POINT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
    end
    
    methods
        function obj = point(x, y)
          if (nargin > 0)
            obj.x = x;
            obj.y = y;
          end
        end
        
        function sum = plus(obj1, obj2)
            sum = point(obj1.x+obj2.x, obj1.y+obj2.y);
        end
        
        function scaled = scale(obj, factor)
            scaled = point(factor*obj.x, factor*obj.y);
        end

        function mp = midpoint(obj1, obj2)
            mp = scale(obj1+obj2, 0.5);
        end
        
    end
    
end


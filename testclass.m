classdef testclass < handle
    %TESTCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        n
    end
    
    methods
        function obj = testclass(x,y)
            obj.x = x;
            %obj.y = y;
            obj.n = nargin;
        end
        function ret = value(obj)
            ret = obj.x;
        end
        
        function ret = abc(a)
            ret = a;
        end
    end
    
end


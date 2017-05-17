classdef testclass < handle
    %TESTCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x = int16.empty;
    end
    
    methods
        function obj = testclass(v)
            obj.x=v;
        end
        function ret = value()
            ret = obj.x;
        end
    end
    
end


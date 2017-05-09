classdef testclass
    %TESTCLASS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
    end
    
    methods
        function obj = testclass()
            x=10;
        end
        function ret = eval(obj, a)
            ret = a;
        end
    end
    
end


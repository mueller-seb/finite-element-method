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
            obj.x = x;
            obj.y = y;
            obj.isBoundaryPoint = isBoundaryPoint;
            obj.adjDomains = adjDomains;
            obj.ID = ID;
        end
    end
    
end


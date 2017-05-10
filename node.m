classdef node
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties %(Access = public)
        x
        y
        isBoundaryPoint
        adjDomainIDs = int16.empty(0, 6)
        ID
    end
    
    methods
        function obj = node(x, y, isBoundaryPoint, adjDomainIDs, ID)
            obj.x = x;
            obj.y = y;
            obj.isBoundaryPoint = isBoundaryPoint;
            obj.adjDomainIDs = adjDomainIDs;
            obj.ID = ID;
        end
    end
    
end


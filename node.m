classdef node < point
    %NODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        isBoundaryPoint
        adjDomains
        ID
    end
    
    methods
        function obj = node(x, y, isBoundaryPoint, adjDomains, ID)
            obj@point(x,y);
            obj.isBoundaryPoint = isBoundaryPoint;
            obj.adjDomains = adjDomains;
            obj.ID = ID;
        end
        
        function pt = point(obj) %converts point to super class node (necessary for higherPolynomials==1 in basisFunction)
            pt = point(obj.x, obj.y);
        end
    end
    
end


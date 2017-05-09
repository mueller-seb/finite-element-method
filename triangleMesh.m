classdef triangleMesh < handle
    %TRIANGELMESH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodes
        domains
        edges
    end
    
    methods
        function obj = triangelsMesh(n) %n: number of subintervals
            h = 1.0/n;
            obj.nodes = node.empty(0,(n+1)^2);
            nodeID=1;
            for j=0:n
                for i=0:n
                    x=i*h;
                    y=j*h;
                    if (mod(i,n) == 0) || (mod(j,n) == 0)
                        isBoundaryPoint = true;
                    else
                        isBoundaryPoint = false;
                    end
                    obj.nodes(end+1) = node(x, y, isBoundaryPoint, int16.empty(), nodeID);
                    nodeID = nodeID+1;
                end

            end
            
            obj.domains = triangle.empty(0,2*n*n);
            obj.edges = edge.empty(0,3*n^2+2*n);
            domainID = 1;
            for j = 1:n %going through nodes, creating |\ domains (two vertices bottom, one vertice top, hypotenuse right)
                for i=1:n
                    nodeID = (j-1)*(n+1)+i;
                    vertexIDs = int16.empty(3,0);
                    vertexIDs(1) = nodeID;
                    vertexIDs(2) = (j-1)*(n+1)+i+1;
                    vertexIDs(3) = j*(n+1)+i;
                    obj.domains(domainID) = triangle(vertexIDs, domainID);

                   for nodeID=vertexIDs(1:3)
                       obj.nodes(nodeID).adjDomainIDs(end+1) = domainID;
                   end
                   domainID = domainID+2;
               end
            end
            domainID = 2;
            for j=1:n %going through nodes, creating \| domains (one vertex on bottom, two vertices on top, hypotenuse left)
                for i=2:n+1
                    nodeID=(j-1)*(n+1)+i;
                    vertexIDs = int16.empty(3,0);
                    vertexIDs(1) = nodeID;
                    vertexIDs(2) = j*(n+1)+i;
                    vertexIDs(3) = j*(n+1)+i-1;
                    obj.domains(domainID) = triangle(vertexIDs, domainID);

                   for nodeID=vertexIDs(1:3)
                       obj.nodes(nodeID).adjDomainIDs(end+1) = domainID;
                   end 
                   domainID = domainID+2;
                end            
            end
        end
    end
    
end


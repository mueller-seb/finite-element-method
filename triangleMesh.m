classdef triangleMesh < handle
    %TRIANGELMESH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        nodes
        domains
        edges
    end
    
    methods
        function obj = triangleMesh(n) %n: number of subintervals
            nodeDist = 1.0/n;
            obj.nodes = node.empty(0, (n+1)^2);
            nodeIndex = 1;
            for j=0:n
                for i=0:n
                    x=i*nodeDist;
                    y=j*nodeDist;
                    if (mod(i,n) == 0) || (mod(j,n) == 0)
                        isBoundaryPoint = true;
                    else
                        isBoundaryPoint = false;
                    end
                    obj.nodes(end+1) = node(x, y, isBoundaryPoint, triangle.empty, nodeIndex); %end+1 should be the same as nodeIndex
                    nodeIndex = nodeIndex+1;
                end
            end
            
%NODE AND DOMAIN ENUMERATION
%   7    8     9
%   ___________
%   |\   |\   |
%   |5\ 6|7\ 8|
%   |  \ |  \ |
%   |___\|___\|
%  4|\  5|\   |6
%   | \  | \  |
%   |1 \2|3 \4|
%   |___\|___\|
%   1    2    3
%
            
            obj.domains = triangle.empty(0, 2*n*n);
            obj.edges = edge.empty(0, 3*n^2+2*n);
            domainIndex = 1;
            for j = 1:n %going through nodes, creating |\ domains (two vertices bottom, one vertice top, hypotenuse right)
                for i=1:n
                    nodeIndex = (j-1)*(n+1)+i;
                    vertices = node.empty(0, 3);
                    vertices(1) = obj.nodes(nodeIndex);
                    vertices(2) = obj.nodes((j-1)*(n+1)+i+1);
                    vertices(3) = obj.nodes(j*(n+1)+i);
                    obj.domains(domainIndex) = triangle(vertices, domainIndex);

                   for vertex=vertices(1:3)
                       vertex.adjDomains(end+1) = obj.domains(domainIndex);
                   end
                   domainIndex = domainIndex+2;
               end
            end
            domainIndex = 2;
            for j=1:n %going through nodes, creating \| domains (one vertex on bottom, two vertices on top, hypotenuse left)
                for i=2:n+1
                    nodeIndex = (j-1)*(n+1)+i;
                    vertices = node.empty(0, 3);
                    vertices(1) = obj.nodes(nodeIndex);
                    vertices(2) = obj.nodes(j*(n+1)+i);
                    vertices(3) = obj.nodes(j*(n+1)+i-1);
                    obj.domains(domainIndex) = triangle(vertices, domainIndex);

                   for vertex=vertices(1:3)
                       vertex.adjDomains(end+1) = obj.domains(domainIndex);
                   end 
                   domainIndex = domainIndex+2;
                end            
            end
        end
    end
    
end


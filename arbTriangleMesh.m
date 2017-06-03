classdef arbTriangleMesh
    %ARBTRIANGLEMESH Generates mesh of arbitrary triangle elements
    %   Detailed explanation goes here
    
    properties
        nodes
        domains
        edges = edge.empty;
        elementType = 3
    end
    
    methods
        function obj = arbTriangleMesh(meshdata)
            M = size(meshdata.Nodes, 2);
            obj.nodes = node.empty(0, M);
            for nodeIndex = 1:M
                XY = meshdata.Nodes(1:2, nodeIndex);
                if (ismember(XY(1), [0 , 1]) || ismember(XY(2), [0, 1]))
                    isBoundaryPoint = true;
                else
                    isBoundaryPoint = false;
                end
                obj.nodes(end+1) = node(XY(1), XY(2), isBoundaryPoint, triangle.empty, nodeIndex);
            end
            
            N = size(meshdata.Elements, 2);
            obj.domains = triangle.empty(0, N);
            for domainIndex = 1:N
                vertexIndices = meshdata.Elements(1:3, domainIndex)';
                vertices = obj.nodes(vertexIndices);
                obj.domains(domainIndex) = triangle(vertices, domainIndex);
                for vertex = vertices(1:3)
                    vertex.adjDomains(end+1) = obj.domains(domainIndex);
                end
            end            
        end
        
        function createEdges(obj)
            edgeIndex = 1;
            for domain = obj.domains(1:end)
                obj.edges(edgeIndex:edgeIndex+2) = domain.createEdges(edgeIndex);
                edgeIndex = edgeIndex+3;
            end
       end
    end
    
end
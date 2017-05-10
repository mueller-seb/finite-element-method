classdef ansatzFunctionSpace
    %ANSATZFUNCTIONSPACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mesh
        basisFunctions
    end
    
    methods
        function obj = ansatzFunctionSpace(mesh)
            obj.mesh = mesh;
            domains = mesh.domains;
            for i=domains(1:end)
                nodes = i.nodeIds
                
                
        end
    end
    
end


classdef ansFunSpaceVec < handle
    %ANSFUNSPACEVEC Basis of vectorial ansatz functions
    %   Used for gradients of basis functions of ansatz function space
    
    properties
        Mesh
        basisFunctionVectors = basisFunctionVector.empty
    end
    
    methods
        function obj = ansFunSpaceVec(Mesh, basisFunVecs)
            obj.Mesh = Mesh;
            obj.basisFunctionVectors = basisFunVecs;
        end
        
        function divAnsFunSpace = divergence(obj)
            N = size(obj.basisFunctionVectors, 2);
            divBasisFuns = basisFunction.empty(0, N);
            for i=1:N
                divBasisFuns(i) = obj.basisFunctionVectors(i).divergence;
            end
            divAnsFunSpace = ansatzFunctionSpace(obj.Mesh, 0, 0, divBasisFuns);            
        end
    end
    
end


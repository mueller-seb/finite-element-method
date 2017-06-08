classdef vectorFunctionSpace < handle
    %VECTORFUNCTIONSPACE Space of vector fields
    %   Used for gradients of basis functions of ansatz function space
    
    properties
        vectorFunctions = vectorFunction.empty
    end
    
    methods
        function obj = vectorFunctionSpace(vectorFunctions)
                obj.vectorFunctions = vectorFunctions;
        end
        
        function divVecFunSpace = divergence(obj)
            N = size(obj.vectorFunctions, 2);
            divScalarFuns = scalarFunction.empty(0, N);
            for i=1:N
                divScalarFuns(i) = obj.vectorFunctions(i).divergence;
            end
            divVecFunSpace = scalarFunctionSpace(divScalarFuns);            
        end
    end
    
end


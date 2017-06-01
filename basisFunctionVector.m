classdef basisFunctionVector
    %BASISFUNCTIONVECTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        basisNode
        shapeFunctionVectors
    end
    
    methods
        function obj = basisFunctionVector(basisNode, shapeFunctionVectors)
            obj.basisNode = basisNode;
            obj.shapeFunctionVectors = shapeFunctionVectors;
        end
        
        function value = evaluate(obj, x, y)
            for shapeFunVec = obj.shapeFunctionVectors(1:end)
                if (shapeFunVec.evaluate(x, y) ~= zeros(2,1))
                    value = shapeFunVec.evaluate(x, y);
                    break;
                else
                    value = [0; 0];
                end
            end
        end
        
        function div = divergence(obj)
            N = size(obj.shapeFunctionVectors, 2);
            divShapeFunVec = basisFunction.empty(0, N);
            for i = 1:N
                divShapeFunVec(i) = obj.shapeFunctionVectors(i).shapeFunX.deriveX + obj.shapeFunctionVectors(i).shapeFunY.deriveY;
            end
            div = basisFunction(obj.basisNode, divShapeFunVec);
        end
    end
    
end


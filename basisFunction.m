classdef basisFunction < scalarFunction
    %BASISFUNCTION Creates basis function phi outgoing from a basis node.
    %   Basis function is 1 on basis node and 0 on adjacent mesh nodes.
    %   If higher polynomials are used, midpoints are defined on each edge
    %   of the domain.
    %   Constructor assembles shape functions (one for each adjacent domain of the basis node) to
    %   one basis function.
    
    properties
        basisNode = node.empty(0, 1);      
    end
    
    methods
        function obj = basisFunction(basisNode, higherPolynomials, bvp)
            obj@scalarFunction;
            obj.basisNode = basisNode;

            adjDomains = basisNode.adjDomains;
            for domain = adjDomains(1:end)
                    if ~higherPolynomials
                        fixPoints = domain.nodes;
                        fixPointValues = zeros(1, size(fixPoints, 2));
                        fixPointValues(find(fixPoints == basisNode)) = 1;
                        shapeFunPoly = polynomial(shapeScalarFunction.calcCoefficients(fixPoints, fixPointValues));
                        obj.shapeScalarFunctions(end+1) = shapeScalarFunction(domain, shapeFunPoly);
                    elseif higherPolynomials
                        N = 2*size(domain.nodes, 2);
                        fixPoints = point.empty(0, N);
                        fixPointValues = zeros(1, N);
                        for i=1:N/2
                            fixPoints(2*i-1) = domain.nodes(i);
                        end
                        for i=2:2:N-1
                           fixPoints(i) = midpoint(fixPoints(i-1), fixPoints(i+1));
                        end
                        fixPoints(N) = midpoint(fixPoints(N-1), fixPoints(1));
                        
                        j = 2*find(domain.nodes == basisNode)-1;
                        if (j~=N)
                            k = j+1;
                        else
                            k = 1;
                        end
                        if (j~=1)
                            i = j-1;
                        else
                            i = N;
                        end
                        %fun = u(bvp);
                        fixPointValues(j) = 1; %fun(fixPoints(j).x, fixPoints(j).y);
                        fixPointValues(i) = 0.5; %fun(fixPoints(i).x, fixPoints(i).y);
                        fixPointValues(k) = 0.5; %fun(fixPoints(k).x, fixPoints(k).y);
                        shapeFunPoly = polynomial(shapeScalarFunction.calcCoefficients(fixPoints, fixPointValues));
                        obj.shapeScalarFunctions(end+1) = shapeScalarFunction(domain, shapeFunPoly); 
                    end
            end
        end
    end
end

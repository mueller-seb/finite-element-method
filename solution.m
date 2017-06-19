classdef solution < handle
    %SOLUTION Class describes approximated solution u
    %   Consists of coefficients vector u_h and an array of summed up and weighted shape
    %   functions describing the approx. solution on the corresponding domain of the mesh.
    
    properties
        ansatzFunctionSpace = ansatzFunctionSpace.empty(0, 1);
        u_h %vector of coefficients
        shapeScalarFunctions = shapeScalarFunction.empty %assembled shape functions for each domain of the mesh (for efficiency purposes)
    end
    
    methods
        function obj = solution(ansatzFunctionSpace, u_h)
            obj.ansatzFunctionSpace = ansatzFunctionSpace;
            obj.u_h = u_h;
            obj.shapeScalarFunctions = shapeScalarFunction.empty(0, size(obj.ansatzFunctionSpace.Mesh.domains, 2));
            for domain = obj.ansatzFunctionSpace.Mesh.domains(1:end)
                obj.shapeScalarFunctions(end+1) = obj.shapeScalarFunction(domain);
            end                
        end
        
        %shapeScalarFunction returns assembled shape function of the solution on
        %a domain (used for efficiency reasons in evaluation,b a posteriori est. and Lp error)
        function solutionShapeScalarFun = shapeScalarFunction(obj, domain)
            solutionShapeScalarFun = shapeScalarFunction(domain, polynomial(0));
            i=1;
            for basisFun = obj.ansatzFunctionSpace.scalarFunctions(1:end)
                for shapeScalarFun = basisFun.shapeScalarFunctions(1:end)
                    if (shapeScalarFun.domain == domain)
                        solutionShapeScalarFun = solutionShapeScalarFun + shapeScalarFun.scale(obj.u_h(i));
                    end
                end
                i = i+1;
            end
        end
        
        %Evaluates value of the approx. solution on a point x,y
        function u = evaluate(obj, x, y)
            elementType = obj.ansatzFunctionSpace.Mesh.elementType;
            if (ismember(elementType, [1, 2])) %rectangular triangles or squares
                Omega = obj.ansatzFunctionSpace.Mesh.Omega;
                meshSubIntervals = obj.ansatzFunctionSpace.Mesh.subIntervals;
                nodeDist = (Omega(:,2)-Omega(:,1)) ./ meshSubIntervals';
                intervalXY = ceil([x; y] ./ nodeDist); %choose the domain related to (x,y)
                for i=find(intervalXY==0) %case x=0 or y=0
                    intervalXY(i) = intervalXY(i)+1;
                end
                domainIndex = (intervalXY(2)-1)*meshSubIntervals(1) + intervalXY(1);
                if (elementType == 2)
                    u = obj.shapeScalarFunctions(domainIndex).evaluate(x, y);
                elseif (elementType == 1)
                    domainIndex = 2*domainIndex; %two triangles form a square
                    u = obj.shapeScalarFunctions(domainIndex).evaluate(x,y);
                    if (u == 0) %(x,y) not in the right hand triangle
                        u = obj.shapeScalarFunctions(domainIndex-1).evaluate(x,y);
                    end
                end
            else
                u = 0;
                i = 1;
                for phi_i = obj.ansatzFunctionSpace.scalarFunctions(1:end)
                    u = u + obj.u_h(i)*phi_i.evaluate(x, y);
                    i = i + 1;
                end
            end
        end
          
        %Generates 3-dim array of x, y and u(x, y)
        function XYU = discreteSolution(obj, subIntervals)
            
            evalPointsOnMeshPoints = 0;
            if ismember(obj.ansatzFunctionSpace.Mesh.elementType, [1, 2])
                if subIntervals == obj.ansatzFunctionSpace.Mesh.subIntervals
                    evalPointsOnMeshPoints = 1;
                end
            end
            
            if (evalPointsOnMeshPoints == 1)
                XYU = obj.solutionOnMeshPoints;
            elseif (evalPointsOnMeshPoints == 0)
                Omega = obj.ansatzFunctionSpace.Mesh.Omega;
                interval = (Omega(:,2)-Omega(:,1)) ./ subIntervals';
                U = zeros(subIntervals(2)+1, subIntervals(1)+1);
                for j = 0:subIntervals(2)
                    for i = 0:subIntervals(1)
                        U(j+1, i+1) = obj.evaluate(i*interval(1), j*interval(2));
                    end
                end
                x = linspace(Omega(1,1), Omega(1,2), subIntervals(1)+1);
                y = linspace(Omega(2,1), Omega(2,2), subIntervals(2)+1);
                [X, Y] = meshgrid(x, y);
                XYU = cat(3, X, Y, U);
            end
        end
        
        %Generates 3-dim array of discrete solution in the case that
        %evaluation points are the same as mesh points (only for
        %rectangulars and rectangular triangles). Much faster.
        function XYU = solutionOnMeshPoints(obj)
            Omega = obj.ansatzFunctionSpace.Mesh.Omega;
            subIntervals = obj.ansatzFunctionSpace.Mesh.subIntervals;
            x = linspace(Omega(1,1), Omega(1,2), subIntervals(1)+1);
            y = linspace(Omega(2,1), Omega(2,2), subIntervals(2)+1);
            [X, Y] = meshgrid(x, y);
            if (obj.ansatzFunctionSpace.bvp == 1)
                U = zeros(subIntervals(2)+1, subIntervals(1)+1);
                U(2:end-1, 2:end-1) = reshape(obj.u_h, subIntervals(1)-1, subIntervals(2)-1)';
            elseif (obj.ansatzFunctionSpace.bvp == 2)
                U = reshape(obj.u_h, subIntervals(1)+1, subIntervals(2)+1)';
            end
            XYU = cat(3, X, Y, U);
        end
          
        %Calculates error ||u-u_h||_Lp,Omega
        function errLp = errorLp(obj, p, gaussOrder)
            integral = 0;
            for shapeScalarFun = obj.shapeScalarFunctions(1:end)
                U = u(obj.ansatzFunctionSpace.bvp);
                difference = @(x,y) abs(U(x, y) - shapeScalarFun.evaluate(x, y))^p; %|u - u_h|^p
                integral = integral + gaussQuad(difference, shapeScalarFun.domain.nodes, gaussOrder);                
            end
            errLp = integral^(1/p);
        end      
        
    end    
end


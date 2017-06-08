function [ eta ] = etaAPost(u, gaussOrder )
%ETAAPOST A posteriori error estimation, formula for eta in Num. treatment of
%PDEs, Grossmann & Roos, p. 290.
%   Uses the shapeFunctions property of solution for better efficiency

F = f(u.ansatzFunctionSpace.bvp);
u.ansatzFunctionSpace.Mesh.createEdges;

     %eta^2 on domain K=solutionShapeFun.domain
     function valueK = etaKsqr(solutionShapeScalarFun)
         U_K = solutionShapeScalarFun;
         h_K = U_K.domain.diameter;         
         gradU_K = U_K.gradient;
         laplaceU_K = U_K.laplace;
         r_K = @(x, y) F(x,y) + laplaceU_K.evaluate(x,y);
         
         edgeTerm = 0;
         for E = U_K.domain.edges(1:end)
             n_E = E.normVec;
             r_E = @(x, y) dot(n_E, gradU_K.evaluate(x,y));
             h_E = E.length;
             edgeTerm = edgeTerm + h_E * gaussQuad(r_E, E.nodes, gaussOrder(2))^2;
         end
         edgeTerm = edgeTerm/2;
         
         interiorTerm = h_K^2 * gaussQuad(r_K, U_K.domain.nodes, gaussOrder(1))^2;
         valueK = interiorTerm + edgeTerm;       
     end
 
     eta = 0;
     for shapeScalarFun = u.shapeScalarFunctions(1:end) %queue over all domains of the mesh
         eta = eta + etaKsqr(shapeScalarFun);
     end
     
     eta = sqrt(eta);
     
%This doesn't use the shapeFunctions property of solution. Calculates
%shapeScalarFun for each domain, so it's less CPU-efficient.
%     eta = 0;
%     for K = u.ansatzFunctionSpace.Mesh.domains(1:end)
%         eta = eta + etaKsqr(K);
%     end

%     function valueK = etaKsqr(domain)
%         h_K = domain.diameter;
%         U_K = u.shapeScalarFunction(domain);
%         gradU_K = U_K.gradient;
%         laplaceU_K = U_K.laplace;
%         r_K = @(x, y) F(x,y) + laplaceU_K.evaluate(x,y);
%         
%         edgeTerm = 0;
%         for E = domain.edges(1:end)
%             n_E = E.normVec;
%             r_E = @(x, y) dot(n_E, gradU_K.evaluate(x,y));
%             h_E = E.length;
%             edgeTerm = edgeTerm + h_E * gaussQuad(r_E, E.nodes, gaussQuadOrderEdge)^2;
%         end
%         edgeTerm = edgeTerm/2;
%         
%         interiorTerm = h_K^2 * gaussQuad(r_K, domain.nodes, gaussQuadOrderInt)^2;
%         valueK = interiorTerm + edgeTerm;       
%     end
% 
%     eta = 0;
%     for K = u.ansatzFunctionSpace.Mesh.domains(1:end)
%         eta = eta + etaKsqr(K);
%     end
end


function [ eta ] = etaAPost(u, bvp, gaussQuadOrderInt, gaussQuadOrderEdge )
%ETA Eta of a posteriori error estimation
%   Detailed explanation goes here

F = f(bvp);
u.ansatzFunctionSpace.Mesh.createEdges;

    function valueK = etaKsqr(domain)
        h_K = domain.diameter;
        U_K = u.shapeFunction(domain);
        gradU_K = U_K.gradient;
        laplaceU_K = U_K.laplace;
        r_K = @(x, y) F(x,y) + laplaceU_K.evaluate(x,y);
        
        edgeTerm = 0;
        for E = domain.edges(1:end)
            n_E = E.normVec;
            r_E = @(x, y) dot(n_E, gradU_K.evaluate(x,y));
            h_E = E.length;
            edgeTerm = edgeTerm + h_E * gaussQuad(r_E, E.nodes, gaussQuadOrderEdge)^2;
        end
        edgeTerm = edgeTerm/2;
        
        interiorTerm = h_K^2 * gaussQuad(r_K, domain.nodes, gaussQuadOrderInt)^2;
        valueK = interiorTerm + edgeTerm;       
    end

    eta = 0;
    for K = u.ansatzFunctionSpace.Mesh.domains(1:end)
        eta = eta + etaKsqr(K);
    end
    
    eta = sqrt(eta);
end


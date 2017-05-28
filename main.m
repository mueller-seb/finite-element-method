%FEM FOR TWO DIFFERENT BOUNDARY VALUE PROBLEMS

%Left boundary value problem, called BVP 1
%   -laplace(u) = sin(pi*x)*sin(pi*y) in Omega
%     u = 0 on boundary of Omega (Dirichlet condition)
%     Omega = [0,1]^2

%Right boundary value problem, calles BVP 2
%    -laplace(u)+u = cos(pi*x)*cos(pi*x) in Omega
%     partial_n(u) = 0 on boundary of Omega (Neumann condition)
%     Omega = [0,1]^2
%Further mathematical description of the problem in Remark 3.27 (Neumann boundary conditions)
startup;
%--------BEGIN OF PARAMETRIZATION AREA------------------
%1 for BVP1, 2 for BVP2
bvp = 1;
%
%1 for triangle elements, 2 for square elements
elementType = 1;
%
%#subintervals of the generated mesh
meshSubIntervals = 10;
%
%#subintervals of the discrete solution
evalSubIntervals = 20;
%
%--------END OF PARAMETRIZATION AREA-------------------


%Create mesh
if (elementType == 1)
    Mesh = triangleMesh(meshSubIntervals);
elseif (elementType == 2)
    Mesh = squareMesh(meshSubIntervals);
end

%Create ansatz function space
ansFunSpace = ansatzFunctionSpace(Mesh, abs(bvp-2)); %BVC: u = 0 on boundary of Omega

%Calculate stiffness matrix A_h
A_h = stiffnessMatrix(ansFunSpace, bvp);

%Calculate right hand side f_h
f_h = rightHandSide(ansFunSpace, bvp);

%Calculate coefficients u_h for approximated solution of u ("ansatz")
u_h = A_h\f_h;

%Calculate matrix of approximated discrete solution
u = solution(ansFunSpace, u_h);
U = u.discreteSolution(evalSubIntervals);

figure;
surf(U(:,:,1), U(:,:,2), U(:,:,3));
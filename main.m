%FEM FOR TWO DIFFERENT BOUNDARY VALUE PROBLEMS
%=============================================
%Left boundary value problem, called BVP #1
%   -laplace(u) = sin(pi*x)*sin(pi*y) in Omega
%     u = 0 on boundary of Omega (Dirichlet condition)
%     Omega = [0,1]^2
%     SOLUTION: u(x,y) = sin(pi*x)*sin(pi*y)/(2pi^2)

%Right boundary value problem, called BVP #2
%    -laplace(u)+u = cos(pi*x)*cos(pi*y) in Omega
%     partial_n(u) = 0 on boundary of Omega (Neumann condition)
%     Omega = [0,1]^2
%     SOLUTION: u(x,y) = sin(pi*x)*sin(pi*y)/(2pi^2)
%Further mathematical description of the problem in Grossmann & Roos, Remark 3.27 (Neumann boundary conditions)

startup;

%------------BEGIN OF PARAMETRIZATION AREA------------------
%Choose boundary value problem.
%1 for BVP #1, 2 for BVP #2.
bvp = 1; 
%
%[xMin, xMax; yMin, yMax]
Omega = [0, 1; 0, 1]; %constant, do not change
%
%Finite element type.
%1 for rectangular triangle elements, 2 for square elements, 3 for arbitrary triangle elements
elementType = 1;
%
%Use higher polynomials (from 6 instead of 3 fixpoints on triangles, 8 instead of 4 fixpoints on squares)
%1 on, 0 off
higherPolynomials = 0;
%
%#Subintervals of the generated rectangular triangle (1) and square (2) meshes.
%[x intervals, y intervals]
meshSubIntervals = [10, 10];
%
%#Subintervals of the discrete solution evaluator.
%[x intervals, y intervals]
%evalSubIntervals = meshSubIntervals is very fast in the case of non arbitrary triangle meshes.
evalSubIntervals = [15, 15]; 
%
%Order of Gaussian quadrature for calculation of stiffness matrix A_h
gaussOrderA_h = 3;
%Order of Gaussian quadrature for calculation of right hand side f_h
gaussOrderF_h = 4;
%Orders of Gaussian quadrature for the a posteriori estimator eta
%[Order on interior, order on edges]
gaussOrderEta = [3, 3];
%
%Order of Gaussian quadrature for calculation of the L2 error ||u-u_h||_Omega
gaussOrderErrorL2 = 3;
%--------END OF PARAMETRIZATION AREA-------------------

tic
%Create mesh
if (elementType == 1)
    disp(['Creating mesh of rectangular triangle elements with ' num2str(meshSubIntervals) ' subintervals...']);
    Mesh = rectTriangleMesh(meshSubIntervals, Omega);
elseif (elementType == 2)
    disp(['Creating mesh of squares with ' num2str(meshSubIntervals) ' subintervals...']);
    Mesh = squareMesh(meshSubIntervals, Omega);
elseif (elementType == 3)
    arbTriangles_PDE;
    Mesh = arbTriangleMesh(meshdata, Omega);
end
disp('Finished creating mesh.');
toc

tic
%Create ansatz function space
disp('Creating ansatz function space...');
ansFunSpace = ansatzFunctionSpace(Mesh, bvp, higherPolynomials);
disp('Finished creating ansatz Function space.');
toc

tic
%Create and save gradients of the ansatz function space basis functions. This makes calculation of A_h more
%efficient because identical gradients don't have to be computed multiple times during the queue.
disp('Creating ansatz function space gradients...');
gradAnsFunSpace = ansFunSpace.gradient;
%laplaceAnsFunSpace = gradAnsFunSpace.divergence;
disp('Finished creating ansatz Function space gradients.');
toc

tic
%Calculate stiffness matrix A_h
disp(['Calculating stiffness matrix for BVP #' num2str(bvp) '...']);
A_h = stiffnessMatrix(gaussOrderA_h, ansFunSpace, gradAnsFunSpace);
%A_h = stiffnessMatrix(gaussOrderA_h, ansFunSpace);
disp('Finished calculating stiffness matrix.');
toc

tic
%Calculate right hand side f_h
disp(['Calculating right hand side for BVP #' num2str(bvp) '...']);
f_h = rightHandSide(gaussOrderF_h, ansFunSpace);
disp('Finished calculating right hand side.');
toc

tic
%Calculate coefficients u_h for approximated solution of u ("ansatz")
disp('Solving the equation system...');
%u_h = A_h\f_h;
u_h = PCG(A_h, f_h);
disp('Finished solving the equation system.');
toc

tic
%Calculate matrix of approximated discrete solution
disp(['Calculating matrix of discrete solution for ' num2str(evalSubIntervals) ' subintervals...']);
u = solution(ansFunSpace, u_h);
U = u.discreteSolution(evalSubIntervals);
disp('Finished calculating matrix of discrete solution.');
toc

figure;
surf(U(:,:,1), U(:,:,2), U(:,:,3));

tic
disp('Calculating L2-Error and a posteriori estimator...');
%||u-u_h||_L2,Omega
errL2 = u.errorLp(2, gaussOrderErrorL2);

%A posteriori error estimator eta
eta = etaAPost(u, gaussOrderEta);
disp('Finished calculating L2-Error and a posteriori estimator.');
toc

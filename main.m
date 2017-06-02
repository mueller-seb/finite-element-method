%FEM FOR TWO DIFFERENT BOUNDARY VALUE PROBLEMS
%=============================================
%Left boundary value problem, called BVP #1
%   -laplace(u) = sin(pi*x)*sin(pi*y) in Omega
%     u = 0 on boundary of Omega (Dirichlet condition)
%     Omega = [0,1]^2
%     SOLUTION: u(x,y) = sin(pi*x)*sin(pi*x)/(2pi^2)

%Right boundary value problem, called BVP #2
%    -laplace(u)+u = cos(pi*x)*cos(pi*x) in Omega
%     partial_n(u) = 0 on boundary of Omega (Neumann condition)
%     Omega = [0,1]^2
%     SOLUTION: u(x,y) = sin(pi*x)*sin(pi*x)/(2pi^2)
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
evalSubIntervals = 10;
%
%order of Gaussian quadrature for stiffness matrix
gaussOrderA_h = 3;
%order of Gaussian quadrature for right hand side
gaussOrderF_h = 4;
%--------END OF PARAMETRIZATION AREA-------------------

tic
%Create mesh
if (elementType == 1)
    disp(['Creating triangle mesh with ' num2str(meshSubIntervals) ' subintervals...']);
    Mesh = triangleMesh(meshSubIntervals);
elseif (elementType == 2)
    disp(['Creating square mesh with ' num2str(meshSubIntervals) ' subintervals...']);
    Mesh = squareMesh(meshSubIntervals);
end
disp(['Finished creating mesh']);
toc

tic
%Create ansatz function space
disp(['Creating ansatz function space...']);
ansFunSpace = ansatzFunctionSpace(Mesh, abs(bvp-2)); %BVC: u = 0 on boundary of Omega
disp(['Finished creating ansatz Function space']);
toc

tic
%Create gradients of ansatz function space
disp(['Creating ansatz function space gradients...']);
gradAnsFunSpace = ansFunSpace.gradient;
disp(['Finished creating ansatz Function space gradients']);
toc

tic
%Calculate stiffness matrix A_h
disp(['Calculating stiffness matrix for BVP #' num2str(bvp) '...']);
A_h = stiffnessMatrix(gaussOrderA_h, bvp, ansFunSpace, gradAnsFunSpace);
%A_h = stiffnessMatrix(gaussOrderA_h, bvp, ansFunSpace);
disp(['Finished calculating stiffness matrix']);
toc

tic
%Calculate right hand side f_h
disp(['Calculating right hand side for BVP #' num2str(bvp) '...']);
f_h = rightHandSide(gaussOrderF_h, ansFunSpace, bvp);
disp(['Finished calculating right hand side.']);
toc

tic
%Calculate coefficients u_h for approximated solution of u ("ansatz")
disp(['Solving the equation system...']);
u_h = A_h\f_h;
disp(['Finished solving the equation system']);
toc

tic
%Calculate matrix of approximated discrete solution
disp(['Calculating matrix with discrete solution for ' num2str(evalSubIntervals) ' subintervals...']);
u = solution(ansFunSpace, u_h);
U = u.discreteSolution(evalSubIntervals);
disp(['Finished calculating matrix with discrete solution.']);
toc

figure;
surf(U(:,:,1), U(:,:,2), U(:,:,3));

%Calculate absolute error u-u_h in Lp-norm
Uref = exactSolution(bvp, evalSubIntervals);
p = 2;
n = evalSubIntervals+1;
absErrorLp = norm(U(:,:,3)-Uref(:,:,3), p)*(1/n^2)^(1/p);

%A posteriori error estimator
%laplaceAnsFunSpace = gradAnsFunSpace.divergence;
eta = etaAPost(u, bvp, 3, 3);


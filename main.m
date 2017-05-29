%FEM FOR TWO DIFFERENT BOUNDARY VALUE PROBLEMS

%Left boundary value problem, called BVP 1
%   -laplace(u) = sin(pi*x)*sin(pi*y) in Omega
%     u = 0 on boundary of Omega (Dirichlet condition)
%     Omega = [0,1]^2

%Right boundary value problem, called BVP 2
%    -laplace(u)+u = cos(pi*x)*cos(pi*x) in Omega
%     partial_n(u) = 0 on boundary of Omega (Neumann condition)
%     Omega = [0,1]^2
%Further mathematical description of the problem in Remark 3.27 (Neumann boundary conditions)
startup;
%--------BEGIN OF PARAMETRIZATION AREA------------------
%1 for BVP1, 2 for BVP2
bvp = 2;
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
    disp(['Creating triangle mesh with ' num2str(meshSubIntervals) ' subintervals...']);
    Mesh = triangleMesh(meshSubIntervals);
elseif (elementType == 2)
    disp(['Creating square mesh with ' num2str(meshSubIntervals) ' subintervals...']);
    Mesh = squareMesh(meshSubIntervals);
end
disp(['Finished creating mesh']);

%Create ansatz function space
disp(['Creating ansatz function space...']);
ansFunSpace = ansatzFunctionSpace(Mesh, abs(bvp-2)); %BVC: u = 0 on boundary of Omega
disp(['Finished creating ansatz Function space']);

%Calculate stiffness matrix A_h
disp(['Calculating stiffness matrix for BVP #' num2str(bvp) '...']);
A_h = stiffnessMatrix(ansFunSpace, bvp);
disp(['Finished calculating stiffness matrix']);

%Calculate right hand side f_h
disp(['Calculating right hand side for BVP #' num2str(bvp) '...']);
f_h = rightHandSide(ansFunSpace, bvp);
disp(['Finished calculating right hand side.']);

%Calculate coefficients u_h for approximated solution of u ("ansatz")
disp(['Solving the equation system...']);
u_h = A_h\f_h;
disp(['Finished solving the equation system']);

%Calculate matrix of approximated discrete solution
disp(['Calculating matrix with discrete solution for ' num2str(evalSubIntervals) ' subintervals...']);
u = solution(ansFunSpace, u_h);
U = u.discreteSolution(evalSubIntervals);
disp(['Finished calculating matrix with discrete solution.']);

Uref = exactSolution(bvp, evalSubIntervals);
p = 2;
n = evalSubIntervals+1;
absErrorLp = norm(U(:,:,3)-Uref(:,:,3), p)*(1/n^2)^(1/p); %absolute error in Lp-norm

figure;
surf(U(:,:,1), U(:,:,2), U(:,:,3));
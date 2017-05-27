%FEM for right boundary value problem
%    -laplace(u)+u = cos(pi*x)*cos(pi*x) in Omega
%    partial_n(u) = 0 on boundary of Omega (Neumann condition)
%     Omega = [0,1]^2
%Further mathematical description of the problem in Remark 3.27 (Neumann boundary conditions)
startup;
bvp = 2;

%Create mesh
Mesh = triangleMesh(10);

%Create ansatz function space
ansFunSpace = ansatzFunctionSpace(Mesh, 0);

%Calculate stiffness matrix A_h
A_h = stiffnessMatrix(ansFunSpace, bvp);

%Calculate right hand side f_h
f_h = rightHandSide(ansFunSpace, bvp);

%Calculate coefficients u_h for approximated solution of u ("ansatz")
u_h = A_h\f_h;

%Calculate matrix of approximated discrete solution
u = solution(ansFunSpace, u_h);
U = u.discreteSolution(20);

figure;
surf(U(:,:,1), U(:,:,2), U(:,:,3));
%FEM for left boundary value problem
%   -laplace(u) = sin(pi*x)*sin(pi*y) in Omega
%     u = 0 on boundary of Omega (Dirichlet condition)
%     Omega = [0,1]^2  
startup;
bvp = 1;

%Create mesh
Mesh = triangleMesh(10);

%Create ansatz function space
ansFunSpace = ansatzFunctionSpace(Mesh, 1); %BVC: u = 0 on boundary of Omega

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
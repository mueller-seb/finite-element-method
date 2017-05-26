%FEM for left boundary value problem
%   -laplace(u) = sin(pi*x)*sin(pi*y) in Omega
%     u = 0 on boundary of Omega
%     Omega = [0,1]^2  
clear all;
close all;
clc;

intervals = 5;
neumann = 1; %BVC: u = 0 on boundary of Omega

%Creating mesh
M = triangleMesh(intervals);

%Creating ansatz function space
S = ansatzFunctionSpace(M, neumann);

%Calculating stiffness matrix A_h
A_h = stiffnessMatrix(S, 1);

%Calculating right hand side f_h
f_h = rightHandSide(S, 1);

%Calculating coefficients u_h for approximated solution of u ("ansatz")
u_h = A_h\f_h;

%Calculating approximated discrete solution
u = zeros(intervals+1);
u_ij = 0;
for i = 2:intervals
    for j = 2:intervals
        u_ij = 0;
        k = 1;
        for phi_k = S.basisFunctions(1:end)
           u_ij = u_ij + c(k)*phi_k.evaluate((i-1)/intervals, (j-1)/intervals);
           k = k+1;
        end
        solution(i,j) = u_ij;
    end
end
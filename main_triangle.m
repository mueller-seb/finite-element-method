clc
clear variables
close all

intervals = 2;
neumann = 1;

M = triangleMesh(intervals)
S = ansatzFunctionSpace(M, neumann)

n = size(S.basisFunctions, 2);
A = zeros(n)

for i=1:n
    for j=1:n
        phi_i = S.basisFunctions(i);
        phi_j = S.basisFunctions(j);
        a_ij = 0;
        
    end
end
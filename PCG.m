function [ x ] = PCG( A, b ) 

%PCG Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function PCG provides the solution x of the system of linear        %
%   euqations A*x = b.                                                  %
%                                                                       %
%   Input: nxn Matrix A und n-dimensional Vector b                      %
%                                                                       %
%   Output:  The n-dimensional Vector and solution x of A*x=b.          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = size(A, 2); % get number of columns in matrix A
x = zeros(n, 1); % initialise x

%test if A is symmetric and positive difinite
if  ~issymmetric(A) 
  error('Matrix is not symmetric.');
end
if ~all(eig(A) > eps)
    error('Matrix is not positive definite');
end

% Define tolerance threshold for iteration steps
tol = 0;
maxit = 3*n;

% Allocate space for plot helpers:
plotResPCG = zeros(maxit+1,1);

% Define Preconditioning Matrix (Splitting-associated Preconditioners):
%% Jacobi Precond:
Delem = diag(A);
D = diag(Delem);
Jacobi = inv(D);
%% SSOR Precond:
L = tril(A,-1);
omega = 1.0; % choose omega \in (0,2).
FacD = (1/omega) * D;
invFacD = inv(FacD);
FacDplusL = (1/omega) * D + L;
SSORhelp = (1/(2-omega)) * ( (1/omega) * D + L ) * invFacD * FacDplusL';
SSOR = inv(SSORhelp);
%% Symmetric Gauss-Seidel Precond:
R = triu(A,1);
DpR = D + R;
DpL = D + L;
invDpR = inv(DpR);
invDpL = inv(DpL);
SGaussSeidel = invDpR * D * invDpL;
%Incomplete Cholesky Preconditioner
%L = ichol(A);
%Lhelp = inv(L);
%iCholesky = Lhelp'*Lhelp;


% Choose Preconditioning Matrix:
 P = eye(n,n); % For Testing-Purposes
% P = Jacobi;               % Jacobi Preconditioning
% P = SSOR;                 % SSOR Preconditioning
% P = SGaussSeidel;         % Symmetric Gauss-Seidel Preconditioning         
% P = iCholesky;                     % Incomplete Cholesky
% Check for trivial solution
% trivial.

% MAIN ALGORITHM:
normb = norm(b);
tolb = tol * normb; 
tolb2 = tolb * tolb;
r = b - A * x; % residual
normr = norm(r);
plotResPCG(1) = log10(normr);
dp = P * r; % CG-direction under Preconditioning
alphap = r' * dp; 

% Iterate
for i = 1:maxit
  if (normr <= tol) % (alphap <= tolb2) % or simply: (normr <= tol) 
    disp(['PCG Converged \n']); % converged
    break
  end
  v = A*dp; % Matrix * i-th iterated cg-search-direction-vector (of Krylov Subspace)
  if (norm(v) <= tolb2)
    error('Matrix is singular.');
  end
  vdp = (v'*dp); % i.e. vdp = v' * dp = (A*dp)' * dp = dp' * A * dp !> 0 
  if(vdp <= 0)
    error('Matrix is not positive definite.');
  end
  lambdap = alphap/vdp; % "Stepwidth" 
  x = x + lambdap * dp; % make step
  r = r - lambdap * v;  % new residual
  z = P*r;              
  alphap2 = r' * z;
  dp = z + alphap2/alphap * dp; % new conjugated search direction
  alphap = alphap2;
  normr = norm(r);
  plotResPCG(i+1) = log10(normr);
end
iPCG = i;

for j = i:maxit
  plotResPCG(j+1) = log10(normr);
end 
%~ plotResPCG

% Plot course of residual (normr) w.r.t. num iter (i): possibly CG vs. PCG: 
%~ plot(plotNumIterPCG, plotResPCG, '-xr'); %% WITH PRECOND.
%~ hold on;

% For Testing-Purposes:
%xtest =  A\b;
%rtest = b - A*xtest;
%disp(['Test Norm']);
%normrtest = norm(rtest)
%disp(['Meine Norm']);
%normr 




% Plot course of residual (normr) w.r.t. num iter (i): possibly CG vs. PCG: 
%~ plot(plotNumIterPCG, plotResPCG, '-xr'); %% WITH PRECOND.
%~ hold on;
%~ plot(plotNumIterCG, plotResCG, ':om'); %% WITHOUT PRECOND.

plotPCG = 1:maxit;
figure
%~ plot(plotNumIterPCG, plotResPCG, plotNumIterCG, plotResCG)
plot( plotPCG, plotResPCG(1:maxit))
title('Course of residual values of Ax = b for PCG vs. CG')
xlabel('number of iterations') % x-axis label
ylabel('Res values for PCG(x) and CG(o)') % y-axis label
legend('y = Res(PCG)')

% ***************************************************************************
% ***************************************************************************

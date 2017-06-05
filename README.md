# finite-element-method
Finite element code in matlab for two different boundary value problems:

>BVP #1  
>-laplace(u) = sin(pi*x)*sin(pi*y) in Omega  
>u = 0 on boundary of Omega  
>Omega = [0,1]^2

>BVP #2  
>-laplace(u)+u = cos(pi*x)*cos(pi*x) in Omega  
>partial_n(u) = 0 on boundary of Omega  
>Omega = [0,1]^2  

The program solves both BVPs on a mesh of rectangulars, rectangular triangles or arbitrary triangles.
Intervals of both the rectangular meshes and the discrete solution matrix are freely selectable. The polynomials of the ansatz function space can be determined to be of minimum or higher degree (see annotations). The discrete solution is plotted and the L2-Error ||u-u_h||_Omega and the a posteriori error estimator eta (Num. treatment of PDEs, Grossmann & Roos, p. 290) are calulated.

## HowTo
Make sure, that all files are in the same folder. Choose all parameters in the upper section of main.m and run main.m.

## Annotations
### Efficiency

A PCG solver is used to solve the linear equation system A_h * u_h = f_h.



function [ fun ] = f( bvp )
%F Summary of this function goes here
%   Detailed explanation goes here

if (bvp == 1)
    fun = @(x,y) sin(pi*x)*sin(pi*y);
elseif (bvp == 2)
    fun = @(x,y) cos(pi*x)*cos(pi*y);
end        

end


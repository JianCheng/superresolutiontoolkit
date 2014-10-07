function [ux,uy,uxx,uyy,uxy] = gradSecondOrder(fTV)
% according to paper: Marquina, Antonio, and Stanley J. Osher. "Image super-resolution by TV-regularization and Bregman iteration." Journal of Scientific Computing 37.3 (2008): 367-382.

gradOption.order=2;
gradOption.bound='sym';
gradOption0.order=0;
gradOption0.bound='sym';
gradOption1.order=1;
gradOption1.bound='sym';

[ux, uy] = grad(fTV,gradOption);
[uxy, aa] = grad(uy,gradOption);
[a1, aa]=grad(fTV,gradOption0);
[uxx, aa] = grad(a1,gradOption1);
[a1, aa]=grad(fTV,gradOption0);
[a1, uyy]=grad(aa,gradOption1);

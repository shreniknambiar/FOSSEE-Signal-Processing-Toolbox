// Test # 5 : When either Input Argument #4 or Input Argument #5 is of complex type
exec('./zpklp2bp.sci',-1);
[z,p,k,n,d]=zpklp2bp(3,0.2,7,0.5*%i,[0.4,0.8]);
//!--error 10000
//Wo must be real ,numeric and scalar
//at line      43 of function zpklp2bp called by :  
//[z,p,k,n,d]=zpklp2bp(3,0.2,7,0.5*%i,[0.4,0.8]);

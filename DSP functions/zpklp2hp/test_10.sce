// Test #10 : For complex vector inputs
exec('./zpklp2hp.sci',-1);
[z,p,k,n,d]=zpklp2hp([2*%i,0.4*%i],[%i,3*%i],1,0.2,0.7);
disp(d);
disp(n);
disp(k);
disp(p);
disp(z);
//
//Scilab Output
//d=1.  - 0.2212317  
//n=0.2212317  - 1.  
//k=0.2830084 + 0.0950556i  
//p=0.4218182 + 0.9066804i  
//    0.2444835 + 0.3153042i  
 //z=0.2731969 + 0.4697801i  
//    1.2282212 + 1.8206962i  
//
//Matlab Output
//z = 0.2732 + 0.4698i 
//      1.2282 + 1.8207i 
//p = 0.4218 + 0.9067i 
//      0.2445 + 0.3153i 
//k = 0.2830 + 0.0951i 
//n = 0.2212        -1.0000 
//d = 1.0000        -0.2212

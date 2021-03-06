// Test #10 : For valid input #2
exec('./zpklp2bp.sci',-1);
[z,p,k,n,d]=zpklp2bp(3.2*%i,[2.2*%i,7],1,0.66,[0.52,0.74]);
disp(d);
disp(n);
disp(k);
disp(p);
disp(z);
//
//Scilab Output
//d=1.    0.6960120    0.6489181  
//n=- 0.6489181  - 0.6960120  - 1.  
//k=0  
//p=-0.4944747 - 0.7288925i  
//    -0.2316771 + 0.8310738i  
//    -0.3639793 + 0.7694945i  
//    -0.3639793 - 0.7694945i  
//z=-0.4533619 - 0.7174813i  
//    -0.2575236 + 0.7908268i  
//
//Matlab Output
// z = -0.4534 - 0.7175i 
//       -0.2575 + 0.7908i
// p = -0.4945 - 0.7289i
//       -0.2317 + 0.8311i 
//       -0.3640 + 0.7695i 
//       -0.3640 - 0.7695i 
//k = 0 
//n =-0.6489   -0.6960       -1.0000
//d= 1.0000       0.6960        0.6489

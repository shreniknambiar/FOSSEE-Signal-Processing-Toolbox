function [Z2, P2, K2, AllpassNum,AllpassDen]= zpklp2bp(Z, P ,K, Wo,Wt)
//Zero-pole-gain lowpass to real bandpass frequency transformation
//
//Calling Sequences
//
//[Z2,P2,K2,AllpassNum,AllpassDen] = zpklp2bp(Z,P,K,Wo,Wt) returns zeros, Z2, poles, P2, and gain factor, K2, of the target filter transformed from the real lowpass prototype by applying a second-order real lowpass to real bandpass frequency mapping.It also returns the numerator, AllpassNum, and the denominator AllpassDen, of the allpass mapping filter. The prototype lowpass filter is given with zeros, Z, poles, P, and gain factor, K.
//
//Input Parameters:
//                      Z: Zeros of the prototype filter
//                      P: Poles of the prototype filter
//                      K: Gain of the prototype filter
//                      Wo: Frequency value of the prototype filter to be transformed
//                      Wt: Desired frquency of the target filter
//
//Output Parameters:
//                      Z2: Zeros of the target filter
//                      P2: Poles of the target filter
//                      K2:Gain factor of the target filter
//                      AllpassNum: Numerator of the mapping filter
//                      AllpassDen: Denominator of the mapping filter
//Example: Design a prototype real IIR halfband filter using a standard elliptic approach
//
//                      [b, a] = ellip(3,0.1,30,0.409);
//                      z = roots(b);
//                      p = roots(a);
//                      k = b(1);
//                      [z2,p2,k2] = zpklp2bp(z,p,k,0.5,[0.25, 0.35]);
//
//Author: Shrenik Nambiar
//
//References: 1. Constantinides, A.G., "Spectral transformations for digital filters," IEEE® Proceedings, vol. 117, no. 8, pp. 1585-1590, August 1970.
//
//Input Validaton Statement
    if argn(2) ~=5 then
        error("Number of input arguments should be 5");
    end
    
    if argn(1)<1 | argn(1)>5 then
        error("Number of output arguments should be between 1and 5");
    end
    
    if ~isscalar(Wo) | ~isreal(Wo) then
        error("Wo must be real ,numeric and scalar");
    end
    if Wo<=0 | Wo>=1 then
        error("Wo must lie between 0 and 1");
    end
    
    if length(Wt)~=2 | ~isreal(Wt) then
        error("Wt must be real and numeric and must contain only 2 elements");
    end
    if Wt(1)<=0 | Wt(1)>=1 | Wt(2)<=0 | Wt(2)>=1 then
        error("Wt must lie between 0 and 1");
    end
    
    if ~isscalar(K) then
        error("K must be a scalar");
    end
// Calculating the numerator and denominator for the mapping filter
    bw = abs(Wt(2) - Wt(1));
    al = sin(%pi*(Wo-bw)/2) / sin(%pi*(Wo+bw)/2);
    be= cos(%pi*sum(Wt)/2) / cos(%pi*bw/2);
    AllpassNum = -[al -be*(1+al) 1];
    AllpassDen = -flipdim(AllpassNum,2);
    
    
    if or(AllpassNum~=1) | or(AllpassDen~=1) then
        Z2=[];
        P2=[];
        K2=K*prod(AllpassNum(1)-Z*AllpassDen(1))/prod(AllpassNum(1)-P*AllpassDen(1));
        
        for i=1:length(Z),
            Z2 = [Z2, roots(AllpassNum - Z(i).*AllpassDen).'];
        end
        for i=1:length(P),
            P2 = [P2, roots(AllpassNum - P(i).*AllpassDen).'];
        end
// For stabilizing the target filter (if unstable after tranformation)
        index = find(abs(P2)>1);
        K2 = K2/prod(1-P2(index));
        P2(index) = 1 ./conj(P2(index));
        K2= K2*prod(1-P2(index));        
    else
        Z2=Z;
        P2=P;
        K2=K;
    end
    //Converting to Column vector
    Z2=Z2(:);
    P2=P2(:);

endfunction

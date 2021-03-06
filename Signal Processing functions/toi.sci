function[oip3, fundpow, fundfreq, imodpow, imodfreq]= toi(varargin)
    
    if(argn(1)<0 | argn(1)>5) then
        error("Output arguments should lie between 0 and 5");
    end
    
    if(argn(2)<1 | argn(2)>4) then
        error("Input arguments should lie between 1 and 4");
    end
    
    if (~isvector(x) & (type(x) ~=8 | type(x) ~= 1)) then
        error("x should be a vector of type doule or integer");
    end
    
    if (~isscalar(fs) & fs<0) then
        error("fs must be positive scalar");
    end
    
    if(~isvector(pxx) & (type(pxx) ~=8 | type(pxx) ~= 1) & pxx<0) then
        error("psd estimate vector must be non-negative vector of type double or integer");
    end
    
    
    if(~isvector(sxx) & (type(sxx) ~=8 | type(sxx) ~= 1) & sxx<0) then
        error("power estimate vector must be non-negative vector of type double or integer");
    end
    
    if(~isvector(f) & (type(f) ~=8 | type(f) ~= 1)) then
        error(" f must be a vector of type double or integer");
    end
    
    
    if(~isscalar(rbw) & (type(rbw) ~=8 | type(rbw) ~= 1) & rbw<0) then
        error("rbw must be positive scalar");
    end
    
    if(argn(1)==0) then
        flag=1;
    else
        flag=0;
    end
    
    if(argn(2)<2) then
        x=varargin(1);
        fs=1;
        [oip3, fundpow, fundfreq, imodpow, imodfreq]= timetoi(flag,x,fs);
    elseif(argn(2)==2) then
        x=varargin(1);
        fs=varargin(2);
        [oip3, fundpow, fundfreq, imodpow, imodfreq]= timetoi(flag,x,fs);
    elseif(argn(2) == 3 & strcmpi(varargin(3),'psd')) then
        pxx= varargin(1);
        f= varargin(2);
        [oip3, fundpow, fundfreq, imodpow, imodfreq]= psdtoi(flag,pxx,f);
    elseif(argn(2)== 4 & strcmpi(varargin(4),'power')) then
        sxx= varargin(1) ;
        f= varargin(2);
        rbw= varargin(3);
        [oip3, fundpow, fundfreq, imodpow, imodfreq]= powertoi(flag,sxx,f,rbw);
    else
        error("The valid flags are psd and power");
    end
    
endfunction

function [oip3, fundpow, fundfreq, imodpow, imodfreq] = timetoi(flag,x,fs)
    
    if max(size(x))==length(x)  then
        x=x(:);
    end
    
    x=x-mean(x);
    n=length(x);
    w= window('kr',n,38);
    rbw= enbw(w,fs);
    [pxx, f] = periodogram(x,w,n,fs,'psd');
    
    [oip3, fundpow, fundfreq, imodpow, imodfreq]= toicalc(flag,pxx,f,rbw);
    
endfunction

function [oip3, fundpow, fundfreq, imodpow, imodfreq]= powertoi(flag,sxx,f,rbw)
    if(f(1) ~=0) then
        error("pxx must be one-sided");
    end
    df= mean(diff(f));
    
    if(rbw<df) then
        error("rbw should be greater than df");
    end
    
    [oip3, fundpow, fundfreq, imodpow, imodfreq]= toicalc(flag,sxx/rbw,f,rbw)

endfunction

function [oip3, fundpow, fundfreq, imodpow, imodfreq]= psdtoi(flag,pxx,f,rbw)
    if(f(1) ~=0) then
        error("pxx must be one-sided");
    end
    df= mean(diff(f));

    [oip3, fundpow, fundfreq, imodpow, imodfreq]= toicalc(flag,pxx,f,df);

endfunction



function plotfunction(pxx,f,rbw,ifreq,dcindex,freqindex)
    pxx=pxx*rbw;
    
    xd= f(freqindex(1):freqindex(2));
    yd=10*log10(pxx(freqindex(1):freqindex(2)));
    plot(xd,yd,'r');
    
    
    xd=f;
    yd=10*log10(pxx);
    plot(xd,yd,'g');
    
    
    xd=f(dcindex(1):dcindex(2));
    yd=10*log10(pxx(dcindex(1):dcindex(2)));
    plot(xd,yd,'b');
    
    
endfunction


function [power, fr, indextone, indexleft, indexright]= dcremove(pxx, f, rbw, tonefreq)
    
      if(f(1)<=tonefreq & tonefreq<=f($)) then
          [s, indextone] = min(abs(f-tonefreq));
          iLeft = max(1,indextone-1);
          iRight = min(indextone+1,length(pxx));
          [s, indexmax] = max(pxx(iLeft:iRight));
          indextone = iLeft+indexmax-1;
      else
          power = NaN;
          fr = NaN;
          indextone = [];
          indexleft = [];
          indexright = [];
      end
      
    indexleft = indextone - 1;
    indexright = indextone + 1;
    while indexleft > 0 & pxx(indexleft) <= pxx(indexleft+1)
        indexleft = indexleft - 1;
    end


    while indexright <= length(pxx) & pxx(indexright-1) >= pxx(indexright)
        indexright = indexright + 1;
    end

    indexleft = indexleft+1;
    indexright = indexright-1;
    ffreq = f(indexleft:indexright);
    sfreq = pxx(indexleft:indexright); 
    fr = (ffreq.*sfreq) ./ sum(sfreq);
    
    if (indexleft<indexright) then
       power = bandpower(pxx(indexleft:indexright),f(indexleft:indexright),'psd');
    elseif 1 < indexright & indexright < length(pxx)
         power = pxx(indexright) * (f(indexright+1) - f(indexright-1))/2;
    else

         power = pxx(indexright) * mean(diff(f));
    end


    if (power < rbw*pxx(indextone)) then
         power = rbw*pxx(indextone);
         fr = f(indextone);
    end
endfunction

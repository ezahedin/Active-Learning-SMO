function S=traningError(alpha,Y,b,K)

    S=0;
    for i=1:length(Y)
     if (f(Y,alpha,b,i,K)*Y(i)>0)
         S=S+1;
     end
    end
    
    S=S/length(Y)*100;

    
function F=confidence(Y,alpha,b,K,Mbmat,Tid)
    F=0;
    
    for i=Mbmat
        Ktmp=K(i,Tid);
        if (f(Y(Tid),alpha,b,1,Ktmp)*Y(i)<0)
            F=F+1;
        end
    end
    
    F=F/length(Mbmat)*100;
    

function [alpha,b,Error]=SMO(Y,eps,tol,ul,alpha,Error,K,b)
%%adjusting the size of the traning data according to the Pdata value


numChanged=0;
examineAll=1;


while((numChanged>0) || examineAll)
    numChanged=0;
    if(examineAll)
        for i2=1:length(alpha)
            [out,alpha,b,Error]=examineExample(i2,Y,alpha,tol,ul,Error,eps,b,K);
            numChanged=numChanged+out;
        end
    else
            tmp=find(Error>tol & Error<ul(2)-tol);
        for j=tmp
            [out,alpha,b,Error]=examineExample(j,Y,alpha,tol,ul,Error,eps,b,K);
            numChanged=numChanged+out;
        end
        
    end
    
     if (examineAll==1)
         examineAll=0;
     elseif (numChanged==0)
         examineAll=1;
     end      
end
TE=traningError(alpha,Y,b,K);
%C=confidence(Xback(TS+1:end,:),Yback(TS+1:end),alpha,b,type);
%fprintf(sprintf('Traning error is %d\n',100-TE));        
        
        
        
        
        
        
        
            

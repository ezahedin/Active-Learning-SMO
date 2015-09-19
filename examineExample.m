function [out,alpha,b,Error]=examineExample(i2,Y,alpha,tol,ul,Error,eps,b,K)
    out=0;
    alph2=alpha(i2);

        if ((alph2<tol) || (alph2>ul(2)-tol))
            E2=f(Y,alpha,b,i2,K)-Y(i2);
        else
            E2=Error(i2);
        end

    r2=E2*Y(i2);
    
    if ((r2 < -tol)&&(alph2<ul(2))) || ((r2>tol) && (alph2 > 0))
        tmp=find((Error>tol) & (Error<ul(2)-tol));

        if(~isempty(tmp)) && (E2>0)
            [PP,i1]=max(Error);
            [check,alpha,Error,b]=takeStep(i1,i2,alpha,Y,b,eps,Error,ul,E2,tol,K);
            if check
                out=1;
                return;
            end
        elseif (~isempty(tmp)) && (E2<0)
            [PP,i1]=min(Error);
            [check,alpha,Error,b]=takeStep(i1,i2,alpha,Y,b,eps,Error,ul,E2,tol,K);
            if check
                out=1;
                return;
            end            
        end
    
        
    %%loop over all non-zero and non-C alpha, starting at randmom points
    if (~isempty(tmp))
        startPoint=randi(length(tmp));
    %%reorder the tmp matrix
        tmp=[tmp(startPoint:end) tmp(1:startPoint-1)];
            for i1=tmp
                 [check,alpha,Error,b]=takeStep(i1,i2,alpha,Y,b,eps,Error,ul,E2,tol,K);
                if check
                    out=1;
                    return
                end
            end
    end
     %%loop over all lagrange multiplier elements, starting at randmom points
            for i1=1:length(alpha)
                 [check,alpha,Error,b]=takeStep(i1,i2,alpha,Y,b,eps,Error,ul,E2,tol,K);
                if check
                    out=1;
                    return
                end
            end
    end
    
    

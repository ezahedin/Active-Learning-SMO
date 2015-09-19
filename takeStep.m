function [out,alpha,Error,b]=takeStep(i1,i2,alpha,Y,b,eps,Error,ul,E2,tol,K)
    %%[alpha feature target threshold Error]=[alpha X Y b Error cache]
    %% eps is the convergence on alpha vector elements-- default is 0.001
    %% tol is the distance from lower '0' and upper 'C' bounds-- default=0.001 %%
    %%ul is the upper and lower bound values [ul(0), ul(1)]=[lower, upper]
    %%K is the kernel matrix evaluated once
    out=0;

    if(i1==i2)
        return;
    end
    
    %lagrange multiplier for i1
    alph1=alpha(i1);
    alph2=alpha(i2);
    
    %%check if alpha1 is on-bound-->[YES; NO]=[Evaluate E1 from SVM function; Take E1 from cache Error vector]
    if ((alph1<tol) || (alph1>ul(2)-tol))
        E1=f(Y,alpha,b,i1,K)-Y(i1);
    else
        E1=Error(i1);
    end
    
    %%Computing the linear constraint bound, L, H (See literature for details)
    s=Y(i1)*Y(i2);
    
    if(s>0)
        L=max(0,alph2+alph1-ul(2));
        H=min(ul(2),alph1+alph2);
    else
        L=max(0,alph2-alph1);
        H=min(ul(2),ul(2)+alph2-alph1);
    end
    
    if (L==H)
        return;
    end
    
    k11=K(i1,i1);
    k12=K(i1,i2);
    k22=K(i2,i2);
    
    eta=2*k12-k11-k22;
    gamma=alpha(i1)+s*alpha(i2);
    if(eta<0)
        
        a2=alph2-Y(i2)*(E1-E2)/eta;
        if (a2<L)
            a2=L;
        elseif (a2>H)
            a2=H;
        end
    else
        Lobj=-s*L+L-0.5*k11*(gamma-s*L)^2-.5*k22*L^2-s*k12*(gamma-s*L)*L-Y(i1)...
            *(gamma-s*L)*(f(Y,alpha,b,i1,K)+b-Y(i1)*alph1*k11-Y(i2)*alph2*K(i2,i1))...
            -Y(2)*L*(f(Y,alpha,b,i2,K)+b-Y(i1)*alph1*k12-Y(i2)*alph2*k22);

        
        Hobj=-s*H+H-0.5*k11*(gamma-s*H)^2-.5*k22*H^2-s*k12*(gamma-s*H)*H-Y(i1)...
            *(gamma-s*H)*(f(Y,alpha,b,i1,K)+b-Y(i1)*alph1*k11-Y(i2)*alph2*K(i2,i1))...
            -Y(2)*H*(f(Y,alpha,b,i2,K)+b-Y(i1)*alph1*k12-Y(i2)*alph2*K(i2,i1));
        
        if (Lobj<Hobj-eps)
            a2=L;
        elseif (Lobj>Hobj+eps)
            a2=H;
        else
            a2=alph2;
        end
    end
    
    if(a2<1e-8)
        a2=0;
    elseif (a2 > ul(2)-1e-8)
        a2=ul(2);
    end
    
    %%if the change in the first lagrange multipler is small return zero
    if (abs(a2-alph2)<eps*(a2+alph2+eps))
        return
    end
    a1=alph1+s*(alph2-a2);
    
   %%evaluate threshold or b AND updating the lagrange multipliers and
   %%caches errors
   b1=E1+Y(i1)*(a1-alph1)*k11+Y(i2)*(a2-alph2)*k12+b;
   b2=E2+Y(i1)*(a1-alph1)*k12+Y(i2)*(a2-alph2)*k22+b;
   bo=b;
   b=(b1+b2)/2;
   
   Error=Error+Y(i1)*(a1-alph1).*K(i1,:)+Y(i2)*(a2-alph2).*K(i2,:)+bo-b;
   Error(i1)=0;Error(i2)=0;
   alpha(i1)=a1;
   alpha(i2)=a2;
   out=1;
   
    
    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
function x=Kernel(X1,X2,type,S)

switch (type)
    case 'G'
        x=exp(-norm(X1-X2).^2/(2*S.^2));
    case 'L'
        x=sum(X1.*X2);
        
end
        


function out=f(Y,alpha,b,id,K)
out=sum(Y'.*alpha.*K(id,:))-b;




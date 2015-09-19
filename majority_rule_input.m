function  [X,Y]=majority_rule_input(isize)
Y=zeros(1,isize);
X = randi([0 1],isize,20);
for i=1:isize
    one=find(X(i,:)>0);
    zero=find(X(i,:)<1);
    if(length(one)>length(zero))
        Y(i)=1;
    else
        Y(i)=-1;
    end
end




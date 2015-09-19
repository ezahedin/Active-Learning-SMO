function [alpha, b, query, Conf]=active_learning(X,Y,Pdata,tol,eps,ul,Init,Sigma,type,eta)
%%Pdata= Percentage of data considered for online query
%%Init=Percentage of data with start the initial training
%%query=Number of onlie query before the algorithm converge
%% Kernel Evaluation
%Evaluate the whole Kernel Function onces and send it to every function needs it
K=zeros(size(X,1));
for i=1:length(Y)
    for j=1:length(Y)
        K(i,j)=Kernel(X(i,:),X(j,:),type,Sigma);
    end
end

%%TS stands for the training size
TS=int32(Pdata/100*size(X,1));
%%I=number of data we start our active learning
I=int32(Init/100*TS);
%%vectors for SMO function
Error=zeros(1,I);
alpha=zeros(1,I);

%%reducing the initial data from TS size to I size
Yt=Y(1:I);
query=0;
Kreduced=K(1:I,1:I);
untrained_id=I+1:TS;
trained_id=1:I;
b=0;
%%Setting constants for the convergence criteria
%%choose eps as the average error on the untrained data
%%Confidence (eta) on the queried data chosen by user (See paper for details)
%%Indices to select random element from untrained data and performing the
%%confidence analyses, I set the default 20% of the untrained data size
Mbar=int32(40*length(untrained_id)/100);
%tmp_untrained=untrained_id;
k=1;
Sbar=Inf;


while(true)
    
    %%finding the SVM function values for unlabelled features --pre-allocate
    %%to speed-up
    fx=zeros(1,TS-I);
    %%defining untrained unlaballed indices

    
    [alpha,b,Error]=SMO(Yt,eps,tol,ul,alpha,Error,Kreduced,b);
   
    %%Calculate SVM function to see if the margin is empty
    %%constructing the Kernel for the untrained data
    %%Smart--Using the same function 'f' for trained and untrained data
            count=0;
        for i=untrained_id
            count=count+1;
            Ktmp=K(i,trained_id);
            fx(count)=f(Yt,alpha,b,1,Ktmp);
        end
        
            [minfx, idm]=min(abs(fx));
            idmin=untrained_id(idm);
    %%tricky part- Test the convergence criteria
    %%see if the margin band is empty
    
    if(minfx>1)
        
        %%choose a random set of untrained data with size Mbar and get the
        %%confidence of the data
        tmp_untrained=untrained_id;
        tmp_untrained(randperm(numel(tmp_untrained)))=tmp_untrained;
        Mbar_mat=tmp_untrained(1:Mbar);
        %%getting the average error on the randomly selected data from unlabelled data
        Sbar=confidence(Y,alpha,b,K,Mbar_mat,trained_id)/100;
        k=k+1;
        Mbar=Mbar+1;
        
       %%remeber to write the conditon to see when Mbar reach its maximum
       %%value and then exit the algorithm
    end
            
    
            %%Checking the convergence criteria
            if(Sbar<eps+sqrt(double((k*log(2)-log(eta/100))/(2*Mbar))))
             %%the convergence has been reached sisnce the uncertranity of
             %%the untrained data is less than epsilon
            break;
            %%if all unlabled data are queried then exit--
            
            elseif(I==TS)
            break;
                
            else
                %%
                I=I+1;
                query=query+1;
                Conf(query)=100-confidence(Y,alpha,b,K,[TS+1:size(X,1)],trained_id);
                %%reset all the initial information for the new training set
                %alpha=zeros(1,I);
                alpha=[alpha 0];
                Error=zeros(1,I);
                %b=0;
                Yt=[Yt; Y(idmin)];
                %Updating the Kernel matrix after each query
                Krsize=size(Kreduced,1);
                %Kreduced=[[Kreduced;K(idmin,1:Krsize)],[K(idmin,1:Krsize)'; K(idmin,idmin)]];
                Kreduced=[[Kreduced;K(idmin,trained_id)],[K(idmin,trained_id)'; K(idmin,idmin)]];
                %Updating untrained_id and trained matrix
                untrained_id(idm)=[];
                trained_id=[trained_id idmin];

            end
            
            %%test part
            
            %%Measure the confidence of the current training set

end

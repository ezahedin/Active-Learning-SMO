isize=400;
[X, Y]=majority_rule_input(isize);
Y=Y';
Pdata=50;
tol=0.001;
eps=0.0001;
ul=[0 +Inf];
Init=5;
Sigma=20;
type='G';
eta=0.999;

[alpha, b, query,Conf]=active_learning(X,Y,Pdata,tol,eps,ul,Init,Sigma,type,eta);

# Active Learning (Machine Learning)
=========================
Author: Ehsan Zahedinejad ezahedin@ucalgary.ca
=========================

Title:
=========================
Active Learning Program. A matlab implementation of Active Learning based on the original works from
John C. Platt et.al. and C. Campbell et.al. See publications for more detail: 
http://research.microsoft.com/pubs/68391/smo-book.pdf
http://vis.uky.edu/~cheung/courses/ee639_fall04/readings/campbell00query.pdf

Benchmarks:
=========================
All the results reported in the second above mentioned reference are reproduced with the active_learning program.


Function description:
============================================
The main function is active_learning(X,Y,Pdata,tol,eps,ul,Init,Sigma,type,eta)

Input arguments for active_learning function
===========================================
1. X= The feature matrix (2d array)
2. Y= Target matrix (1d array)
3. Pdata= Percenateg of data being used for training data. The rest will be used for validation (scalar in terms of percentage)
4. tol= Distance within that the lagrange multiplier will be mapped to zero or upper limit 'C'. Best value could be:0.001 (scalar)
5. eps= Convergence criteria--show what should the difference between lagranage multiplier between two consecutive iteration has to be to exit. Example eps=0.001 (scalar)
6. ul= upper and lower bound for lagrange multipliers. Example [0, 1]. If the upper is infinity write [0 Inf] (1d array) 
7. Init= The percentage of data being used to start the online query. Choose small number 5-20 percent (scalar in terms of percent)
8. Sigma= Gaussian variance. If liner kernel write zero.
9. type= What Kernel function one likes to use. Currently Linear 'L' or Gaussian function are supported 'G' (char)
10. eta= The confidence on the reamined not-queried data. example eta=99 (scalar in percent)


Output arguments for active_learning function
===========================================
1. [alpha, b, query,Conf]=active_learning(X,Y,Pdata,tol,eps,ul,Init,Sigma,type,eta).
2. alpha= array of lagrange multipliers (1d array)
3. b= threshold value (scalar)
4. query= number of query before convergence (scalar)
5. Conf= confidence array showing the confidence of model on validation data (1d array)

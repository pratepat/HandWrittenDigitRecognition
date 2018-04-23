# HandWrittenDigitRecognition
SVM+PCA 98.5% Accuracy

Resampling: Cross-Validated (5 fold) 
Summary of sample sizes: 47997, 47999, 48004, 48000, 48000 
Resampling results across tuning parameters:

  sigma  C    Accuracy   Kappa    
  0.025  0.1  0.9606668  0.9562833
  0.025  1.0  0.9803001  0.9781041
  0.025  2.0  0.9825834  0.9806419
  0.025  5.0  0.9832334  0.9813644
  0.050  0.1  0.9624334  0.9582481
  0.050  1.0  0.9820167  0.9800122
  0.050  2.0  0.9832667  0.9814015
  0.050  5.0  0.9835834  0.9817535

Accuracy was used to select the optimal model using the largest value.
The final values used for the model were sigma = 0.05 and C = 5.
Confusion Matrix and Statistics

          Reference
Prediction    0    1    2    3    4    5    6    7    8    9
         0  973    0    4    0    0    2    5    0    2    3
         1    0 1129    1    0    0    0    2    6    0    3
         2    1    3 1012    2    4    0    2    9    1    0
         3    0    1    1  997    0    6    0    2    3    6
         4    0    0    2    0  966    0    1    1    0    3
         5    0    0    0    3    0  881    2    1    1    2
         6    2    1    2    0    1    1  944    0    0    1
         7    1    1    4    1    1    1    0 1005    1    3
         8    3    0    6    6    2    1    2    2  964    2
         9    0    0    0    1    8    0    0    2    2  986

Overall Statistics
                                          
               Accuracy : 0.9857          
                 95% CI : (0.9832, 0.9879)
    No Information Rate : 0.1135          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.9841          
 Mcnemar's Test P-Value : NA              

Statistics by Class:

                     Class: 0 Class: 1 Class: 2 Class: 3 Class: 4 Class: 5 Class: 6 Class: 7 Class: 8 Class: 9
Sensitivity            0.9929   0.9947   0.9806   0.9871   0.9837   0.9877   0.9854   0.9776   0.9897   0.9772
Specificity            0.9982   0.9986   0.9975   0.9979   0.9992   0.9990   0.9991   0.9986   0.9973   0.9986
Pos Pred Value         0.9838   0.9895   0.9787   0.9813   0.9928   0.9899   0.9916   0.9872   0.9757   0.9870
Neg Pred Value         0.9992   0.9993   0.9978   0.9986   0.9982   0.9988   0.9985   0.9974   0.9989   0.9974
Prevalence             0.0980   0.1135   0.1032   0.1010   0.0982   0.0892   0.0958   0.1028   0.0974   0.1009
Detection Rate         0.0973   0.1129   0.1012   0.0997   0.0966   0.0881   0.0944   0.1005   0.0964   0.0986
Detection Prevalence   0.0989   0.1141   0.1034   0.1016   0.0973   0.0890   0.0952   0.1018   0.0988   0.0999
Balanced Accuracy      0.9955   0.9967   0.9891   0.9925   0.9915   0.9933   0.9923   0.9881   0.9935   0.9879
Support Vector Machine object of class "ksvm" 

SV type: C-svc  (classification) 
 parameter : cost C = 5 

Gaussian Radial Basis kernel function. 
 Hyperparameter : sigma =  0.05 

Number of Support Vectors : 19242 

Objective Function Value : -79.3635 -295.5839 -254.1925 -189.0778 -300.4721 -294.4878 -187.1722 -279.1616 -228.9632 -203.1791 -136.4375 -151.8726 -122.0246 -117.3043 -239.7197 -219.4222 -156.0656 -489.7345 -296.2004 -301.1165 -287.7594 -404.2317 -484.9507 -297.6943 -225.1078 -624.5652 -221.2966 -310.5409 -587.4311 -392.6877 -247.076 -268.5886 -340.891 -320.8408 -703.6413 -377.7545 -226.5811 -526.3929 -344.577 -143.2523 -325.546 -183.5007 -296.3943 -631.2578 -437.8409 
Training error : 1e-04 

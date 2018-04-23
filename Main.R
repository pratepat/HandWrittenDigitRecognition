
############################ SVM Digit Recognition #################################
# 1. Business Understanding
# 2. Data Understanding
# 3. Data Preparation
# 4. Data Analysis 
# 5. Model Building 
#     5.1 Linear kernel
#     5.2 Poly Kernel
#     5.3 RBF Kernel
#     5.4 Hyperparameter tuning and Cross Validation
# 6. PCA
#     6.1 Linear and RBF model with PCA data
#     6.2 Hyperparameter tuning and Cross Validation
# 7. Final Conclusion

#Loading Neccessary libraries

library(kernlab)
library(readr)
library(caret)
library(ggplot2)
library(gridExtra)
library(caTools)
library(dplyr)
library(tictoc)

# Load the Data files

mnist_train <- read.csv("mnist_train.csv", stringsAsFactors = F,header = F)
mnist_test <- read.csv("mnist_test.csv", stringsAsFactors = F,header = F)

################ 1. Business Understanding: #############################################

# The objective is to develop a model using Support Vector Machine which should correctly 
# classify the handwritten digits based on the pixel values given as features.

################ 2. Data Understanding: #################################################

## Train dataset
dim(mnist_train)
# Number of Instances: 60,000
# Number of Attributes: 785 

## Test dataset
dim(mnist_test)
# Number of Instances: 20,000
# Number of Attributes: 785 

min(mnist_train)
max(mnist_train)

head(mnist_train)
head(mnist_test)

# The data varies from 0 to 255 hence we will have to normalize it

################ 3. Data Preparation: #################################################

# Rename dependent variable Digit to Digit

names(mnist_train)[1] <- "Digit"
names(mnist_test)[1] <- "Digit"

## checking missing value
sapply(mnist_train, function(x) sum(is.na(x)))
sapply(mnist_test, function(x) sum(is.na(x)))
# No NA values in the dataset

# Get the depenedent variable from the data
mnist_train.label <- mnist_train[1]
mnist_test.label <- mnist_test[1]

# Normalize the data 
# We will divide the entire dataset by max value i.e 255 to normalize it
mnist_train <- mnist_train[-1]
mnist_test <- mnist_test[-1]

mnist_train <- mnist_train/255
mnist_test <- mnist_test/255

mnist_train <- cbind(mnist_train.label,mnist_train)
mnist_test <- cbind(mnist_test.label,mnist_test)

#Converting the target to factor
mnist_train$Digit <-factor(mnist_train$Digit)
mnist_test$Digit <-factor(mnist_test$Digit)

################ 4. Data Analysis: ####################################################

theme_set(theme_classic())

ggplot(mnist_train, aes(Digit)) +
  geom_bar(width=.6, fill="tomato2") +
  labs(title = "Frequency of Digits", x = "Digits", y = "Frequency") +
  theme(axis.text = element_text(face="bold"))


# Lets view a few digits from the dataset
par(mfrow=c(3,3))
lapply(1:9, 
       function(x) image(
         matrix(unlist(mnist_train[x,-1]),nrow = 28,byrow = T),
         col=grey.colors(255),
         xlab=mnist_train[x,1]
       )
)

################ 5. Model building: ###################################################

## Remove columns with near to zero variance

# Combine the datasets to remaove the same columns from both sets
mnist_data <- rbind(mnist_train,mnist_test)

# Retrieve variables with near zero variance
nzv_cols <- nearZeroVar(mnist_data,freqCut = 98/2)

mnist_data <- mnist_data[,-nzv_cols]

mnist_train <- mnist_data[1:60000,]
mnist_test <- mnist_data[60001:70000,]

## The data is too large to run the SVM on whole data
## Hence taking a sample of 40% data
set.seed(100)
index <- sample.split(mnist_train$Digit,SplitRatio = 0.30)

mnist_sample <- mnist_train[index,]

ggplot(mnist_sample, aes(Digit)) +
  geom_bar(width=.6, fill="tomato2") +
  labs(title = "Frequency of Digits", x = "Digits", y = "Frequency") +
  theme(axis.text = element_text(face="bold"))

summary(factor(mnist_sample$Digit))
# The sample is balanced

## The label percentage remain nearly the same as the original dataset

#### 5.1 Linear Kernel
Model_linear <- ksvm(Digit~ ., data = mnist_sample, scaled = FALSE, kernel = "vanilladot")

Eval_linear <- predict(Model_linear, mnist_test[-1])
#confusion matrix - Linear Kernel
confusionMatrix(Eval_linear,mnist_test$Digit)
# Accuracy Linear Kernel : 0.9177 

#### 5.1 Ploy Kernel
Model_poly <- ksvm(Digit~ ., data = mnist_sample, scaled = FALSE, kernel = "polydot")

Eval_poly <- predict(Model_poly, mnist_test[-1])
#confusion matrix - Ploy Kernel
confusionMatrix(Eval_poly,mnist_test$Digit)
# Accuracy Ploy Kernel : 0.9177  

#### 5.3 RBF Kernel
Model_RBF <- ksvm(Digit~ ., data = mnist_sample, scaled = FALSE, kernel = "rbfdot")

Eval_RBF<- predict(Model_RBF, mnist_test[-1])

#confusion matrix - RBF Kernel
confusionMatrix(Eval_RBF,mnist_test$Digit)
# Accuracy RBF Kernel : 0.9654 

## Conclusion: RBF kernel is preferred over Linear as the accuracy is higher
## Both samples return near equal accuracy with RBF kernel

################ 6: PCA ###############################################################

## Perform PCA
pca = prcomp(mnist_train[-1])

pca$center
pca$scale

# compute standard deviation of each principal component
std_dev <- pca$sdev

# compute variance
pr_var <- std_dev^2

# proportion of variance explained
prop_varex <- pr_var/sum(pr_var)

par(mfrow=c(1,1))
# scree plot
plot(prop_varex, xlab = "Principal Component",
       ylab = "Proportion of Variance Explained",
       type = "b")

# cumulative scree plot
plot(cumsum(prop_varex), xlab = "Principal Component",
       ylab = "Cumulative Proportion of Variance Explained",
       type = "b")

## Conclusion : 40 Columns are able to explain more than 98.5% of the data

pca_train.data <- data.frame(mnist_train.label, pca$x)
pca_train.data <- pca_train.data[,1:40]

# transform test into PCA
pca_test.data <- predict(pca, newdata = mnist_test[-1])
pca_test.data <- as.data.frame(pca_test.data)

pca_test.data <- data.frame(mnist_test.label, pca_test.data)

# select the first 40 components
pca_test.data <- pca_test.data[,1:40]

# Convert dependent variable to factor
pca_test.data$Digit <- as.factor(pca_test.data$Digit)
pca_train.data$Digit <- as.factor(pca_train.data$Digit)

##### 6.1 Constructing Model on PCA data

##### Linear Kernel
pca.Model_linear <- ksvm(Digit~ ., data = pca_train.data, scaled = FALSE, kernel = "vanilladot")

pca.Eval_linear <- predict(pca.Model_linear, pca_test.data[-1])

#confusion matrix - Linear Kernel
confusionMatrix(pca.Eval_linear,pca_test.data$Digit)
# Accuracy PCA Linear Kernel: 0.9304 40 components

##### RBF Kernel
pca.Model_RBF <- ksvm(Digit~ ., data = pca_train.data, scaled = FALSE, kernel = "rbfdot")

pca.Eval_RBF<- predict(pca.Model_RBF, pca_test.data[-1])

#confusion matrix - RBF Kernel
confusionMatrix(pca.Eval_RBF,pca_test.data$Digit)

# Accuracy PCA RBF Kernel: 0.9784 40 components

##### 6.2 Hyperparameter tuning and Cross Validation with PCA data
pca.trainControl <- trainControl(method="cv", number=5)

# Metric <- "Accuracy" implies our Evaluation metric is Accuracy.
metric <- "Accuracy"

#Expand.grid functions takes set of hyperparameters, that we shall pass to our model.
grid <- expand.grid(.sigma=c(0.025, 0.05), .C=c(0.1,1,2,5) )

## Train the model
set.seed(100)
pca.fit.svm <- train(Digit~., data=pca_train.data, method="svmRadial", metric=metric, 
                 tuneGrid=grid, trControl=pca.trainControl)

print(pca.fit.svm)
# The final values used for the model were sigma = 0.05 and C = 5.

plot(pca.fit.svm)
# C = 5
# Sigma = 0.05

# Validating the model results on test data
pca.Eval_RBF_final <-predict(pca.fit.svm, pca_test.data[-1])

#confusion matrix - RBF Kernel
confusionMatrix(pca.Eval_RBF_final,pca_test.data$Digit)
# Accuracy : 0.9857 

################ 6: Conclusion ########################################################

# The final hyperparameters achieved both by running CV
# C = 5
# Sigma = 0.05

# The best model accuracy achieved was 98.57%
pca.fit.svm$finalModel

# Load necessary libraries
library(glmnet)
#library(caret)
library(stats)

# Load the data
cars_data <- read.csv("~/Downloads/Cars_Data.csv")

# Prepare the data
X <- as.matrix(cars_data[, -c(1, ncol(cars_data))]) # Excluding 'Brands' and 'Overall Preference'
y <- cars_data$Overall.Preference

#Elastistic Net
alpha_range <- seq(0, 1, by = 0.1)
best_alpha_EN <- NULL
best_mse_EN <- Inf
best_lambda_EN <- NULL
best_model_EN <- NULL
# Iterate over alpha values to find the best alpha and lambda
for (alpha in alpha_range) {
  set.seed(42)
  cv_model_EN <- cv.glmnet(X, y, alpha = alpha)
  if (min(cv_model_EN$cvm) < best_mse_EN) {
    best_mse_EN <- min(cv_model_EN$cvm)
    best_alpha_EN <- alpha
    best_lambda_EN <- cv_model_EN$lambda.min
    best_model_EN <- cv_model_EN
  }
}
cat("Best Alpha:", best_alpha_EN, "\n")
cat("Best Lambda:", best_lambda_EN, "\n")

# Coefficients plot for the best Elastic Net model
coef_plot_EN <- plot(best_model_EN$glmnet.fit, xvar = "lambda", label = TRUE)
abline(h = 0, col = 'black')
title(paste("Elastic Net Coefficients Plot - Best Alpha:", best_alpha_EN))

# MSE vs Lambda plot for the best Elastic Net model
mse_plot_EN <- plot(best_model_EN)
title(paste("MSE vs Lambda Plot - Best Alpha:", best_alpha_EN))

best_coefficients_EN <- coef(best_model_EN, s=best_lambda_EN)
best_coefficients_EN


#Lasso
out.lasso <- glmnet(X, y, alpha = 1)
cv.lasso <-  cv.glmnet(X, y, alpha = 1)  
# Plot Coefficients for the models:
plot(cv.lasso$glmnet.fit, xvar = "lambda", label = TRUE)
abline(h = 0, col = 'black')
#MSE vs Lambda Plots:
plot(cv.lasso)
cv.lasso$lambda.min
best_lasso_coefs <- coef(cv.lasso, s = "lambda.min")
best_lasso_coefs


#ridge
ridge_model <- glmnet(X, y, alpha = 0)
cv_ridge <-  cv.glmnet(X, y, alpha = 0)
# For Ridge plot Coefficients for the models:
plot(cv_ridge$glmnet.fit, xvar = "lambda", label = TRUE)
abline(h = 0, col = "black")
#MSE vs Lambda Plots:
plot(cv_ridge)
cv_ridge$lambda.min
best_ridge_coefs <- coef(cv_ridge, s = "lambda.min")
best_ridge_coefs

# run lm
significant_vars <- which(best_ridge_coefs[-1,] != 0 & best_lasso_coefs[-1,] != 0 & best_coefficients_EN[-1,] != 0)
# Use the significant variables to fit a linear model
final_model <- lm(y ~ ., data = data.frame(X[, significant_vars]))
summary(final_model)
#looking at the top three variables
coef<-final_model$coefficients
coef<-coef[-1]
abs_value<-abs(coef)
abs_value_sort<-sort(abs_value, decreasing = TRUE)
top3_names <- names(abs_value_sort)[1:3]
top3_names

#bias
library(tibble)
#top three attribute coefficients
coef<-final_model$coefficients
ridge_interesting<-best_ridge_coefs[6]
ridge_uncomfort<-best_ridge_coefs[8]
ridge_success<-best_ridge_coefs[14]
lasso_interesting<-best_lasso_coefs[6]
lasso_uncomfort<-best_lasso_coefs[8]
lasso_success<-best_lasso_coefs[14]
EN_interesting<-best_coefficients_EN[6]
EN_uncomfort<-best_coefficients_EN[8]
EN_success<-best_coefficients_EN[14]
lm_interesting<-coef[3]
lm_uncomfort<-coef[4]
lm_success<-coef[6]

#lasso
bias_lasso_interesting <- (lm_interesting - lasso_interesting) / lm_interesting
bias_lasso_uncomfort <- (lm_uncomfort - lasso_uncomfort) / lm_uncomfort
bias_lasso_successful <-  (lm_success - lasso_success) / lm_success
tibble("bias_lasso_interesting" = bias_lasso_interesting,
"bias_lasso_uncomfort" = bias_lasso_uncomfort,
"bias_lasso_successful" = bias_lasso_successful)
#ridge
bias_ridge_interesting <- (lm_interesting - ridge_interesting) / lm_interesting
bias_ridge_uncomfort <- (lm_uncomfort - ridge_uncomfort) / lm_uncomfort
bias_ridge_successful <-  (lm_success - ridge_success) / lm_success
tibble("bias_ridge_interesting" =bias_ridge_interesting,
"bias_ridge_uncomfort" = bias_ridge_uncomfort,
"bias_ridge_successful" = bias_ridge_successful)
#EN
bias_EN_interesting <- (lm_interesting - EN_interesting) / lm_interesting
bias_EN_uncomfort <- (lm_uncomfort - EN_uncomfort) / lm_uncomfort
bias_EN_successful <-  (lm_success - EN_success) / lm_success
tibble("bias_EN_interesting" =  bias_EN_interesting,
"bias_EN_uncomfort" = bias_EN_uncomfort,
"bias_EN_successful" = bias_EN_successful)

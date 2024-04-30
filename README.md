# Car-Preferences-Shrinkage-Analysis

Project Overview  
This project utilizes Shrinkage Regression techniques—Ridge, Lasso, and Elastic Net—to analyze the impact of various attributes on car preferences when the number of predictors exceeds the number of observations. The goal is to identify the top attributes that significantly influence consumer preferences towards car brands, focusing on finding the best model parameters and assessing the importance of each attribute in the models.

Features  
Multiple Regression Models: Implements Ridge, Lasso, and Elastic Net regressions to evaluate attribute significance with varying levels of penalty (alpha) and complexity (lambda).  
Optimal Parameter Selection: Determines the best alpha and lambda values through a systematic analysis involving mean squared error (MSE) across different model configurations.  
Attribute Importance: Identifies and ranks the top three attributes influencing car preferences based on the strength and consistency of their coefficients across different models.  
Coefficient and MSE Visualization: Provides visualizations of coefficients and MSE versus lambda plots for each regression model, highlighting how changes in lambda influence model performance and attribute selection.  
Bias Calculation: Computes the bias of estimated parameters from the shrinkage methods relative to ordinary least squares (OLS) estimates, helping to evaluate model accuracy and reliability.  

Purpose  
The purpose of this project is to apply advanced regression techniques to a real-world problem where multicollinearity and high dimensionality pose significant challenges. By identifying key attributes that drive consumer preferences and quantifying the impact of regularization on model performance, this analysis aids in strategic decision-making for product development and marketing.

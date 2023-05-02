#R-Script for Assignment

#Loading Libraries to plot statistics & Tests
library(readxl)
library(car)
library(lmtest)
library(GGally)
library(olsrr)

#Loading data
AE_Data <- read_excel("C:\\Users\\arjun\\Documents\\BITS\\3-2\\Applied Econometrics\\Assignment\\Assignment1 Final\\Ae Assignment (1).xlsx", sheet = "Reg Data")
View(AE_Data)

#Initializing Variables
Country = AE_Data$Country
GDPC_ln = log(AE_Data$GDPPC)
HEX_ln = log(AE_Data$HEX)
FDI = AE_Data$FDI
REF_ln = log(AE_Data$RefP)
RefP = AE_Data$RefP
Trade = AE_Data$Trade
UP = AE_Data$UP
GNIPC = AE_Data$GNIPC
LF = AE_Data$LF
DEFEX = AE_Data$DEXP
MMR = AE_Data$MMR
LE = AE_Data$LFEXP


#Initializing Categorical Variables on the basis of Income
IG = 0
IG[GNIPC <= 1085] = 1
IG[GNIPC >= 1086 & GNIPC <= 4255 ] = 2
IG[GNIPC >= 4256 & GNIPC <= 13205] = 3
IG[GNIPC > 13205] = 4

#Creating Data frame 
ModelData <- data.frame(Country,HEX_ln,GDPC_ln,FDI,REF_ln,Trade,UP,GNIPC,LF,DEFEX,MMR,LE,RefP)
head(ModelData)

#Binding frame 
cbind(ModelData,IG)
head(ModelData)

#Plotting Correlation between independent variables
pairs(ModelData[,3:12],pch=19, lower.panel = NULL)


#Plotting Correlation between independent variables with the Pearson coefficients 
X <-ModelData[,3:12]
ggpairs(X)

#Fitting original model with Health Expenditure as the Dependent variable 
Model1 <- lm(HEX_ln ~ GDPC_ln + RefP + UP + LF + DEFEX + MMR + LE, data = ModelData)
summary(Model1)

#Breusch Pagan Test for the first model to test heteroskedasticity
bptest(Model1)


#Testing for Joint Significance of variables
Model1r <- lm(HEX_ln ~ 1)
summary(Model1r)
anova(Model1, Model1r)

#Testing for MultiCollinearity
vif(Model1)

#Plotting for normality of residuals 

#QQ Plot
ols_plot_resid_qq(Model1)
#Normality of Data SWILK
ols_test_normality(Model1)
#Fitted vs Actual Residual plot
ols_plot_resid_fit(Model1)
#Residual Histogram
ols_plot_resid_hist(Model1)

#testing for alternative functional forms

resettest(Model1, power = 2:3, type = "regressor")


#Fitting a model including a categorical variable for Income group
Model2 <- lm(HEX_ln ~ RefP + UP + LF + DEFEX + MMR + LE + factor(IG), data = ModelData)
summary(Model2)

#Breusch Pagan Test for the first model to test heteroskedasticity
bptest(Model2)

#Testing for Multicollinearity
vif(Model2)


#Plotting for normality of residuals
#QQ Plot
ols_plot_resid_qq(Model2)
#Normality of Data SWILK
ols_test_normality(Model2)
#Fitted vs Actual Residual plot
ols_plot_resid_fit(Model2)
#Residual Histogram
ols_plot_resid_hist(Model2)


#testing for alternative functional forms
resettest(Model2, power = 2:3, type = "regressor")

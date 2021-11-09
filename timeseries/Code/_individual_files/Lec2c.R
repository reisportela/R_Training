# Data Analysis School
# Course 8/  FORECASTING METHODS AND APPLICATIONS WITH R
# by Cristina Amado / UMinho
# November 2020
# https://www.gades-solutions.com/project/data-analysis-school/

rm(list=ls())

setwd("/Users/miguelportela/Documents/GitHub/R_Training/time_series")

library(tidyverse)
library(ggplot2)
library(forecast)
library(foreign)

download.file('http://fmwww.bc.edu/ec-p/data/wooldridge/hprice1.dta','hprice1.dta',mode='wb')
hprice <- read.dta('hprice1.dta')

#Some statistics
summary(hprice)
cor(hprice)
cor(hprice$price,hprice$sqrft)
#OLS estimation single regression
lm.r <- lm(price ~ sqrft, data = hprice)
summary(lm.r)
#Residuals
resid(lm.r) #lm.r$res 
#Predicted values
fitted(lm.r) #lm.r$fit 
#Scatterplot with fitted line
plot(price ~ sqrft, hprice)
abline(lm.r) 
plot(lm.r$res ~ sqrft, hprice)
#Regression with logs between lprice and lsqrft
lm.r4 <- lm(lprice ~ lsqrft, data = hprice)
summary(lm.r4)
plot(lm.r4$res ~ lsqrft, hprice)
plot(lprice ~ lsqrft, hprice)
abline(lm.r4)
#Regression with logs between lprice and lassess
lm.r5 <- lm(lprice ~ lassess, data = hprice)
summary(lm.r5)
plot(lm.r5$res ~ lassess, hprice)
plot(lprice ~ lassess, hprice)
abline(lm.r5)
#Confidence intervals for the coefficients
confint(lm.r5,level=0.95)
#Prediction interval for a single observation
plot(lprice ~ lassess, hprice)
abline(lm.r5)

newdata = data.frame(lassess=250)
lines(newdata,con.1[,c("lwr","upr")],col="red",lty=1,type="l")
newdata = data.frame(lassess=250)

#Interval estimate on the mean at a specific point
con.1 <- predict(lm.r5, newdata, level = 0.90, interval="confidence")
#Interval estimate on a single future observation
pred.1 <- predict(lm.r5, newdata, level = 0.90, interval="predict")
lines(newdata,pred.1[,c("lwr","upr")],col="blue",lty=1,type="l")
#Plot prediction interval 
conf.2 <- predict(lm.r5, level = 0.95, interval="confidence")
pred.2 <- predict(lm.r5, level = 0.95, interval="predict")
fitted = pred.2[,1]
pred.lower = pred.2[,2]
pred.upper = pred.2[,3]
plot(lprice ~ lassess, hprice)
lines(hprice$lassess,fitted,col="red",lwd=2)
lines(hprice$lassess,pred.lower,lwd=1,col="blue")
lines(hprice$lassess,pred.upper,lwd=1,col="blue")

#OLS estimation multiple regression
lm.r2 <- lm(price ~ sqrft + bdrms, data = hprice)
summary(lm.r2)
#OLS estimation multiple regression
lm.r3 <- lm(lprice ~ lsqrft + llotsize, data = hprice)
summary(lm.r3)

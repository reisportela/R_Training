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

download.file('http://fmwww.bc.edu/ec-p/data/wooldridge/wage1.dta','wage1.dta',mode='wb')
wage <- read.dta('wage1.dta')
fit.r <- lm(lwage ~ educ + exper, data = wage)
summary(fit.r)

plot(fit.r$res ~ educ, wage)
plot(lwage ~ educ, wage)
abline(fit.r)
#Coefficients
fit.r$coef #(or coef(fit.r))
#Residuals
fit.r$res 
#Predicted values
fit.r$fit 
#Prediction interval for a single observation
newdata = data.frame(educ=12, exper=5)
#Interval estimate on the mean at a specific point
predict(fit.r, newdata, level = 0.95, interval="confidence")
#Interval estimate on a single future observation
predict(fit.r, newdata, level = 0.95, interval="predict")

#Prediction interval for several observations
neweduc=c(12,15,16)
newexper=c(5,7,10)
predict(fit.r,data.frame(educ = neweduc,exper=newexper), 
        level = 0.95, interval = "predict")

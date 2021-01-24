# Data Analysis School
# Course 8/  FORECASTING METHODS AND APPLICATIONS WITH R
# by Cristina Amado / UMinho
# November 2020
# https://www.gades-solutions.com/project/data-analysis-school/

rm(list=ls())

setwd("/Users/miguelportela/Documents/GitHub/R_Training/time_series")

library(foreign)
library(haven)
library(tidyverse)
library(ggplot2)
library(forecast)
library(fma)


#Dow Jones Index

##data("dj", package = "fma")

#Check (non)stationarity
plot(dj)
acf(dj)
pacf(dj)
#Augmented Dickey-Fuller
#Augmented Dickey Fuller test
#install.packages(urca)
library(urca)
adf=ur.df(dj,type="none",lags=1)
summary(adf)
#adf.test(dj)
retdj <- diff(log(dj))
plot(retdj)
acf(retdj)
pacf(retdj)
#ARIMA(0,1,0)
dj.ar1 <- arima(dj, c(0, 1, 0))
summary(dj.ar1) #
acf(residuals(dj.ar1))
Box.test(residuals(dj.ar1), lag=20, fitdf=0, type="Ljung")
tsdiag(dj.ar1) 
plot(forecast(dj.ar1)) #
#AR(1)
dj_ar1 <- arima(dj, c(1, 0, 0))
summary(dj_ar1)
acf(residuals(dj_ar1))
Box.test(residuals(dj_ar1), lag=20, fitdf=1, type="Ljung")
tsdiag(dj_ar1) 
plot(forecast(dj_ar1))
pred.2 <- predict(dj_ar1, level = 0.95, interval="predict")
pred.2
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
library(fma)

#Dow-Jones index on 292 trading days ending 26 Aug 1994
# data("dj",package = "fma")

plot(dj)

#Use 250 observations in the in-sample period
dj1 <- window(dj, end=250)
plot(dj1)
#Out-of-sample period from 251 until 292
dj2 <- window(dj, start=251)
#80% and 95% forecast interval: level=c(80,95)
djfor1 <- meanf(dj1, h=42)
plot(djfor1, main="mean")
djfor2 <- naive(dj1, h=42)
plot(djfor2, main="naive")
djfor3 <- snaive(dj1, h=42)
plot(djfor3, main="snaive")
djfor4 <- rwf(dj1, drift=TRUE, h=42)
plot(djfor4, main="drift")
#measures of forecast accuracy
accuracy(meanf(dj1,h=42), dj2)
accuracy(naive(dj1,h=42), dj2)
accuracy(snaive(dj1,h=42), dj2)
accuracy(rwf(dj1,drift=TRUE,h=42), dj2)

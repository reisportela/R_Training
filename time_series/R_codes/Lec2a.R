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

#Monthly Australian beer production: Jan 1991 - Aug 1995
# data("beer", package = "fma")

plot(beer,type = "l")

#80% and 95% forecast interval: level=c(80,95)
beerfor1 <- meanf(beer, h=12)
plot(beerfor1, main="mean")
beerfor2 <- naive(beer, h=12)
plot(beerfor2, main="naive")
beerfor3 <- snaive(beer, h=12)
plot(beerfor3, main="snaive")
beerfor4 <- rwf(beer, drift=TRUE, h=12)
plot(beerfor4, main="drift")
#plot(forecast(beerfor4,level=c(80,95)))
summary(beerfor1)
summary(beerfor2)
accuracy(beerfor1)
accuracy(beerfor2)
accuracy(beerfor3)
accuracy(beerfor4)

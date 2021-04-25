# Data Analysis School
# Course 8/  FORECASTING METHODS AND APPLICATIONS WITH R
# by Cristina Amado / UMinho
# November 2020
# https://www.gades-solutions.com/project/data-analysis-school/

rm(list=ls())

setwd("/Users/miguelportela/Documents/GitHub/R_Training/time_series")

# install.packages("TSA")

library(tidyverse)
library(ggplot2)
library(TSA)
library(tseries)
library(xlsx)
library(fma)
library(forecast)

#data: gold, tempdub, sales, google, oil.price, wages, larain
# data("beer",package="fma")

plot(beer,type = "l")

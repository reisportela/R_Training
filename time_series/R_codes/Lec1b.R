# Data Analysis School
# Course 8/  FORECASTING METHODS AND APPLICATIONS WITH R
# by Cristina Amado / UMinho
# November 2020
# https://www.gades-solutions.com/project/data-analysis-school/

rm(list=ls())

setwd("/Users/miguelportela/Documents/GitHub/R_Training/time_series")

library(tidyverse)
library(ggplot2)
library(TSA)
library(tseries)
library(xlsx)
library(gdata)
library(readxl)
library(fma)
library(lmtest)

data(wages)

plot(wages,type = "l")

mydata <- read.xls("sunspot.xlsx", 1)
#mydata2 = read.xls ("sunspot.xlsx", sheet = 1, header = TRUE)

# print(mydata)

sunspot <- as.ts(mydata$Sunspot)
postscript(file="sunspot.eps", paper="special", width=10, height=7, horizontal=FALSE) 
plot(sunspot ~ Year, mydata, type = "l")

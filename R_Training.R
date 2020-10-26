## R Training
## MPortela -- U Minho
## October 2020

# https://nbviewer.jupyter.org/github/jhconning/Dev-II/blob/master/notebooks/Stata_in_jupyter.ipynb

rm(list = ls())

setwd("~/Documents/GitHub/R_Training/logs")

##setwd("~/capsule/results")

# setwd("/Users/miguelportela/Dropbox/1.miguel/1.formacao/r/practice")

## Exercise

library(haven)

wages <- read_dta("../data/WAGE1.DTA")

attach(wages)

summary(wages)

plot(educ,wage)

ols1 <- lm(wage ~ educ)
summary(ols1)

# Data Analysis: 2021
# REGRESSION ANALYSIS AND CAUSALITY WITH R | By: Joao Cerejeira & Miguel Portela

setwd("C:\\Users\\mangelo.EEG\\Documents\\GitHub\\R_Training\\regression")

rm(list = ls())

## DATA
library(haven)

  world_data <- as.data.frame(read_dta("data/world_data.dta"))

## REGRESSION

  M1 <- lm(data = world_data, growthGDPpc ~ logGDPpc2000 + educ_sec + invest_growth + trade2000 + gov2000,na.action = na.exclude)
  
    summary(M1)

## VCE Estimates

print(vcov(M1))

## Output table

library(stargazer)
stargazer(M1,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("Model 1"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,covariate.labels = c("Log GDPpc 2000","Educ Sec"),
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 2,
          digits.extra = 4,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")

M2 <- lm(data=world_data, growthGDPpc ~ logGDPpc2000 + educ_sec + invest_growth + educ_sec:invest_growth + trade2000 + gov2000)
M3 <- lm(data=world_data, growthGDPpc ~ logGDPpc2000 + educ_sec * invest_growth + trade2000 + gov2000)

## model without constant

M0 <- lm(data=world_data, growthGDPpc ~ 0 + educ_sec)

stargazer(M0,M1,M2,M3,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("Model 1","Model 2","Model 3","Model 4"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          covariate.labels = c("Log GDPpc 2000","Educ Sec"),
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 2,
          digits.extra = 4,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")


## Further statistics

library(dplyr)

### CORRELATION

data()
data("CigaretteDemand")

  corr <- round(cor(CigaretteDemand),2)
  corr

### Normality test

shapiro.test(CigaretteDemand$salestax)

# Data Analysis: 2021
# REGRESSION ANALYSIS AND CAUSALITY WITH R | By: João Cerejeira

rm(list = ls())

setwd("C:\\Users\\mangelo.EEG\\Documents\\GitHub\\R_Training\\regression")

# <<>> ----- <<>> #

# install.packages('kableExtra')

## LIBRARIES

  library(tidyverse)
  library(ggplot2)
  library(haven)
  library(stargazer)
  library(SmartEDA)
  library(MatchIt)
  library(RItools)

## DATA

  hh_98 <- as.data.frame(read_dta("hh_98.dta"))

  hh_98$lexptot <- log(1+hh_98$exptot)
  hh_98$lnland <- log(1+hh_98$hhland/100)
  
  attach(hh_98)
  
# str(hh_98)
# summary(hh_98)

ExpData(hh_98,type = 1)
ExpData(hh_98,type = 2)
stargazer(hh_98,
          title = "Summary statistics",
          label = "tb:statistcis",
          table.placement = "ht",
          header=FALSE,type="text")

# ExpNumStat(hh_98,by="A",Outlier = TRUE,round=2,Qnt=c(0.1,0.20,0.50))

## ANALYSIS

glm1 <- glm(dfmfd ~ lexptot, family=binomial, data=hh_98)

stargazer::stargazer(glm1,type="text",single.row = TRUE)

## PSM nearest neighbor

psm_nn <- matchit(dfmfd ~ lexptot, data = hh_98, caliper=0.1, method ="nearest")

summary(psm_nn)

# <<>> ----- <<>> #

# Using materials from Jose M. Fernandez, Matching Models
# http://rpubs.com/cuborican/Matching

## DATA
data(lalonde)

lalonde$race.f <- factor(lalonde$race)
is.factor(lalonde$race.f)

lalonde.formu <- treat~age + educ + race.f + married + nodegree + re74 + re75
glm1 <- glm(lalonde.formu, family=binomial, data=lalonde)

stargazer::stargazer(glm1,type="text",single.row = TRUE)

## Mahalanobis Metric Matching

 m.mahal<-matchit(lalonde.formu,data=lalonde,
                  mahvars=c("age","educ","nodegree","re74","re75"),
                  replace=FALSE,caliper=0.25)

## Get matched Data
  
  mahal.match<-match.data(m.mahal)

## PSM nearest neighbor

  m.nn<-matchit(lalonde.formu, data = lalonde, caliper=0.1, method ="nearest")

## m.nn<-matchit(lalonde.formu, data = lalonde, ratio=1, method ="nearest")
  
  nn.match<-match.data(m.nn)

## Unconditional

  xBalance(lalonde.formu, data = lalonde, report=c("chisquare.test"))

## Nearest Neighbor
  xBalance(lalonde.formu, data = as.data.frame(nn.match), report=c("chisquare.test"))

  reg.1 <- lm(re78~treat+age+educ+nodegree+re74+re75+married+race.f,data=lalonde)
  reg.2 <- lm(re78~treat+age+educ+nodegree+re74+re75+married+race.f,data=nn.match)
  reg.3 <- lm(re78~treat+age+educ+nodegree+re74+re75+married+race.f,data=mahal.match)
  reg.2a <- lm(re78~treat,data=nn.match)
  reg.3a <- lm(re78~treat,data=mahal.match)

    matches <- data.frame(m.nn$match.matrix)

# Separate the data into treatment and control
  
  group1<-match(row.names(matches),row.names(nn.match))
  group2<-match(matches$X1,row.names(nn.match))
  
  yT<-nn.match$re78[group1]
  yC<-nn.match$re78[group2]

# bind matched cases

  # --> matched.cases<-cbind(matches,yT,yC)

# Paired T-test

  # --> t.test(matched.cases$yT,matched.cases$yC,paired=TRUE)

  plot(m.nn, type="jitter")

# We will use our estimated pscores

  lalonde$psvaluea<-predict(glm1,type="response")
  lalonde$gweight<-ifelse(lalonde$treat==1,1/lalonde$psvaluea,1/(1-lalonde$psvaluea))
  reg.4<-lm(re78~treat+age+educ+nodegree+re74+re75+married+black+hispan,
            data=lalonde, weights = gweight)
  
  summary(lm(re74~treat, data=lalonde, weights = gweight))

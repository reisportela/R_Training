# Applied Data Analysis School: October/november 2020
# 6. REGRESSION ANALYSIS AND CAUSALITY WITH R | By: JoÃ£o Cerejeira | 10 & 12 November
# https://www.gades-solutions.com/project/data-analysis-school/

# Using materials from Jose M. Fernandez, Matching Models
# http://rpubs.com/cuborican/Matching

rm(list = ls())

setwd("C:\\Users\\mangelo.EEG\\Documents\\GitHub\\R_Training\\regression")

library(MatchIt); data(lalonde)
lalonde.formu <- treat~age + educ + black + hispan + married + nodegree + re74 + re75
glm1 <- glm(lalonde.formu, family=binomial, data=lalonde)
stargazer::stargazer(glm1,type="text",single.row = TRUE)

## Mahalanobis Metric Matching
m.mahal<-matchit(lalonde.formu,data=lalonde,
                 mahvars=c("age","educ","nodegree","re74","re75"),
                 replace=FALSE,distance="mahalanobis",caliper=0.25)

## Get matched Data
mahal.match<-match.data(m.mahal)

## PSM nearest neighbor
m.nn<-matchit(lalonde.formu, data = lalonde, caliper=0.1, method ="nearest")

## m.nn<-matchit(lalonde.formu, data = lalonde, ratio=1, method ="nearest")
nn.match<-match.data(m.nn)

library(RItools)

## Unconditional
xBalance(lalonde.formu, data = lalonde, report=c("chisquare.test"))

## Nearest Neighbor
xBalance(lalonde.formu, data = as.data.frame(nn.match), report=c("chisquare.test"))

reg.1<-lm(re78~treat+age+educ+nodegree+re74+re75+married+black+hispan,data=lalonde)
reg.2<-lm(re78~treat+age+educ+nodegree+re74+re75+married+black+hispan,data=nn.match)
reg.3<-lm(re78~treat+age+educ+nodegree+re74+re75+married+black+hispan,data=mahal.match)
reg.2a<-lm(re78~treat,data=nn.match)
reg.3a<-lm(re78~treat,data=mahal.match)

matches<-data.frame(m.nn$match.matrix)

# Separate the data into treatment and control
group1<-match(row.names(matches),row.names(nn.match))
group2<-match(matches$X1,row.names(nn.match))

yT<-nn.match$re78[group1]
yC<-nn.match$re78[group2]

# bind matched cases
matched.cases<-cbind(matches,yT,yC)

# Paired T-test
t.test(matched.cases$yT,matched.cases$yC,paired=TRUE)

plot(m.nn, type="jitter")

# We will use our estimated pscores
lalonde$psvaluea<-predict(glm1,type="response")
lalonde$gweight<-ifelse(lalonde$treat==1,1/lalonde$psvaluea,1/(1-lalonde$psvaluea))
reg.4<-lm(re78~treat+age+educ+nodegree+re74+re75+married+black+hispan,
          data=lalonde, weights = gweight)

summary(lm(re74~treat, data=lalonde, weights = gweight))


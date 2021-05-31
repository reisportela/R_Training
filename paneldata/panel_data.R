# Applied Data Analysis School: October/november 2020
# 7. PANEL DATA MODELS WITH R | By: Miguel Portela and Anabela Carneiro | 17 & 19 November
# https://www.gades-solutions.com/project/data-analysis-school/
# NOTES: check
# https://bookdown.org/ccolonescu/RPoE4/
# https://cran.r-project.org/web/packages/plm/vignettes/plmPackage.html

setwd("C:\\Users\\mangelo.EEG\\Documents\\GitHub\\R_Training\\paneldata")
#setwd("C:\\Users\\exu0o9\\Documents\\GitHub\\R_Training\\paneldata")

# setwd("~/Documents/GitHub/R_Training/paneldata/")

# WHEN USING MYBINDER DEFINE
# setwd("/home/jovyan/paneldata")

rm(list = ls())

# LOG FILE

# sink("Regression.txt")

##################################      

# LIBRARIES

library(pacman)

library(tidyverse) # Modern data science library 
library(haven)

pacman::p_load(stargazer,
               kableExtra,
               ExPanDaR,
               SmartEDA,
               visdat,
               naniar,
               janitor,
               summarytools,
               plm,
               lfe,
               fixest,
               clubSandwich,
               car,
               gplots,
               tseries,
               lmtest,
               dlookr,
               MASS,
               robustbase,
               sandwich,
               broom,
               pdynmc)

# DATA

nlswork <- read_dta("nlswork.dta")

# View(world_data)

# names(nlswork)
# head(nlswork)
# str(nlswork)
# dplyr::glimpse(world_data)

dplyr::glimpse(nlswork$ln_wage)

ExpData(nlswork,type=1)

ExpData(nlswork,type=2)

# STATISTICS

## EDA: Exploratory Data Analysis

# eda_report(world_data,output_dir = "EDA/",output_file = "eda_nlswork.pdf")

summary(nlswork[,"grade"])

ExpNumStat(nlswork,by="A",Outlier = TRUE,round=2,Qnt=c(0.1,0.20,0.50))

# ExpCTable(nlswork)

ExpCatViz(nlswork)

ExpNumViz(nlswork,Page=c(6,2))

## TRY IN A 'JUPYTER NOTEBOOK': ExpNumViz(nlswork)

# ExpNumViz(nlswork)

# ExpOutliers(nlswork,varlist=c("grade"))

vis_dat(nlswork)

# vis_miss(nlswork) # ALTERNATIVE

gg_miss_upset(nlswork)

## ExPanD(): import the data 'nlswork.dta' and 'ExPanD()' in the Console

summary(nlswork)

stargazer(nlswork,
          title = "Summary statistics",
          label = "tb:statistcis",
          table.placement = "ht",
          header=FALSE)

## or

stargazer(nlswork,
          title = "Summary statistics",
          label = "tb:statistcis",
          table.placement = "ht",
          header=FALSE,type="text")

## or a subset of variables

nlswork %>%
  dplyr::select(ln_wage,grade) %>% 
  stargazer(title="Shorter statistics",
            label="tb:statistics:short",
            table.placement = "ht",
            header=FALSE,
            type="text")

plot(nlswork$grade,nlswork$ln_wage)

## FIRST CHECK OF THE RELATIONSHIP BETWEEN EDUCATION AND GDP

nlswork %>%
  ggplot(aes(grade,ln_wage)) +
  labs(title = "Ln Wage vs. Grade") +
  ylab("Ln Wage") +
  xlab("Grade") +
  geom_point()

## SAVE YOUR GRAPH

ggsave("figures/graph1.png")

## -- TABULATIONS -- ##

tabyl(nlswork$race, sort = TRUE)

summarytools::freq(nlswork$year, order = "freq")
summarytools::freq(nlswork$race, order = "freq")

# *drop missing values*

nlswork_clean <-  drop_na(subset(nlswork,select = c(idcode, year, ln_wage, union, collgrad, age, tenure, not_smsa, south, c_city)))

# *Create new variables*

nlswork_clean$agesq <- nlswork_clean$age^2
nlswork_clean$tensq <- nlswork_clean$tenure^2

ExpData(nlswork_clean,type=1)
ExpData(nlswork_clean,type=2)

nlswork_clean <- nlswork_clean[order(idcode,year),]

attach(nlswork_clean)

## REGRESSION ANALYSIS

# Exploratory Data Analysis

# coplot(ln_wage ~ year|idcode,type="b",data = nlswork_clean)
# scatterplot(ln_wage ~ year|idcode,data = nlswork_clean)

plotmeans(ln_wage ~ year ,data = nlswork_clean)

# *Estimating a Mincerian Wage Equation*

# *POLS estimator with cluster-robust standard errors*

# *Q1*
# Pooled OLS model

ols <- lm(data = nlswork_clean, ln_wage ~ union +
            collgrad +age +agesq +tenure +tensq +
            not_smsa +south +c_city)
summary(ols)

pols <- plm(data = nlswork_clean, ln_wage ~ union +
              collgrad +age +agesq +tenure +tensq +
              not_smsa +south +c_city, model="pooling", index=c("idcode", "year"))
summary(pols)

stargazer(ols,pols,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("OLS","Pooled"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          covariate.labels = c("Union","Collage Graduate","Age","Age sqrd.","Tenure","Tenure sqrd.","Not SMSA","South","City"),
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 3,
          digits.extra = 5,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")

# CLUSTERED Standard-errors

pols_robust <- coeftest(pols, function(x) vcovHC(x, type = 'sss')) 

stargazer(pols,pols_robust,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("Pooled","Pooled (cluster)"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          covariate.labels = c("Union","Collage graduate","Age","Age sqrd.","Tenure","Tenure sqrd.","Not SMSA","South","City"),
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 6,
          digits.extra = 7,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")

# // Final slide 20
# *Q2*
#   
#   *Random effects estimator (RE)*

# SEE THE DISCUSSION HERE for the comparison between R and Stata
# https://stats.stackexchange.com/questions/421374/different-results-from-random-effects-plm-r-and-xtreg-stata
# R and Stata treat differently unbalanced panels

# for a balanced panel we have

nlswork_balanced <- read_dta("nlswork_balanced.dta")

re_balanced <- plm(data = nlswork_balanced, ln_wage ~ union +
                     collgrad +age +agesq +tenure +tensq +
                     not_smsa +south +c_city, model="random",
                   index=c("idcode", "year"))
summary(re_balanced)

re <- plm(data = nlswork_clean, ln_wage ~ union +
            collgrad +age +agesq +tenure +tensq +
            not_smsa +south +c_city, model="random",
          index=c("idcode", "year"))
summary(re)

re_robust <- coeftest(re, function(x) vcovHC(x, type = 'sss')) 

stargazer(pols,pols_robust,re,re_robust,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("Pooled","Pooled (cluster)","RE","RE (cluster"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          covariate.labels = c("Union","College Graduate","Age","Age sqrd.","Tenure","Tenure sqrd.","Not SMSA","South","City"),
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 3,
          digits.extra = 5,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")

# *LM test for the presence of unobserved effects*

plmtest(pols, type=c("bp"))

kable(tidy(plmtest(pols, type=c("bp"))), format = "simple",caption=
        "LM test for the presence of unobserved effects")

# //Final slide 32
# 
# *Q3*
#   
#   *Fixed effects estimator (FE)*

fe <- plm(data = nlswork_clean, ln_wage ~ union +
            collgrad +age +agesq +tenure +tensq +
            not_smsa +south +c_city, model="within", index=c("idcode", "year"))
summary(fe)

stargazer(fe,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("FE"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          covariate.labels = c("Union","Age","Age sqrd.","Tenure","Tenure sqrd.","Not SMSA","South","City"),
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 6,
          digits.extra = 7,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")

# Testing for fixed effects, null: OLS better than fixed
# 'F test for individual effects' <<==>> 'F test that all u_i=0'

ols_0 <- lm(data = nlswork_clean, ln_wage ~ union +
              age +agesq +tenure +tensq +
              not_smsa +south +c_city)
summary(ols_0)

pFtest(fe, ols_0)

# generate fixed-effects

# nlswork_clean$specific_effects <- fixef(fe)

# *Q3.1*

fe_robust <- coeftest(fe, function(x) vcovHC(x, type = 'sss')) 

stargazer(ols_0,fe,fe_robust,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("OLS","FE","FE (cluster)"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          covariate.labels = c("Union","Age","Age sqrd.","Tenure","Tenure sqrd.","Not SMSA","South","City"),
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 6,
          digits.extra = 7,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")

# *Q3.2*

linearHypothesis(ols,c("age=0","agesq=0"))
linearHypothesis(ols,c("age=0","agesq=0"), white.adjust = "hc1")

Wald_test(fe, vcov = "CR1", cluster = idcode, constraints = constrain_zero(c("age","agesq")), test = "Naive-F")


# *LSDV Estimator=FE estimator* <<==>> takes too long
# *using a smaller sample*

nlswork_balanced <- read_dta("nlswork_balanced_small.dta")

LSDV <- lm(data = nlswork_balanced, ln_wage ~ union +
             age +agesq +tenure +tensq +
             not_smsa +south +c_city + factor(idcode))
summary(LSDV)

fe_LSDV <- plm(data = nlswork_balanced, ln_wage ~ union +
            age +agesq +tenure +tensq +
            not_smsa +south +c_city, model="within", index=c("idcode", "year"))
summary(fe_LSDV)

stargazer(LSDV,fe_LSDV,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("LSDV","FE"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          covariate.labels = c("Union","Age","Age sqrd.","Tenure","Tenure sqrd.","Not SMSA","South","City"),
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 6,
          digits.extra = 7,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")


# //Final slide 35
# 
# *Q4*
#   *Hausman test*

fe_0 <- plm(data = nlswork_clean, ln_wage ~ union +
              age +agesq +tenure +tensq +
              not_smsa +south +c_city, model="within", index=c("idcode", "year"))
re_0 <- plm(data = nlswork_clean, ln_wage ~ union +
              age +agesq +tenure +tensq +
              not_smsa +south +c_city, model="random", index=c("idcode", "year"))

phtest(fe_0, re_0)    

#   //Final slide 46
# 
# *Q5*
#   *BE estimator

be <- plm(data = nlswork_clean, ln_wage ~ union +
            collgrad +age +agesq +tenure +tensq +
            not_smsa +south +c_city, model="between",
          index=c("idcode", "year"))
summary(be)

# //Final slide 53
# 
# *Q6*
#   *FD estimator*

fd <- plm(data = nlswork_clean, ln_wage ~ 0 + union +
            collgrad +age +agesq +tenure +tensq +
            not_smsa +south +c_city, model="fd",
          index=c("idcode", "year"))
summary(fd)

# *Output Table*

stargazer(pols,re,fe,be,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("OLS","RE","FE","BE"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 6,
          digits.extra = 7,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")



# *FURTHER SPECIFICATION TESTS FOR PANEL DATA*
#   
#   // # Test for heteroskedasticity within panel data
#   

# H0) The null hypothesis for the Breusch-Pagan test is homoskedasticity

# takes too long to compute

# bptest(data = nlswork_clean, ln_wage ~ union +
#          collgrad +age +agesq +tenure +tensq +
#          not_smsa +south +c_city + factor(idcode), studentize=F)


bptest(data = nlswork_balanced, ln_wage ~ union +
         collgrad +age +agesq +tenure +tensq +
         not_smsa +south +c_city + factor(idcode), studentize=F)



# // # Test of serial correlation within panel data

# Unobserved effects test <<>> Wooldridge's test for unobserved individual effects <<>>

pwtest(data = nlswork_clean, ln_wage ~ union +
         collgrad +age +agesq +tenure +tensq +
         not_smsa +south +c_city)

# Locally robust tests for serial correlation or random effects <<>> Baltagi and Li AR-RE joint test - balanced panel <<>>

pbsytest(data = nlswork_balanced, ln_wage ~ union +
           collgrad +age +agesq +tenure +tensq +
           not_smsa +south +c_city, test="j")
# General serial correlation tests <<>> Breusch-Godfrey/Wooldridge test for serial correlation in panel models <<>>

pbgtest(fe, order = 2)

# Wooldridge's test for serial correlation in FE panels

pwartest(data = nlswork_balanced, ln_wage ~ union +
           collgrad +age +agesq +tenure +tensq +
           not_smsa +south +c_city)

# Wooldridge first-difference-based test

pwfdtest(data = nlswork_balanced, ln_wage ~ union +
           collgrad +age +agesq +tenure +tensq +
           not_smsa +south +c_city)

pwfdtest(data = nlswork_balanced, ln_wage ~ union +
           collgrad +age +agesq +tenure +tensq +
           not_smsa +south +c_city, h0="fe")

# Tests for cross-sectional dependence

pcdtest(data = nlswork_balanced, ln_wage ~ union +
          collgrad +age +agesq +tenure +tensq +
          not_smsa +south +c_city)

# HIGH DIMENSIONAL FIXED-EFFECTS

## CHECK: 'lfe' and 'fixest'
### https://github.com/sgaure/lfe
### https://github.com/lrberge/fixest

# *including 1 fixed effect*

HDFE1a <- feols(data = nlswork_clean, ln_wage ~ union +
                  age +agesq +tenure +tensq +
                  not_smsa +south +c_city | idcode)
summary(HDFE1a)

HDFE1b <- felm(data = nlswork_clean, ln_wage ~ union +
                 age +agesq +tenure +tensq +
                 not_smsa +south +c_city | idcode, clustervar=c("idcode"))
summary(HDFE1b)

# *including a 2nd fixed effect*

HDFE2a <- feols(data = nlswork_clean, ln_wage ~ union +
                  age +agesq +tenure +tensq +
                  not_smsa +south +c_city | idcode + year)
summary(HDFE2a)

HDFE2b <- felm(data = nlswork_clean, ln_wage ~ union +
                 age +agesq +tenure +tensq +
                 not_smsa +south +c_city  | idcode + year, clustervar=c("idcode"))
summary(HDFE2b)



## <<>> --- SIMULATED DATA -- <<>> ##


# Using package 'plm' -->> SIMULATED DATA (see the Stata file 'stata_do_example.do' that produces the data in folder tmp_files)

simulated <- read_dta("data/data_simulation.dta")

# names(nlswork)
# head(nlswork)
# str(nlswork)

## EDA: Exploratory Data Analysis

# eda_report(simulated,output_dir = "EDA/",output_file = "eda_simulated.pdf")

ExpData(simulated,type=1)
ExpData(simulated,type=2)

summary(simulated)

ftable(simulated$year)

ExpCTable(simulated)
ExpCatViz(simulated)

## TRY IN A 'JUPYTER NOTEBOOK': ExpNumViz(nlswork)

ExpNumStat(simulated,by="A",Outlier = TRUE,round=2,Qnt=c(0.1,0.25,0.50,0.99))
ExpNumViz(simulated,Page=c(6,2))

ExpOutliers(simulated,varlist=c("lnwage"))

vis_dat(simulated)

# gg_miss_upset(simulated)

stargazer(simulated,
          title = "Summary statistics",
          label = "tb:statistcis",
          table.placement = "ht",
          header=FALSE,type="text")

## DASHBOARD

  ExPanD()

## REGRESSIONS

  pols <- plm(data = simulated, lnwage ~ educ + exper + 
              exper2 + factor(year), 
            model="pooling", index=c("workerid", "year"))

  re <- plm(data = simulated, lnwage ~ educ + exper + 
            exper2 + factor(year), 
          model="random", index=c("workerid", "year"))

plmtest(pols, type=c("bp"))

fe <- plm(data = simulated, lnwage ~ educ + exper + 
            exper2 + factor(year), 
          model="within", index=c("workerid", "year"))

pFtest(fe, pols)
phtest(fe, re)

pols_robust <- coeftest(pols, function(x) vcovHC(x, type = 'sss')) 
re_robust <- coeftest(re, function(x) vcovHC(x, type = 'sss')) 
fe_robust <- coeftest(fe, function(x) vcovHC(x, type = 'sss')) 

stargazer(pols_robust,re_robust, fe_robust,title = "Regression analysis", 
          model.numbers = FALSE,
          column.labels = c("Pooled (cluster)","RE (cluster)","FE (cluster"),
          label = "regressions",
          table.placement = "!ht",
          notes.append = FALSE,
          notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,
          no.space = TRUE,
          omit = c("Constant"),
          omit.stat = c("adj.rsq","f","ser"),
          digits = 3,
          digits.extra = 5,
          omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,
          style = "qje",
          type="text")

## OBSERVE THE MISTAKE FOLLOWING THE INTRODUCTION OF TIME DUMMIES AND EXPERIENCE IN
## THE FIXED-EFFECTS MODEL

##################################      

# sink()

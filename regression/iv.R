# Data Analysis: 2021
# REGRESSION ANALYSIS AND CAUSALITY WITH R | By: João Cerejeira | 10 & 12 November

# SET WORKING DIRECTORY

setwd("C:/Users/mangelo.EEG/Documents/GitHub/R_Training/regression")

rm(list=ls()) #Removes all items in Environment!

# LIBRARIES

library(tidyverse)
library(haven)
library(AER)      # for `ivreg()`
library(lmtest)   # for `coeftest()` and `bptest()`.
library(broom)    # for `glance(`) and `tidy()`
library(PoEdata)  # for PoE4 datasets
library(car)      # for `hccm()` robust standard errors
library(sandwich)
library(knitr)    # for making neat tables with `kable()`
library(stargazer) 
library(modelsummary)
library(kableExtra)

# DATA

  data("mroz", package="PoEdata")
  
  mroz1 <- mroz[mroz$lfp==1,] #restricts sample to lfp=1

# First Stage

educ.ols <- lm(educ ~ exper+I(exper^2)+mothereduc, data=mroz1)

  summary(educ.ols)

  kable(tidy(educ.ols), digits=4, align='c',caption=
        "First stage in the 2SLS model for the 'wage' equation")

    stargazer(educ.ols,type = "text")

# Second Stage

    educHat <- fitted(educ.ols)

    wage.2sls <- lm(log(wage) ~ educHat +exper+I(exper^2), data=mroz1)
kable(tidy(wage.2sls), digits=4, align='c',caption=
        "Second stage in the 2SLS model for the 'wage' equation")

# But the standard errors are incorrect  the correct method is to use 
# a dedicated software function to solve an instrumental variable model

mroz1.ols <- lm(log(wage)~educ+exper+I(exper^2), data=mroz1)

mroz1.iv <- ivreg(log(wage)~educ+exper+I(exper^2)|
                    exper+I(exper^2)+mothereduc, data=mroz1)

stargazer(mroz1.ols, wage.2sls, mroz1.iv,
          title="Wage equation: OLS, 2SLS, and IV models compared",
          header=FALSE, 
          type="text", # "html", "text" or "latex" (in index.Rmd) 
          keep.stat="n",  # what statistics to print
          omit.table.layout="n",
          star.cutoffs=NA,
          digits=4, 
          #  single.row=TRUE,
          intercept.bottom=FALSE, #moves the intercept coef to top
          column.labels=c("OLS","explicit 2SLS", "IV mothereduc", 
                          "IV mothereduc and fathereduc"),
          dep.var.labels.include = FALSE,
          model.numbers = FALSE,
          dep.var.caption="Dependent variable: wage",
          model.names=FALSE,
          star.char=NULL) #supresses the stars

### Test for weak instruments in the  wage  equation

# we just test the joint significance of the instruments in an  educ  model

educ.ols <- lm(educ~exper+I(exper^2)+mothereduc+fathereduc, 
               data=mroz1)

tab <- tidy(educ.ols)

kable(tab, digits=4,
      booktabs = T,
      format = "html",
      caption="The 'educ' first-stage equation")

# The test rejects the null hypothesis that both  mothereduc  and  fathereduc  
# coefficients are zero, indicating that at least one instrument is strong. 
# A rule of thumb requires to soundly reject the null hypothesis at a value of the 
# F -statistic greater than 10 or, for only one instrument, a  t -statistic greater 
# than 3.16, to make sure that an instrument is strong.

  linearHypothesis(educ.ols, c("mothereduc=0", "fathereduc=0"))

### Specification Tests

# Hausman test for endogeneity, where the null hypothesis is  H0:Cov(x,e)=0

# Test for the validity of instruments, test for overidentifying restrictions, 
# or Sargan test H0:Cov(z,e)=0

  mroz1.iv2 <- ivreg(log(wage)~educ+exper+I(exper^2)|
                      exper+I(exper^2)+mothereduc+fathereduc, data=mroz1)
  
  summary(mroz1.iv2, diagnostics=TRUE)

# Results:
# Weak instruments test: rejects the null, meaning that at least one instrument is strong
# (Wu-)Hausman test for endogeneity: barely rejects the null that the variable of concern 
# is uncorrelated with the error term, indicating that  educ  is marginally endogenous
# Sargan overidentifying restrictions: does not reject the null, meaning that the extra instruments 
# are valid (are uncorrelated with the error term).

  ## or with Kable & modelsummary
  
  nls <- read_dta("nlswork.dta")
  
  kableExtra(
    nls %>%
      group_by(union) %>%
      # calculate mean by species
      summarize(across(
        where(is.numeric),
        ~ mean(., na.rm = T)
      )) %>%
      # drop the year variable for the print out
      select(-year),
    # enable booktabs option (only in PDFs)
    booktabs = T,
    format = "html",
    # round to two digits
    digits = 2,
    # caption of the table
    caption = "Differences in Statistics across Union status",
    # rename the columns
    # col.names = c(
    #   "Species",
    #   "Bill Length\n(mm)",
    #   "Bill Depth\n(mm)"
    # )
  ) %>%
    # here we include any extra kableExtra options for the styling
    kableExtra::kable_styling(
      latex_options = c(
        "hold",
        "striped",
        # option to fit a wide table
        "scale_down"
      )
    )
  
  models <- list(
    "M1" = lm(ln_wage ~ collgrad, 
              data = nls),
    "M2" = lm(ln_wage ~ collgrad + union, 
              data = nls),
    "M3" = lm(ln_wage ~ collgrad*union, 
              data = nls),
    "M4" = lm(ln_wage ~ collgrad*union + tenure, 
              data = nls)
  )
  
  gm = gof_map %>%
    mutate(omit = case_when(
      raw == "r.squared" | raw == "nobs" ~ FALSE,
      TRUE ~ TRUE)
    ) %>% 
    arrange(desc(raw))
  
  
  reg_table = modelsummary(models,
                           stars = TRUE, 
                           # report only basic goodness-of-fit stats
                           gof_map = gm,
                           output = 'kableExtra')
  
  reg_table %>% 
    # column spanner
    add_header_above(c(" " = 1, 
                       "Resting Pulse" = 2, 
                       "Active Pulse" = 2)) %>%
    # footnote
    add_footnote("Dataset: 'Pulse Rates and Exercise' from the Stat2Data package.",
                 notation = "none"
    ) %>%
    row_spec(c(5,11), 
             bold = TRUE)

version
getwd()

library(tidyverse)
library(stargazer)
library(SmartEDA)

data(mtcars)
nrow(mtcars)

head(mtcars)

dplyr::glimpse(mtcars)

summary(mtcars$mpg)

ExpCatViz(mtcars)

ExpNumViz(mtcars,Page=c(6,2))

  stargazer(mtcars,
            title = "Summary statistics",
            label = "tb:statistcis",
            table.placement = "ht",
            header=FALSE,type="text")

plot(mtcars$mpg,mtcars$dysp)

M1 <- lm(data = mtcars,mpg ~ wt)

stargazer(M1,title = "Regression analysis", 
          model.numbers = FALSE,column.labels = c("Model 1"),
          label = "regressions",table.placement = "!ht",
          notes.append = FALSE,notes.align="l",
          notes="Standard errors in parentheses.",
          header = FALSE,no.space = TRUE,covariate.labels = c("TENURE"),
          omit = c("Constant"),omit.stat = c("adj.rsq","f","ser"),digits = 2,
          digits.extra = 4,omit.yes.no = c("Constant",""),
          dep.var.caption="",
          dep.var.labels.include = FALSE,style = "qje",type="text")

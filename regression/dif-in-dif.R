# Applied Data Analysis School: October/november 2020
# 6. REGRESSION ANALYSIS AND CAUSALITY WITH R | By: João Cerejeira | 10 & 12 November
# https://www.gades-solutions.com/project/data-analysis-school/

setwd("C:/Users/mangelo.EEG/Documents/GitHub/R_Training/regression")

# setwd("C:\\Users\\JoaoCerejeira\\Dropbox\\statafep2020\\day2\\r")


# library(devtools)
# install.packages("devtools")  # if not already installed
# install_git("https://github.com/ccolonescu/PoEdata")


rm(list = ls())

library(stargazer)
library(PoEdata)   # loads the package in memory
?njmin3              # shows dataset information
data(njmin3)         # loads the dataset in memory
summary(njmin3)      # calculates summary statistics
head(njmin3)         # shows the head of the data set

mod1 <- lm(fte~nj*d, data=njmin3)
mod2 <- lm(fte~nj*d+
             kfc+roys+wendys+co_owned, data=njmin3)
mod3 <- lm(fte~nj*d+
             kfc+roys+wendys+co_owned+
             southj+centralj+pa1, data=njmin3)

stargazer(mod1,mod2,mod3, 
          type="text",
          title="Difference in Differences example",
          header=FALSE, keep.stat="n",digits=2 
          #         single.row=TRUE, intercept.bottom=FALSE
)

tdelta <- summary(mod1)$coefficients[4,3]
  tdelta

b1 <- coef(mod1)[[1]]
b2 <- coef(mod1)[["nj"]]
b3 <- coef(mod1)[["d"]]
delta <- coef(mod1)[["nj:d"]]
C <- b1+b2+b3+delta
E <- b1+b3
B <- b1+b2
A <- b1
D <- E+(B-A)

# This creates an empty plot:

plot(1, type="n", xlab="period", ylab="fte", xaxt="n",xlim=c(-0.01, 1.01), ylim=c(18, 24)) +
  segments(x0=0, y0=A, x1=1, y1=E, lty=1, col=2) + #control
  segments(x0=0, y0=B, x1=1, y1=C, lty=3, col=3) + #treated
  segments(x0=0, y0=B, x1=1, y1=D,lty=4, col=4)  +    #counterfactual
  legend("topright", legend=c("control", "treated","counterfactual"), lty=c(1,3,4), col=c(2,3,4)) +
  axis(side=1, at=c(0,1), labels=NULL)

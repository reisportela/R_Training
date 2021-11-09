#library(graphics)
library(forecast)
setwd("/Users/camado/Documents/Teaching/UMinho SS/SS 2020/Lectures/Lectures_031220")
load("tb3m5605.rda")
tbill <- tb3m5605
#Check (non)stationarity
plot(tbill)
acf(tbill)
dltb <- diff(log(tbill))
plot(dltb)
acf(dltb)
acf(dltb^2)
pacf(dltb)
#Which ARMA model to choose?
tsdisplay(dltb) #forecast library
#Use BIC (try also a pure AR)
tbBIC <- auto.arima(dltb, d=0, D=0, max.p=10, max.q=10, max.P=0, max.Q=0,
                     max.order=10, ic="bic", stepwise=FALSE, approximation=FALSE)
summary(tbBIC)
#Diagnostics
tsdiag(tbBIC)
#Use AIC
tbAIC1 <- auto.arima(dltb, max.order=5, ic="aic", stepwise=FALSE, approximation=FALSE)
summary(tbAIC1)
#Diagnostics
tsdiag(tbAIC1)
#Try tbAIC also with max.order=12
tbAIC2 <- auto.arima(dltb, d=0, D=0, max.p=0, max.q=12, max.P=0, max.Q=0,
                    max.order=12, ic="aic", stepwise=FALSE, approximation=FALSE)
summary(tbAIC2)
#Diagnostics
tsdiag(tbAIC2)
acf(residuals(tbAIC2))
Box.test(residuals(tbAIC2), lag=20, fitdf=7, type="Ljung")
#Exclude non-statistically significant coefficients
#NA means that the coefficient is not fixed and is estimated; last coefficient 
#refers to the constant
#fl<-structure(list(mean=K,x=Dem2,fitted=tbMA0$fitted),class="forecast")
tbMA0 <- arima(dltb, order = c(0,0,7),
               fixed = c(NA, NA, NA, 0, 0, NA, NA, 0))

summary(tbMA)
tsdiag(tbMA)
dltb_fc <- forecast(tbAIC2, h = 30)
dltb_fc
#plot(gdp_fc, shaded = FALSE)
#plot(gdp_fc, shadecols = grey(c(0.8, 0.6)))
plot(dltb_fc)

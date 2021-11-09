#library(graphics)
library(forecast)
setwd("/Users/camado/Documents/Teaching/UMinho SS/SS 2020/Lectures/Lectures_031220")
#US Gross Domestic Product
load("usgdp5190.rda")
dlgdp <- usgdp5190
#Check (non)stationarity
plot(dlgdp)
acf(dlgdp)
pacf(dlgdp)
Box.test(dlgdp, 10)
Box.test(dlgdp, 10, type = "Ljung-Box")
ar(dlgdp)
gdp.ar1 <- arima(dlgdp, c(3, 0, 0))
summary(gdp.ar1)
gdp.ar2 <- arima(dlgdp, c(1, 0, 0)) #BIC
summary(gdp.ar2)
tsdiag(gdp.ar2) 
#Diagnostics
tsdiag(gdp.ar1) 
#Automatic modelling: AR models
gdpAR <- auto.arima(dlgdp, d=0, D=0, max.p=12, max.q=0, max.P=0, max.Q=0, 
                    max.order=12, ic="bic", stepwise=FALSE, approximation=FALSE)
summary(gdpAR)
#Automatic modelling: ARMA models
gdpARMA <- auto.arima(dlgdp, d=0, D=0, max.p=12, max.q=12, max.P=0, max.Q=0, 
                    max.order=6, ic="aic", stepwise=FALSE, approximation=FALSE)
#Check with BIC
summary(gdpARMA)
tsdiag(gdpARMA)
gdp.ma2 <- arima(dlgdp, c(0, 0, 2))
summary(gdp.ma2)
#Diagnostics
tsdiag(gdp.ma2) 

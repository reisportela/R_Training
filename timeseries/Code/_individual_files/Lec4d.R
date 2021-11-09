library(forecast)
setwd("/Users/camado/Documents/Teaching/UMinho SS/SS 2020/Lectures/Lectures_031220")
#US Gross Domestic Product (percent change)
load("usgdp5190.rda")
dlgdp <- usgdp5190
#Check (non)stationarity
plot(dlgdp)
acf(dlgdp)
pacf(dlgdp)
gdp <- 100*dlgdp
plot(gdp)
gdp.ar1 <- arima(gdp, c(1, 0, 0))
summary(gdp.ar1)
#pred1 <- predict(gdp.ar1, n.ahead = 4)
#pred1
gdp_fc <- forecast(gdp.ar1, h = 20)
gdp_fc
#plot(gdp_fc, shaded = FALSE)
plot(gdp_fc)

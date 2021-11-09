#Automatic forecasting from Hyndman et al. (IJF, 2002)
library(forecast)
data(ausbeer, package = "fpp")
plot(ausbeer, ylab="Beer", xlab="Year") 
#ets(error,trend,seasonal)
#error=A,M
#trend=N,A,Ad,M,Md
#seasonal=N,A,M
fit1 <- ets(ausbeer)
fcast1 <- forecast(fit1,h=20)
summary(fit1)
plot(fit1)
fit2 <- ets(ausbeer,model="AAA",damped=FALSE)
fcast2 <- forecast(fit2,h=20)
summary(fit2)
plot(fit2)
#plot(forecast(fit1,level=c(95),fan=TRUE))

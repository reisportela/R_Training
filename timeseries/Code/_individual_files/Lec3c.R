library(forecast)
data(austourists, package = "fpp")
#original data - from 1970 until 2010
plot(austourists, ylab="Tourists", xlab="Year") 
aust <- window(austourists,start=2005)
#print(aust)
fit1 <- hw(aust,seasonal="additive")
fit2 <- hw(aust,seasonal="multiplicative")
fit3 <- hw(aust,seasonal="additive", damped=TRUE)
fit4 <- hw(aust,seasonal="multiplicative", damped=TRUE)
#level lt, trend bt, and seasons 
fit1$model$state 
#Fitted values (lt+bt)
fitted(fit1)
#Forecasts
fit1$mean
plot(fit2,ylab="Tourists (millions)",
     plot.conf=FALSE, type="o", fcol="white", xlab="Year",main="")
lines(fitted(fit1), col="red", lty=2)
lines(fitted(fit2), col="green", lty=2)
lines(fit1$mean, type="o", col="red")
lines(fit2$mean, type="o", col="green")
lines(fitted(fit3), col="blue", lty=2)
lines(fitted(fit4), col="grey", lty=2)
lines(fit3$mean, type="o", col="blue")
lines(fit4$mean, type="o", col="grey")
legend("topleft",lty=1, pch=1, col=1:3, 
       c("data","Holt Winters' Additive","Holt Winters' Multiplicative"))
#Forecast results
summary(fit1)
summary(fit2)
summary(fit3)
summary(fit4)
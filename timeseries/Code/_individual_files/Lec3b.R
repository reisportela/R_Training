library(forecast)
data(ausair, package = "fpp")
#original data - from 1970 until 2010
plot(ausair) 
air <- window(ausair,start=1990,end=2004)
fit1 <- holt(air, alpha=0.8, beta=0.2, initial="simple", h=5) 
fit2 <- holt(air, alpha=0.8, beta=0.2, initial="simple", exponential=TRUE, h=5) 
fit3 <- holt(air, alpha=0.8, beta=0.2, damped=TRUE, initial="simple", h=5) 
plot(air,ylab="Air passengers", xlab="Year")
air
#print(air)
#Results for first model:
#level lt and trend bt
fit1$model$state 
#Fitted values (lt+bt)
fitted(fit1)
#Forecasts
fit1$mean
#Plots
plot(fit2, type="o", ylab="Air passengers", xlab="Year", 
     fcol="white", plot.conf=FALSE, main="")
lines(fitted(fit1), col="blue") 
lines(fitted(fit2), col="red")
lines(fitted(fit3), col="green")
lines(fit1$mean, col="blue", type="o") 
lines(fit2$mean, col="red", type="o")
lines(fit3$mean, col="green", type="o")
legend("topleft", lty=1, col=c("black","blue","red","green"), 
       c("Data","Holt's linear trend","Exponential trend","Additive damped trend"))
#Forecast results
summary(fit1)
summary(fit2)
summary(fit3)

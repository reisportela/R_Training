library(forecast)
data(oil, package = "fpp")
plot(oil)
oildata <- window(oil,start=1996,end=2007)
plot(oildata, ylab="Oil (millions of tonnes)", xlab="Year")
#Simple exponential smoothing
fit1 <- ses(oildata, alpha=0.2, initial="simple", h=3) #lo=y1 or initial=optimal
fit2 <- ses(oildata, alpha=0.6, initial="simple", h=3)
fit3 <- ses(oildata, h=3)
#Plot for alpha=0.2,0.6,0.89
plot(fit1, plot.conf=FALSE, ylab="Oil (millions of tonnes)",
     xlab="Year", main="", fcol="white", type="o")
lines(fitted(fit1), col="blue", type="o")
lines(fitted(fit2), col="red", type="o")
lines(fitted(fit3), col="green", type="o")
lines(fit1$mean, col="blue", type="o")
lines(fit2$mean, col="red", type="o")
lines(fit3$mean, col="green", type="o")
legend("topleft",lty=1, col=c(1,"blue","red","green"), 
       c("data", expression(alpha == 0.2), expression(alpha == 0.6),
         expression(alpha == 0.89)),pch=1)
oildata
#level lt for each alpha
fit1$model$state
fit2$model$state
fit3$model$state
#fitted(fit1)
#fitted(fit2)
#fitted(fit3)
#Summary of results
summary(fit1)
summary(fit2)
summary(fit3)
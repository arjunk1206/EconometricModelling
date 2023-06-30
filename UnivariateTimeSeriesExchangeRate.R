
ERts <- ts(rev(GDPTimeSeries$`Exchange Rate`))

plot.ts(GDPts)

#plotting differences
ERdiffts<- diff(GDPts,differences = 1)
plot.ts(ERdiffts)

library(tseries)
adf.test(ERts)

library(aTSA)
stationary.test(ERts)
stationary.test(ERts, method = "pp") 
stationary.test(ERts, method = "kpss") 

#Tests of Stationarity show that series is non-stationary

acf(ERdiffts, lag.max = 100)

pacf(ERdiffts,lag.max = 100 )

library(forecast)
library(urca)

#Fitting ARIMA models on the series
auto.arima(rev(GDPTimeSeries$`Exchange Rate`))

auto.arima(ERts)

auto.arima(ERdiffts)

ERtsarima <- arima(ERts, order = c(0,1,0))
ERtsarima

ERtsforecast <- forecast(ERtsarima, h =5, level=c(99.5))
ERtsforecast

acf(ERtsforecast$residuals, lag.max=20)
Box.test(ERtsforecast$residuals, lag=20, type="Ljung-Box")

#fail to reject time series

plot.ts(ERtsforecast$residuals)
hist(ERtsforecast$residuals)

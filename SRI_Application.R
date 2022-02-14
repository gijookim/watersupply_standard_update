setwd("D:/Dropbox/Dropbox/0. ★Research/8-1. 용수공급조정기준 업데이트 (2021.04)/★Multi-year Drought Mitigation Research/Problem Statement (SRI)")
library(SCI)
library(FAdist)

## Observation Data, 1998-2020 (23 Yrs)
br.obs.monthly <- read.csv("br_obs_monthly.csv",header=T)

n.years <- 23
date <- rep(1:n.years,each=12) + 1997 + rep((0:11)/12,times=n.years)
PRECIP <- br.obs.monthly$inflow

# SRI-1
sri.para.1 <- fitSCI(PRECIP,first.mon=1,time.scale=1,distr="genlog",p0=TRUE)
sri.1 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.1)
plot(date,sri.1,t="l")
abline(h=0,col="red")

# SRI-3
sri.para.3 <- fitSCI(PRECIP,first.mon=1,time.scale=3,distr="genlog",p0=TRUE)
sri.3 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.3)
plot(date,spi,t="l")
abline(h=0,col="red")

# SRI-6
sri.para.6 <- fitSCI(PRECIP,first.mon=1,time.scale=6,distr="genlog",p0=TRUE)
sri.6 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.6)
plot(date,sri.6,t="l")
abline(h=0,col="red")

# SRI-12
sri.para.12 <- fitSCI(PRECIP,first.mon=1,time.scale=12,distr="genlog",p0=TRUE)
sri.12 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.12)
plot(date,sri.12,t="l")
abline(h=0,col="red")

# SRI-24
sri.para.24 <- fitSCI(PRECIP,first.mon=1,time.scale=24,distr="genlog",p0=TRUE)
sri.24 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.24)
plot(date,sri.24,t="l")
abline(h=0,col="red")

write.csv(cbind(sri.3,sri.6,sri.12,sri.24),"obs_sri_genlog.csv")




## Fit to 3-parameter log-logistic Dist.

fitdist(log(PRECIP),distr="logis")



## Synthetic Inflow (500 Yrs, PARMA(1,1) generated from K-water)
kw.parma.monthly <- read.csv("kw_parma_monthly.csv",header=T)

n.years <- 499
date <- rep(1:n.years,each=12) + 0 + rep((0:11)/12,times=n.years)
PRECIP <- kw.parma.monthly$inflow

# SRI-1
sri.para.1 <- fitSCI(PRECIP,first.mon=1,time.scale=1,distr="genlog",p0=TRUE)
sri.1 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.1)
plot(date,sri.1,t="l")
abline(h=0,col="red")

# SRI-3
sri.para.3 <- fitSCI(PRECIP,first.mon=1,time.scale=3,distr="genlog",p0=TRUE)
sri.3 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.3)
plot(date,sri.3,t="l")
abline(h=0,col="red")

# SRI-6
sri.para.6 <- fitSCI(PRECIP,first.mon=1,time.scale=6,distr="genlog",p0=TRUE)
sri.6 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.6)
plot(date,sri.6,t="l")
abline(h=0,col="red")

# SRI-12
sri.para.12 <- fitSCI(PRECIP,first.mon=1,time.scale=12,distr="genlog",p0=TRUE)
sri.12 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.12)
plot(date,sri.12,t="l")
abline(h=0,col="red")

# SRI-24
sri.para.24 <- fitSCI(PRECIP,first.mon=1,time.scale=24,distr="genlog",p0=TRUE)
sri.24 <- transformSCI(PRECIP,first.mon=1,obj=sri.para.24)
plot(date,sri.24,t="l")
abline(h=0,col="red")


write.csv(cbind(sri.3,sri.6,sri.12,sri.24),"parma_sri.csv")

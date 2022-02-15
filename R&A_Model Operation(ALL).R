#set wd
setwd("D:/Dropbox/Dropbox/0. ★Research/8-1. 용수공급조정기준 업데이트 (2021.04)/DrResOPT Simulation_Parallel (Jul 2021)")
library(measurements)

## Read Input (10-Day Series)
brdam_input <- read.csv("BR_Input.csv")

## Rule Curve Definition (Attention,Caution,Alert,Critical,Normal)
rule_curve=matrix(0,nrow=828,ncol=4)
colnames(rule_curve) <- c("att","cau","alt","crt")
rule_curve[,1] <- brdam_input$att
rule_curve[,2] <- brdam_input$cau
rule_curve[,3] <- brdam_input$alt
rule_curve[,4] <- brdam_input$crt

## Daily Demand in MCM 
demand=matrix(0,nrow=828,ncol=6)
colnames(demand) <- c("MI_All","MI_Cont","Agr","Env","Agg_all","Agg_cont")
demand[,1] <- brdam_input$MI_all
demand[,2] <- brdam_input$MI_cont
demand[,3] <- brdam_input$Agr
demand[,4] <- brdam_input$Env
demand[,5] <- brdam_input$MI_all+brdam_input$Agr+brdam_input$Env
demand[,6] <- brdam_input$MI_cont+brdam_input$Agr+brdam_input$Env

## Function: m3/s -> MCM 
cms2mcm <- function (x) {
  x*60*60*24/10^6}
# Function Elevation to Storage (El.m -> MCM)
el2sto <- function (x) {
  if (x>=40 & x<=60){
    0.00089125*x^3-0.0460875*x^2-0.5309999999*x+38.5449999989
  } else if (x>60 & x<=80){
    -0.0003370833*x^3+0.1750125*x^2-13.6741666646*x+296.494999956}}


## Reservoir Modeling (Units=MCM)
# Constraints 
Smax = el2sto(74)
Smin = el2sto(50)


###############################################################################
# Data Creating
s          =vector("double",length=829)
spill      =vector("double",length=829)
s_end_t    =vector("double",length=829)
s_end_act  =vector("double",length=829)
conduit    =vector("double",length=829)
r          =vector("double",length=829)
r_act      =vector("double",length=829)

s[1] <- 35.342 #Starting Storage

inflow = brdam_input$Inflow
inflow.max.lim <- 10
inflow[inflow > inflow.max.lim] <- inflow.max.lim

##Simulation with Original Rule Curves
for (i in (0:827)) {
  i=i+1
  if (i==1) {
    r[1]=2.712
    s_end_t[i]=s[1]
  } else{ s[i] = s_end_t[(i-1)]
  if (s[i]>Smax){
    spill[i] = s[i]-Smax
    s[i] = Smax
  } else 
    if (s[i]>rule_curve[i,1]){
      r[i]=demand[i,5]
    } else if (s[i]>rule_curve[i,2]){
      r[i]=demand[i,6]
    } else if (s[i]>rule_curve[i,3]){
      r[i] = demand[i,2]+demand[i,3]
    } else if (s[i]>rule_curve[i,4]){
      r[i] = demand[i,2]+0.75*demand[i,3]
      if (i>685){
        conduit[i] <- min(1.15,rule_curve[i,3]-s[i])
        inflow[i] <- inflow[i]+ conduit[i]
      }
    } else if (s[i]>Smin){
      r[i] = 0.8*demand[i,2]+0.75*demand[i,3]
      if (i>685){
        conduit[i] <- min(1.15,rule_curve[i,3]-s[i])
        inflow[i] <- inflow[i]+ conduit[i]
      }
    } else if (s[i]<=Smin) {
      r[i]=0 
    } 
  }
  s_end_t[i]    = s[i]+inflow[i]-r[i]
  r_act[i]      = s[i]-s_end_t[i]+inflow[i]
  s_end_act[i]  = s[i]+inflow[i]-r_act[i]
}


# Plotting Results
plot(s_end_act[1:828],type="l")
lines(brdam_input$obs.st,col="red")

write.csv(s_end_act,'SQ_sto.csv')
write.csv(r_act,'SQ_rt.csv')


# Reliability Calculation
# 1) vs Z2
1-sum(s_end_act[1:828]-rule_curve[,2]<0)/828
1-sum(s_end_act[577:792]-rule_curve[577:792,2]<0)/828

# 2) vs Z4
1-sum(s_end_act[1:828]-rule_curve[,4]<0)/828
1-sum(s_end_act[577:792]-rule_curve[577:792,4]<0)/828


#################################################################################
# Non-Adaptive Operations With Alternative Rule Curves
s          =vector("double",length=829)
spill      =vector("double",length=829)
s_end_t    =vector("double",length=829)
s_end_act  =vector("double",length=829)
conduit    =vector("double",length=829)
r          =vector("double",length=829)
r_act      =vector("double",length=829)

s[1] <- 35.342 #Starting Storage

inflow = brdam_input$Inflow
inflow.max.lim <- 10
inflow[inflow > inflow.max.lim] <- inflow.max.lim


calculated.sri = brdam_input$sri.12
threshold.sri = c(0,-0.5,-1,-1.5,-2)

Median_rules <- read.csv("Median_ALLCases.csv")

alt_rule_curve=matrix(0,nrow=828,ncol=4)
colnames(alt_rule_curve) <- c("att","cau","alt","crt")
alt_rule_curve[,1] <- rep(Median_rules$V33)
alt_rule_curve[,2] <- rep(Median_rules$V34)
alt_rule_curve[,3] <- rep(Median_rules$V35)
alt_rule_curve[,4] <- rep(Median_rules$V36)


for (i in (0:827)) {
  i=i+1
  if (i==1) {
    r[1]=2.712
    s_end_t[i]=s[1]
  } else{ s[i] = s_end_t[(i-1)]
  if (s[i]>Smax){
    spill[i] = s[i]-Smax
    s[i] = Smax
  } else 
    if (s[i]>alt_rule_curve[i,1]){
      r[i]=demand[i,5]
    } else if (s[i]>alt_rule_curve[i,2]){
      r[i]=demand[i,6]
    } else if (s[i]>alt_rule_curve[i,3]){
      r[i] = demand[i,2]+demand[i,3]
    } else if (s[i]>alt_rule_curve[i,4]){
      r[i] = demand[i,2]+0.75*demand[i,3]
      if (i>685){
        conduit[i] <- min(1.15,alt_rule_curve[i,3]-s[i])
        inflow[i] <- inflow[i]+ conduit[i]
      }
    } else if (s[i]>Smin){
      r[i] = 0.8*demand[i,2]+0.75*demand[i,3]
      if (i>685){
        conduit[i] <- min(1.15,alt_rule_curve[i,3]-s[i])
        inflow[i] <- inflow[i]+ conduit[i]
      }
    } else if (s[i]<=Smin) {
      r[i]=0 
    } 
  }
  s_end_t[i]    = s[i]+inflow[i]-r[i]
  r_act[i]      = s[i]-s_end_t[i]+inflow[i]
  s_end_act[i]  = s[i]+inflow[i]-r_act[i]
}


plot(s_end_act[1:828],type="l")
lines(brdam_input$obs.st,col="red")

# 1) vs Z2
1-sum(s_end_act[1:828]-rule_curve[,2]<0)/828
1-sum(s_end_act[577:792]-rule_curve[577:792,2]<0)/828

# 2) vs Z4
1-sum(s_end_act[1:828]-rule_curve[,4]<0)/828
1-sum(s_end_act[577:792]-rule_curve[577:792,4]<0)/828


##
#################################################################################
# Adaptive Operations With Alternative Rule Curves
s          =vector("double",length=829)
spill      =vector("double",length=829)
s_end_t    =vector("double",length=829)
s_end_act  =vector("double",length=829)
conduit    =vector("double",length=829)
r          =vector("double",length=829)
r_act      =vector("double",length=829)

s[1] <- 35.342 #Starting Storage

inflow = brdam_input$Inflow
inflow.max.lim <- 10
inflow[inflow > inflow.max.lim] <- inflow.max.lim

threshold.sri = c(0,-0.1800,-0.3661,-0.5659,-0.7916,-1.0676,-1.4652,-2.5)
Median_rules <- read.csv("Median_SevenCases.csv")

alt_rule_curve=matrix(0,nrow=828,ncol=4)

sri.12 <- brdam_input$sri.12
sri.12[is.na(sri.12)] <- 1



for (j in (1:7)) {
  s          =vector("double",length=829)
  spill      =vector("double",length=829)
  s_end_t    =vector("double",length=829)
  s_end_act  =vector("double",length=829)
  conduit    =vector("double",length=829)
  r          =vector("double",length=829)
  r_act      =vector("double",length=829)
  
  s[1] <- 35.342 #Starting Storage

for (i in (0:827)) {
  i=i+1
  
  if (sri.12[i] > threshold.sri[1]) { 
    alt_rul_curve = rule_curve
    
    if (i==1) {
      r[1]=2.712
      s_end_t[i]=s[1]
    } else{ s[i] = s_end_t[(i-1)]
    if (s[i]>Smax){
      spill[i] = s[i]-Smax
      s[i] = Smax
      r[i] = demand[i,5]
    } else 
      if (s[i]>alt_rule_curve[i,1]){
        r[i]=demand[i,5]
      } else if (s[i]>alt_rule_curve[i,2]){
        r[i]=demand[i,6]
      } else if (s[i]>alt_rule_curve[i,3]){
        r[i] = demand[i,2]+demand[i,3]
      } else if (s[i]>alt_rule_curve[i,4]){
        r[i] = demand[i,2]+0.75*demand[i,3]
        if (i>685){
          conduit[i] <- min(1.15,alt_rule_curve[i,3]-s[i])
          inflow[i] <- min(inflow[i]+conduit[i],11.15)
        }
      } else if (s[i]>Smin){
        r[i] = 0.8*demand[i,2]+0.75*demand[i,3]
        if (i>685){
          conduit[i] <- min(1.15,alt_rule_curve[i,3]-s[i])
          inflow[i] <- min(inflow[i]+conduit[i],11.15)
        }
      } else if (s[i]<=Smin) {
        r[i]=0 
      }}
    
  } else if (sri.12[i] > threshold.sri[j+1]) {
  alt_rule_curve[,1] <- rep(Median_rules[,(j-1)*4+2])
  alt_rule_curve[,2] <- rep(Median_rules[,(j-1)*4+3])
  alt_rule_curve[,3] <- rep(Median_rules[,(j-1)*4+4])
  alt_rule_curve[,4] <- rep(Median_rules[,(j-1)*4+5])
  } 
  
  if (i==1) {
    r[1]=2.712
    s_end_t[i]=s[1]
  } else{ s[i] = s_end_t[(i-1)]
  if (s[i]>Smax){
    spill[i] = s[i]-Smax
    s[i] = Smax
    r[i] = demand[i,5]
  } else 
    if (s[i]>alt_rule_curve[i,1]){
      r[i]=demand[i,5]
    } else if (s[i]>alt_rule_curve[i,2]){
      r[i]=demand[i,6]
    } else if (s[i]>alt_rule_curve[i,3]){
      r[i] = demand[i,2]+demand[i,3]
    } else if (s[i]>alt_rule_curve[i,4]){
      r[i] = demand[i,2]+0.75*demand[i,3]
      if (i>685){
        conduit[i] <- min(1.15,alt_rule_curve[i,3]-s[i])
        inflow[i] <- min(inflow[i]+conduit[i],11.15)
      }
    } else if (s[i]>Smin){
      r[i] = 0.8*demand[i,2]+0.75*demand[i,3]
      if (i>685){
        conduit[i] <- min(1.15,alt_rule_curve[i,3]-s[i])
        inflow[i] <- min(inflow[i]+conduit[i],11.15)
      }
    } else if (s[i]<=Smin) {
      r[i]=0 
    }}
  s_end_t[i]    = s[i]+inflow[i]-r[i]
  r_act[i]      = s[i]-s_end_t[i]+inflow[i]
  s_end_act[i]  = s[i]+inflow[i]-r_act[i]
}}
  
  

write.csv(s_end_act,'AO_sto.csv')
write.csv(r_act,'AO_rt.csv')


# 1) vs Z2
Rel.ALL.Z2[j,k] = 1-sum((s_end_act[1:828]-rule_curve[,2])<0)/828
Rel.DRO.Z2[j,k] = 1-sum((s_end_act[577:792]-rule_curve[577:792,2])<0)/828

# 2) vs Z4
Rel.ALL.Z4[j,k] = 1-sum((s_end_act[1:828]-rule_curve[,4])<0)/828
Rel.DRO.Z4[j,k] = 1-sum((s_end_act[577:792]-rule_curve[577:792,4])<0)/828


plot(brdam_input$sri.12[172:351],type="l",lwd=2,ylim=c(-2,1.5),ylab="SRI-12")
lines(brdam_input$sri.12[532:711],type="l",lwd=2,col="red")

plot(brdam_input$sri.24[172:351],type="l",lwd=2,ylim=c(-2.5,2),ylab="SRI-24")
lines(brdam_input$sri.24[532:711],type="l",lwd=2,col="red")

library(ramify)

nk = 100000
nt = 36
nstg = 3
ncol = 8
n365 = 365

iyear = 500          
nmin = 15            
reliability = 95     
st_lwl   = 6.2       
st_flood = 108.7    	
st_nwl   = 108.7     

n = iyear*nt 
demand = read.csv('BR_Demand.csv',header = F)
dem_dip = demand[,1]
dem_agr = demand[,2]
dem_riv = demand[,3]


nday = c(10,10,11,10,10,8,10,10,11,10,10,10,10,10,11,10,10,10,10,10,11,10,10,11,10,10,10,10,10,11,10,10,10,10,10,11)

D2 = vector("double",length=iyear*nt) 
D3 = vector("double",length=iyear*nt)
D4 = vector("double",length=iyear*nt)
i10d = vector("double",length=iyear*nt)

river_rdc = vector("double",length=nt)
river_rdc = 2.7*nday/100
agri_rdc_1 = vector("double",length=nt)
agri_rdc_1 = c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.171,0.171,0.171,0,0,0,0,0,0,0.006,0.006,0.006,0,0,0,0,0,0,0,0,0)


conduit = vector("double",length=nt)
conduit = 11.5*nday/100

agri_rdc_2 = vector("double",length=nt)
agri_rdc_2 = c(0,0,0,0,0,0,0,0,0,0.09,0.09,0.09,0.107,0.107,0.11177,0.338,0.338,0.338,
               0.255,0.255,0.2805,0.305,0.305,0.3355,0.182,0.182,0.182,0,0,0,0,0,0,0,0,0)

dip_rdc = vector("double",length=nt)
dip_rdc = 1.18*nday/100



for (i in (1:iyear)){
  for (j in (1:nt)){
    D2[(i-1)*nt+j]=dem_dip[j]+dem_agr[j]+dem_riv[j]
    D3[(i-1)*nt+j]=dem_dip[j]+dem_agr[j]-river_rdc[j]-agri_rdc_1[j]
    D4[(i-1)*nt+j]=dem_dip[j]-conduit[j]-agri_rdc_2[j]-dip_rdc[j]
    i10d[(i-1)*nt+j]=j
  }
}

source("DrResOPT_cal.R")
st_result = matrix(NA, 36,100*4)
inflow_case5 = read.csv('Input_Q/Case5_Q.csv',header = F)


for (i in (1:100)) {
  flow = inflow_case5[,i]
  
  sto1 = rep(NA,n)
  sto2 = rep(NA,n)
  st_final = rep(NA,36) 
  demand=D2
  
  st_result[,(i-1)*4+1] = DrResOPT_cal()
  
  
  sto1 = rep(NA,n)
  sto2 = rep(NA,n)
  st_final = rep(NA,36)
  demand=D3
  
  st_result[,(i-1)*4+2] = DrResOPT_cal()
  
  
  
  sto1 = rep(NA,n)
  sto2 = rep(NA,n)
  st_final = rep(NA,36)
  demand=D4
  
  st_result[,(i-1)*4+3] = DrResOPT_cal()
  

  st_result[,(i-1)*4+4] = st_result[,(i-1)*4+1] + 15*(dem_dip+dem_agr+dem_riv)/nday
}








DrResOPT_cal <- function() {
  
  for (i in (1:nt)){
    sto_act = (st_nwl-st_lwl)*10
    maxit = round(sto_act)
    
    for (j in (1:maxit)){                     
      sto1[i] = st_lwl + (j-1)/10
      sto2[i] = sto1[i]
      
      for (k in ((i+1):n)){
        sto1[k] = sto2[k-1]+flow[k]-demand[k] 
        if(i10d[k]==i){sto1[k]=sto1[i]}      
        
        if ((i10d[k]>=18)&&(i10d[k]<=26)){
          if (sto1[k]<st_flood){sto2[k]=sto1[k]}
          else {sto2[k] = st_flood}}
        
       
        if(sto1[k]<st_nwl){sto2[k]=sto1[k]} 
        else {sto2[k] = st_nwl} 
      } 
      
      
      icount=0
      for (k in 1:(iyear-1)){
        isum=0
        
        for (kj in 1:nt){                           
          if(sto2[(k-1)*nt+kj+i-1]<=st_lwl){
            icheck=1
            isum=(isum+1)
          } else {icheck=0}
        }                                           
        if(isum>=1) {icount=(icount+1)}
      }                                              
      
      com_rel = (1-(icount/(iyear-1)))*100
      
      if(com_rel>reliability){break} 
    }                                              
    st_final[i]=sto1[i]
  }                                                
  return(st_final)
}

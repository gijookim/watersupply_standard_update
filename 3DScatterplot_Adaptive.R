library(scatterplot3d)
library(car)
library(rgl)
library(plot3D)

output <- read.csv("R&A_AdaptiveOperation.csv")

scatter3D(x=output$st,y=output$sri,z=output$rt,bty="g",ticktype="detailed",
          xlab="Storage (MCM)",ylab="SRI",zlab="Release (cms)")

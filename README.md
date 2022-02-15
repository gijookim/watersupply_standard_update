# Updating Water Supply Adjustment Standards in the Boryeong Multipurpose Reservoir with Adpative Actions

This repository is an application of the reforming the current reservoir operating policy, zone-based hedging rule, of Boryeong Multipurpose Reservoir located in the western coast of the Republic of Korea. 

In order to replicate the steps of the reformation of zone-based hedging rule in the Boryeong Reservoir, you will need the data files from the following Dataset on Mendeley Data (). Since all the required files are either on this repository or Mendeley Data, please follow the instructions written in the code

This code is used to generate the dataset used to generate figures in: Kim, G. J., Seo, S. B., & Kim, Y.-O. (under review) "Adaptive Reservoir Management by Reforming the Zone-based Hedging Rules against Multi-year Droughts," currently under review in Water Resources Management. 





This repository is an application of M3O Matlab toolbox for designing optimal operations of multipurpose water reservoir systems. This application of the M3O toolbox on Boryeong Dam located in South Korea aims to derive optimal solutions using DDP-Perfect, DDP-Average, SDP, and three EMODPS models each with different number of parameters and shapes of approximating functions. Then their performances are measured under discrete set of inflow series using K-fold Cross Validation method (K=4). Also, the effect of incorporation of a zone-based hedging rule is also explored during simulation.

In order to replicate the steps of the analysis on Boryeong Reservoir, download the data files from on the following Dataset on Mendeley Data (http://dx.doi.org/10.17632/9ntcdscwpd.3) and copy the files into /sim/data in this repository, which is currently empty. After that, run the main_script.m file by carefully following the instructions given inside the code file.


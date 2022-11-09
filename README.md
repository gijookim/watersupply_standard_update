# Updating Water Supply Adjustment Standards in the Boryeong Multipurpose Reservoir with Adpative Actions

This repository is an application of the reforming the current reservoir operating policy, zone-based hedging rule, of Boryeong Multipurpose Reservoir located in the western coast of the Republic of Korea. The current status quo (SQ) rule is generated based on the synthetic 10-day inflow series generated from periodic autoregressive (PAR) time series model. The codes in this repository are both utilized during the generation of alternative hedging rules including long memory (considering multi-year drought) and adaptive reservoir operations with standardized runoff index (SRI) as triggers. 

In order to replicate the steps of the reformation of zone-based hedging rule in the Boryeong Reservoir, you will need the data files from the following Dataset on Mendeley Data (https://data.mendeley.com/drafts/b54wd2gtdx). Since all the required files are either on this repository or Mendeley Data, please follow the instructions written in the code.

For the generation of time series data with long memory, refer to the codes in the 'ARFIMA_generation' folder.
For the generation of the alternative zone-based hedging rule, refer to 'DrResOPT_Publish.R' file.
For the generation of the figures in the manuscript and reservoir simulation, refer to 'R&A_Model Operation(ALL).R' file or '3DScatterplot_Adaptive.R' files.
Specifics regarding the logics behind the application, refer to the explanations in the published manuscript. 

This code is used to generate the dataset used to generate figures in: Kim, G. J., Seo, S. B., & Kim, Y. O. (2022). Adaptive Reservoir Management by Reforming the Zone-based Hedging Rules against Multi-year Droughts. Water Resources Management, 36(10), 3575-3590. https://doi.org/10.1007/s11269-022-03214-0.

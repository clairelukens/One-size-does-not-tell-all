# One-size-does-not-tell-all
This repository holds the datafiles and matlab code associated with the article "Sand, gravel, cobbles, and boulders: Detrital thermochronology shows that one size does not tell all", by C. E. Lukens, C. S. Riebe, L. S. Sklar, and D. L. Shuster.

Code is available for research and education purposes, under the license included. 

Datafiles:  The catchment file (inyoXYZS), which includes columns for northing, easting, elevation, and slope for each cell in the 10-m digital elevation model. 
The detrital (U-Th)/He ages comprise the “AllAge_NoOutliers” file, with outliers removed. This is the file called in the code. Each sediment size has three columns: the (U-Th)/He age in Ma, the analytical error (1-sigma, also in Ma), and the percent error. Sediment sizes are arranged from smallest to largest. 
The “allData” file is formatted in the same way, but includes the outliers. 

Code includes several functions, which are provided in the function folder. All function are our own, with the exception of the AKDE1D code, which is provided in a separate folder along with the copywriter and license information (Botev, 2022). 

The overall workflow needed to produce the plots in Fig. 6 includes generating and saving the bootstrapping simulations, which are computationally substantial. The resulting files can then be used to generate cumulative departures and generate plots without having to re-run the simulations. 

Step 1: Run depAKDE.m to generate KDEs of measured age distributions.

This creates output files:

akde_Z_measured.csv, which contains all the AKDEs, with each one trimmed to the boundaries of the catchment
zPlot.csv, which is the elevation plotting space
nG.csv, which is the number of grains measured for each of the sediment sizes

Step 2: Run simsAll_AKDE.m to get the bootstrapping simulations done. This writes the output files containing the percentiles associated with departures from the median from the suite of simulations. It also uses the simulations to calculate exceedance probabilities of departures of specified fractions of the catchment elevations.

This code is currently set up to run a single sediment size at a time, but can easily be looped to run them all at once (see comments - looping requires changing one line of code).

Step 3: Run CumulativeDeps.m to consolidate the measured distribution and the simulations into plots showing the exceedance probabilities of the measured distribution. This is the final step that generates the plots in Figure 6.

This code is currently set up to run a single sediment size at a time, but can easily be looped to run them all at once (see comments - looping requires changing one line of code).


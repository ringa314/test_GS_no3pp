# test_GS_no3pp
test repository 
This repository contains the codes and data used to produce Figures for _"[TITLE]"_ by A. Ring (UDel), Y. Li (UDel), ,, ...

__Contact information:__ The [Computational Oceanography Lab](https://sites.udel.edu/yunli/) led by Dr. Yun Li (yunli@udel.edu) at the University of Delaware

## 1. Main Code
> ```
__All the main code scripts are found in the _"/mfiles"_ folder__
__The four scripts below (fig*.m) are used to generate Figures 1 to 4 in the paper's main text__
* __fig1_map.m__
  
  __Figure 1:__ (a) Map showing upwelling occurrence frequency in the southeast shelf region from the OfES dataset, identifying the outer shelf region and off-shelf upwelling region;
  (b) Map of three WHOI glider paths that pass through the study region during the bloom season to take _in situ_ measurements shown in Figure 2
  
* __fig2_glider.m__
  
  __Figure 2:__ (a-c) _In situ_ temperature and chlorophyll-a measurements in the Northern section of the southeastern shelf break;
  (d-f) Temperature and chlorophyll depth profiles in the central part of the study region; (g-i) Temperature, and chlorophyll depth profiles in the Southern part of the study region
  
* __fig3_yearmon.m__

  __Figure 3:__ (a) A year-month plot of the OfES-derived nitrate flux anomaly at the EUS shelf break at [DEPTH] between years 1992-2023;
  (b) A year-month plot of the VGPM surface NPP on the EUS outer shelf between years 2002-2023
  
* __fig4_reg.m__
  
  __Figure 4:__ (a) Scatter plot showing the relationship between OfES-derived nitrate flux anomaly at [DEPTH] and [PRODUCT] surface NPP;
  (b) A depth profile of average OfES-derived nitrate flux in the upwelling region, showing yearly averages 2002-2023 

__The four scripts below (figS*.m) are used to generate Figures S1 to S4 in the supplementary information__
* __figS1_regions.m__

  __Figure S1:__ Map comparing surface NPP from the VGPM dataset and chlorophyll-a from the GlobColour dataset in (a/c) the California region and (b/d) the southeast shelf region
  
* __figS2_wvel.m__
  
  __Figure S2:__ (a) Map comparing the mean and standard deviation of vertical velocity from the OfES dataset in (a/c) the California region and (b/d) the southeast shelf region

* __figS3_tser.m__
  
  __Figure S3:__ (a-b) Time series of OfES-derived nitrate flux at [DEPTH] between 1992-2023 and [MODEL] NPP between 2002-2023 in the California region;
  (c-d) Time series of OfES-derived nitrate flux at [DEPTH] between 1992-2023 and surface [MODEL] NPP between 2002-2023 in the southeast shelf region;
  
* __figS4_glider_offszn.m__

  __Figure S4:__ Doesn't currently exist, don't worry about it (a)  Map of three WHOI glider paths that pass through the study region during the off-season to take _in situ_ measurements;
  (b-c) _In situ_ temperature profiles and OfES-derived nitrate flux depth profiles taken at the shelf break region in the season of weak upwelling between [TIME];
  (d-e) Temperature and nitrate flux depth profiles between [TIME];
  (f-g) Temperature and nitrate flux depth profiles between [TIME];

## 2. Functions and Subroutines
* __info_params.m__
  
  Information used by all the MATLAB scripts __*.m__ to specify parameters used for creating figures
  
* __add_coast.m__

  Adds coastline and state boundaries to map figures
  
## 3. Data
__All the data used for figure generation can be found in the _"/MSdata"_ folder__
* __cmap_bathy12.mat__
  
  The RGB data used by __fig1_map.m__ to create a self-designed _bathymetry_ colormap

* __cmap_br64.mat__
  
  The RGB data used by __fig1_map.m__ and __figS2_wvel.m__ to create a self-designed _upwelling occurrence frequency_ colormap

* __cmap_chla.mat__
  
  The RGB data used by __fig2_glider.m__ to create a self-designed _CHL_ colormap

* __cmap_npp.mat__
  
  The RGB data used by __figS1_regions.m__ to create a self-designed _NPP_ colormap

* __cmap_temp.mat__
  
  The RGB data used by __fig2_glider.m__ to create a self-designed _Temp_ colormap

* __fig1.mat__
  
  The data used by __fig1_map.m__ to create Figure 1, including spatially resolved upwelling frequency occurrence from the OfES product, bathymetry and a mask of the mid- and outer-shelf region from the VGPM product, and spatially resolved glider tracks from the ERRDAP database

* __fig2.mat__
  
  The data used by __fig2_glider.m__ to create Figure 2, including depth profiles of chlorophyll-a and temperature from three gliders from the ERRDAP database

* __fig3.mat__
  
  The data used by __fig3_yearmon.m__ to create Figure 3, including temporally resolved OfES- and WOA-derived _Fnv_ anomaly and VGPM _NPP_ anomaly

* __fig4.mat__
  
  The data used by __fig4_reg.m__ to create Figure 4, including seasonal mean OfES- and WOA-derived _Fnv_ anomaly at a selected depth and seasonal mean surface NPP anomaly from the OSU VGPM product, as well as depth-resolved temporally averaged _Fnv_ and vertical volume flux from the OfES product

* __figS1.mat__
  
  The data used by __figS1_regions.m__ to create Figure S1, including spatially resolved mean chlorophyll-a from the ERRDAP database and mean _NPP_ from the OSU VGPM product

* __figS2.mat__
  
  The data used by __figS2_wvel.m__ to create Figure S2, including spatially resolved mean and standard deviations of the upwelling occurrence frequency from the OfES product

* __figS3.mat__
  
  The data used by __figS3_tser.m__ to create Figure S2, including a time series of the OfES- and WOA-derived _Fnv_ anomaly from 1992-2024, and a time series of _NPP_ anomaly from the OSU VGPM, CbPM, and Eppley-VGPM products from 2002-2023
  
## Acknowledgment


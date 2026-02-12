# test_GS_no3pp
test repository 
This repository contains the codes and data used to produce Figures for _"[TITLE]"_ by A. Ring (UDel), Y. Li (UDel), ,, ...

__Contact information:__ The [Computational Oceanography Lab](https://sites.udel.edu/yunli/) led by Dr. Yun Li (yunli@udel.edu) at the University of Delaware

## 1. Main Code
> ```
__The four scripts below (fig*.m) are used to generate Figures 1 to 4 in the paper's main text__
* __fig1_map.m__
  
  __Figure 1:__ (a) Map showing upwelling occurrence frequency in the EUS region from the OfES dataset, identifying the outer shelf region and off-shelf upwelling region;
  (b) Map of three WHOI glider paths that pass through the study region during the bloom season to take _in situ_ measurements shown in Figure 2
  
* __fig2_glider_prof.m__
  
  __Figure 2:__ (a-c) _In situ_ temperature and density measurements and OfES-derived nitrate flux at the EUS shelf break between [TIME];
  (d-f) Temperature, density, and nitrate flux depth profiles between [TIME]; (g-i) Temperature, density, and nitrate flux depth profiles between [TIME]
  
* __fig3_yearmon.m__

  __Figure 3:__ (a) A year-month plot of the OfES-derived nitrate flux anomaly at the EUS shelf break at [DEPTH] between years 1992-2023;
  (b) A year-month plot of the [PRODUCT] surface NPP on the EUS outer shelf between years 2002-2023
  
* __fig4_regress.m__
  
  __Figure 4:__ (a) Scatter plot showing the relationship between OfES-derived nitrate flux anomaly at [DEPTH] and [PRODUCT] surface NPP;
  (b) A depth profile of average OfES-derived nitrate flux in the upwelling region, showing yearly averages 2002-2023 

__The four scripts below (figS*.m) are used to generate Figures S1 to S4 in the supplementary information__
* __figS1.m__

  __Figure S1:__ Map comparing surface NPP from the [PRODUCT] dataset in (a) the California region and (b) the EUS region
  
* __figS2.m__
  
  __Figure S2:__ (a) 

* __figS3_.m__
  
  __Figure S3:__ (a-b) Time series of OfES-derived nitrate flux at [DEPTH] between 1992-2023 and [MODEL] NPP between 2002-2023 in the California region;
  (c-d) Time series of OfES-derived nitrate flux at [DEPTH] between 1992-2023 and surface [MODEL] NPP between 2002-2023 in the EUS region;
  
* __figS4_glider_prof_offszn.m__

  __Figure S4:__ (a)  Map of three WHOI glider paths that pass through the study region during the off-season to take _in situ_ measurements;
  (b-c) _In situ_ temperature profiles and OfES-derived nitrate flux depth profiles taken at the shelf break region in the season of weak upwelling between [TIME];
  (d-e) Temperature and nitrate flux depth profiles between [TIME];
  (f-g) Temperature and nitrate flux depth profiles between [TIME];

## 2. Functions and Subroutines
* __info_params.m__
  
  Information used by all the MATLAB scripts __*.m__ to specify parameters used for creating figures
  
  
## 3. Data
__All the data used for figure generation can be found in the _"./MSdata"_ folder__
* __cmap_NCP.mat__
  
  The RGB data used by __fig1_O2Ar_hist_map_yearly.m__ and __fig2_NCP_yr_map.m__ to create a self-designed _NCP_ colormap

## Acknowledgment


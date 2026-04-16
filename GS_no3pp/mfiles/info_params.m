% Define global parameters for analyses
%                     Yun Li, Udel, Jun-22-2021
%                     Adrian Ring 6/7/25
%                     Adrian Ring 1/21/2026

%###################
%## Variable Info ##
%###################
regions  = {'CAL', 'California Upwelling Zone'; ...
            'EUS', 'Southeastern Shelf Upwelling Zone'};            % study regions for comp
OSUprods = {'cbpm','vgpm','eppley','cafe'}; % npp products
WVELprods= {'OfES' ,'3d';'ECCO2','1d'};     % wvel products
NOSU = length(OSUprods);                    % number of npp products
GLinfo = {        %  'sp065_20240214T1520', 'sp062_20220623T1419', not crop the 300 m isobath
  'sp062_20211014T1515', datenum(2021,11,[15 28  ]), [0.95 0.60 0.48],1;
  'sp062_20211014T1515', datenum(2021,11,[27 32  ]), [0.95 0.60 0.48],0; 
  'sp062_20211014T1515', datenum(2021,12,[ 7 11  ]), [0.95 0.60 0.48],1;
  'sp065_20221116T1552', datenum(2022,12,[ 6 16  ]), [0.65 0.16 0.95],1;
  'sp065_20221116T1552', datenum(2022,12,[16 21.6]), [0.65 0.16 0.95],0;
  'sp065_20221116T1552', datenum(2022,12,[24 29  ]), [0.65 0.16 0.95],1;
  'sp007_20230208T1524', datenum(2023,02,[28 34  ]), [0    0.9  0.2 ],1;
  'sp007_20230208T1524', datenum(2023,03,[ 6  9.5]), [0    0.9  0.2 ],0;
  'sp071_20231220T1541', datenum(2024,01,[10 17  ]), [0    0    1   ],0;   % longitudinal (0) and latitudinal (1) winter profiles 
  'sp071_20231220T1541', datenum(2024,02,[11 15  ]), [0    0    1   ],1;
  'sp070_20240912T1432', datenum(2024,10,[16 21  ]), [0    0    1   ],0;
  'sp070_20240912T1432', datenum(2024,11,[ 0  5  ]), [0    0    1   ],1;
  'sp066_20241106T1639', datenum(2024,12,[ 0  8  ]), [0.25 0.00 0.25],0;
  'sp066_20241106T1639', datenum(2024,12,[11 16  ]), [0.25 0.00 0.25],1;
  'sp066_20241106T1639', datenum(2024,12,[16 21  ]), [0.25 0.00 0.25],0;
  'sp066_20241106T1639', datenum(2024,12,[28 34  ]), [0.25 0.00 0.25],1;
  'sp065_20210616T1430', datenum(2021,07,[ 8 18]), [1 0.1 0.1],1;
  'sp065_20210616T1430', datenum(2021,07,[18 24]), [1 0.1 0.1],0;    % longitudinal (0) and latitudinal (1) summer profiles
  'sp007_20210818T1548', datenum(2021,09,[15 21]), [1 0.1 0.5],1;
  'sp007_20210818T1548', datenum(2021,09,[21 24]), [1 0.1 0.5],0;  
  'sp070_20220824T1510', datenum(2022,09,[27 32]), [0 1   0  ],1;
  'sp070_20220824T1510', datenum(2022,10,[ 1  7]), [0 1   0  ],0;
  'sp062_20230823T1452', datenum(2023,09,[20 26]), [0 0.2 0.9],1;
  'sp062_20230823T1452', datenum(2023,09,[25 31]), [0 0.2 0.9],0;
  'sp062_20230823T1452', datenum(2023,10,[ 5 11]), [0 0.2 0.9],1;
  'sp069_20240703T1534', datenum(2024,08,[ 3 10]), [1 0   0  ],1};
Fvars = {'mask2D_nflux','mask2D_nflux_flt', ...
         'mask3D_nflux','mask3D_nflux_flt'};     % nflux variables for regression analysis
Ovars = {'npp','npp_flt'};                       % npp variables for regression analysis
Gvars = {'chl','chl_flt'};                       % chl variables
Finfo = {'F_{NV}'       ;'(mg N/m^2/day)';'F_{NV} (mg N/m^2/day)' ;{'F_{NV}';'(mg N/m^2/day)'}};
Oinfo = {'NPP'          ;'(mg C/m^2/day)';'NPP (mg C/m^2/day)'    ;{'NPP';'(mg C/m^2/day)'}};
Ginfo = {'Chlorophyll a';'(mg/m^3)'      ;'Chlorophyll a (mg/m^3)';{'Chlorophyll a';'(mg/m^3)'}};
%######################
%## file directories ##
%######################
% project data directory
fdir_data = '../MSdata/';                        % main directory for file achive
%fdir_data_OfES = '/home/yunli/papers/2025_HUNT/data/';
fetopo        = [fdir_data 'etopo1_ice_g_i2.bin'];               % ETOPO1 Bathymetry file
fcoast        = [fdir_data 'gshhs_i.b'];                          % file of coastline: f/h/i/c=fine,hi,interm,coarse
fstate        = [fdir_data 'cb_2018_us_state_500k.shp'];      % file state borders

% source file prefix
fpfx_T1d      = '/data/ECCO2/THETA_1d/THETA.1440x720x50.';        % prefix for ECCO2_1d T files
fpfx_W1d      = '/data/ECCO2/WVEL_1d/WVEL.1440x720x50.';          % prefix for ECCO2_1d W files
fpfx_OfES_W3d = '/data/OfES/NCEP_0p1deg_wvel/RRR_NCEP_OfES_wvel_';% prefix for OfES_3d W files
fpfx_OfES_T3d = '/data/OfES/NCEP_0p1deg_temp/RRR_NCEP_OfES_temp_';% prefix for OfES_3d T files
fpfx_WOA = '/data/WOA23/woa23_all_n';				   % prefix for WOA files
fpfx_cafe      = '/data/NPP_OSU_20231016/cafe_4320x2160/cafe.';    % prefix for cafe hdf file names
fpfx_cbpm      = '/data/NPP_OSU_20231016/cbpm_4320x2160/cbpm.';    % prefix for Cbpm hdf file names
fpfx_vgpm      = '/data/NPP_OSU_20231016/vgpm_4320x2160/vgpm.';    % prefix for Vgpm hdf file names
fpfx_eppley    = '/data/NPP_OSU_20231016/eppley_4320x2160/eppley.';% prefix for Eppley hdf file names
fpfx_gld      = [fdir_data 'GLIDER/'];                            % prefix for glider mat files
% derived datasets 
fgrd_OSU  = [fdir_data 'RRR_grid_OSU.mat'];% OSU grid for selected region 
fgrd_all  = [fdir_data 'RRR_grid.mat'];   % OSU+OfES+ECCO2 grids for selected region
fgrd_coast= [fdir_data 'RRR_coast.mat'];   % coastlines for selected region
fpfx_T    = [fdir_data 'RRR_T'];           % Regional Temperature
fpfx_W    = [fdir_data 'RRR_W'];           % Regional WVEL
% fT        = [fdir_data_OfES 'RRR_TXd_PPPP.nc']; % Regional Temperature % replace in step51 and step23
% fW        = [fdir_data_OfES 'RRR_WXd_PPPP.nc']; % Regional WVEL
fnpp      = [fdir_data 'RRR_npp_PPPP.nc']; % Regional npp
% colormaps
fcmap     = [fdir_data 'cmap_br64.mat'];           % npp chl colormap

%###############
%## grid info ##
%###############
% Region 1: East US Shelf
EUS.fcuts = [5:0.1:7]*0.1; % cutoff frequency of upwelling occurrence (0~1)
EUS.zmax  = 1100;          % max resolved depth
EUS.zref = -300;           % representative depth
EUS.fref = 0.55;           % reference frequency to gauge upwelling
EUS.lat  =  [25   38];     % area for data extraction
EUS.lon  =  [-85 -74];   
EUS.ltnpp = [30 35.5];     % npp mask limits
EUS.lgnpp = [-81 -75]; 
EUS.ltno3 = [30 33.5];     % nitrate mask coords
EUS.lgno3 = [-78 -75];
EUS.ylims = [29.5 36];     % map coords
EUS.xlims = [-81.2 -74.5]; 
EUS.mapy  = [28   36];    % area for data extraction
EUS.mapx  = [-82 -74]; 
EUS.yticks = 20:2:36;   EUS.yticklabels = num2str( EUS.yticks','%4.0f^oN');
EUS.xticks = -81:2:-75; EUS.xticklabels = num2str(-EUS.xticks','%4.0f^oW');
EUS.mapyticks = 28:2:36;
EUS.mapxticks = -84:2:-74;
EUS.cts = [-20 -300 -1000 -4000];
EUS.zid = 24; % zr(zid) %288m for ofes
EUS.zids = 1:25;
EUS.wd_nflux = [datenum(-1,12,1) datenum(0,3,1)]; % subject to change
EUS.wd_npp   = [datenum( 0, 2,1) datenum(0,6,1)];
EUS.FNVdur = 60;
% Region 2: California Coastal Region
CAL.fcuts = [5:0.1:8]*0.1; % cutoff freq for upwelling occurrence
CAL.zmax = 800;
CAL.zref = -50;
CAL.fref = 0.55;
CAL.lat =   [  30   48];  % area for data extraction
CAL.lon =   [-130 -115];
CAL.ltnpp = [32.5 38.5];    % npp mask limits
CAL.lgnpp = [-130 -115]; 
CAL.ltno3 = [30     48];
CAL.lgno3 = [-130 -115]; % nitrate mask coords
CAL.xlims = [-130 -115]; %area for plot
CAL.ylims = [30     48]; % redundant?
CAL.mapx =  [-126 -116]; %area for plot
CAL.mapy =  [32     40];
CAL.yticks = 30:2:50;     CAL.yticklabels = num2str( CAL.yticks','%4.0f^oN');
CAL.xticks = -129:2:-105; CAL.xticklabels = num2str(-CAL.xticks','%4.0f^oW');
CAL.mapyticks = 32:2:40;
CAL.mapxticks = -126:2:-116;
CAL.cts = [-100 -4000 -3000]; % contours (first 2 define npp zone)
CAL.zid = 10; % zr(zid)
CAL.zids = 1:25;
CAL.wd_nflux = [datenum(0,4,1) datenum(0,10,1)]; % subject to change
CAL.wd_npp   = [datenum(0,6,15) datenum(0,10,15)];
CAL.FNVdur = 60; 
%############
% time vars #
%############
wyears = 1992:2023; Nwyrs = length(wyears);  % WOA years
nyears = 2002:2024; Nnyrs = length(nyears);  % npp years
ayears = 1992:2024; Nayrs = length(ayears);% all possible years
dref = datenum(1992,1,1);

%################
%## thresholds ##
%################
fcut = 0.55;           % mask cut frequency
dcutdays = 200;        % low-pass filter
mis_val = 0;

%################
%## parameters ##
%################
GRAV = 9.8;               % gravitational acceleration (unti: m/s^2)
Re   = 6.378E6;           % equatorial radius of Earth (unit: m)
rho0 = 1023.6;            % seawater density (kg/m^3)
cff_day2sec = 86400;      % 1 day -> 86400 secs
cff_mol2gN = 14;          % 1 molN -> 14g N 
cff_mol2gC = 12;          % 1 molC -> 12g C
cff_molN2C = 106/16;      % Redfield ratio C:N = 106:16
cff_micro2milli = 1E-3;   % 1 micro- = 1E-3 milli-
%cff_kilo2milli = 1E6;
cff_deg2m= 2*pi*Re./360;  % 1 deg at equater in meter
cff_cm2m = 1E-2;          % 1 cm = 10^-2 m
cff_FNV2Funit = cff_day2sec*cff_micro2milli*cff_mol2gN; % FNV umolN/m2/sec -> mgN/m2/day

%#####
% misc
%#####
load ../MSdata/cmap_bathy12.mat; cmap_bathy = flipud(cmap);
load ../MSdata/cmap_br64.mat;    cmap_freq = cmap;
load ../MSdata/cmap_npp.mat;     cmap_npp = cmap;
color_land = [1 1 1]*0.90;
color_cts  = [1 1 1]*0.35;
color_npp  = [0.8 0.9 0.66];
color_border = [1 0.8 0.6]*0.25;
htmlGray = [128 128 128]/255;

%###################
%## figure labels ##
%###################
mlabels = {'(A)','(B)','(C)','(D)','(E)',...
           '(F)','(G)','(H)','(I)','(J)',...
           '(K)','(L)','(M)','(N)','(O)',...
           '(P)','(Q)','(R)','(S)','(T)',...
           '(U)','(V)','(W)','(X)','(Y)','(Z)'...
          };


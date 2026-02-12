% Define global parameters for analyses
%                     Yun Li, Udel, Jun-22-2021
%                     Adrian Ring 6/7/25
%                     Adrian Ring 1/21/2026

%###################
%## Variable Info ##
%###################
regions  = {'CAL','EUS'};                   % study regions for comp
OSUprods = {'cbpm','vgpm','eppley','cafe'}; % npp products
WVELprods= {'OfES' ,'3d';'ECCO2','1d'};     % wvel products
NOSU = length(OSUprods);                    % number of npp products
GLinfo = {'sp062_20211014T1515', [datenum(2021,11,15) datenum(2021,11,28)],[0.95 0.60 0.48],[-77.1 33.5]; ... % Glider tracks
          'sp065_20221116T1552', [datenum(2022,12, 7) datenum(2022,12,19)],[0.65 0.16 0.95],[-78.25 32.8];
          'sp066_20241106T1639', [datenum(2024,12,10) datenum(2024,12,17)],[0.88 0.86 0.215],[-77.4 33.13]};

%######################
%## file directories ##
%######################
% project data directory
fdir_data = '../MSdata/';                        % main directory for file achive
fdir_data_OfES = '/home/yunli/papers/2025_HUNT/data/'; % only shows up in info_params
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
fpfx_gld      = [fdir_data_OfES 'GLIDER/'];                            % prefix for glider mat files
% derived datasets 
fgrd_OSU  = [fdir_data_OfES 'RRR_grid_OSU.mat'];% OSU grid for selected region 
fgrd_all  = [fdir_data 'RRR_grid.mat'];   % OSU+OfES+ECCO2 grids for selected region
fgrd_coast= [fdir_data_OfES 'RRR_coast.mat'];   % coastlines for selected region
fpfx_T    = [fdir_data 'RRR_T'];           % Regional Temperature
fpfx_W    = [fdir_data 'RRR_W'];           % Regional WVEL
% fT        = [fdir_data_OfES 'RRR_TXd_PPPP.nc']; % Regional Temperature % replace in step51 and step23
% fW        = [fdir_data_OfES 'RRR_WXd_PPPP.nc']; % Regional WVEL
fnpp      = [fdir_data 'RRR_npp_PPPP.nc']; % Regional npp
% colormaps
fcmap     = [fdir_data 'cmap_br64.mat'];           % blue-to-red colormap

%###############
%## grid info ##
%###############
% Region 1: East US Shelf
EUS.fcuts = [5:0.1:7]*0.1; % cutoff frequency of upwelling occurrence (0~1)
EUS.zmax  = 1100;          % max resolved depth
EUS.zref = -50;           % representative depth
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
GRAV = 9.8;          % gravitational acceleration
rho0 = 1023.6;       % seawater density
Re = 6.378E6;        % equatorial radius of Earth in meters
cff_deg2m = 2*pi*Re./360;% 1 deg at equator in meter
cff_day2sec = 86400;     % 1 day = 86400 s
cff_mol2gN = 14;         % 1mol N = 14g N
cff_micro2milli = 1E-3;  % 1 micro = 1e-3 milli
cff_cm2m = 1E-2;     % 1 cm = 1E-2 m

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


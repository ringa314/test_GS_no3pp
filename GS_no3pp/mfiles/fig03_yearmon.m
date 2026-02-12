% figure: year-month evolution of nflux + npp for EUS
%  - vertical no3 flux at a selected depth
%  - cbpm npp
%
%           Adrian Ring, 1/29/26

close all; clear; clc; info_params;
%========================================================
% User-defined parameter
region = 'EUS'; WVELprod = 'OfES'; OSUprod = 'cbpm';
fin = [fdir_data region '_ym_fig3.mat']; % year-month aggregated 
ffig = '../figures/fig3_yearmon'; % make sure i'm pulling from the right place (TBD)
%========================================================
eval(['Reg = ' region ';'])

%##########################
%## year-month plot data ##
%##########################
load(fin);                                % wvel product chosen
years = ym.years;                     % years of data
switch WVELprod; 
case{'ECCO2'}; twvel = ym.t1d;        % 1-day timestep
case{'OfES'};  twvel = ym.t3d; end    % 3-day timestep (OfES)
t8d = ym.t8d;                         % 8-day timestep (cbpm)
zid = ym.zid;                         % representative depth
fid = ym.fid;                         % chosen foccu (.55)
zr = ym.(WVELprod).zr;
FNV_flt = ym.(WVELprod).FNV_flt;      % extract the no3 flux
npp_flt = ym.(OSUprod).npp_flt;          % extract the npp
 
%#######################
%## figure properties ##
%#######################
fgx=0.08; fgw=0.78; fgdw=0.80;
fgy=0.55; fgh=0.30; fgdh=0.42;
fsize = 8; colormap(jet);
xlims = years([1 end]);
xticks = years(1:2:end);
xticklabels = datestr(datenum(xticks,1,1),'yy');
ylimsw= datenum([0 1], 5,15);
ylimsp= datenum([0 1],11,15);
yticks = datenum(0,2:2:48,1);
yticklabels = datestr(yticks,'mmm');

%######################
%## year-month plots ##
%######################
% nflux plot
ylims = datenum([0 1],11,15);
axes('Position',[fgx fgy fgw fgh])
pcolor(years,twvel,FNV_flt'); shading interp
set(gca,'fontsize',fsize,...
    'xlim',xlims ,'xtick',xticks,'xticklabel',xticklabels,...
    'ylim',ylimsw,'ytick',yticks,'yticklabel',yticklabels); box on;
ylabel('Month','fontsize',fsize+2);
set(gca,'layer','top')
title(sprintf('a) EUS Vertical Nitrate Flux at %3.0f m' ,zr(zid)))
ha = colorbar('vert','position',[fgx+fgdw fgy 0.02 fgh]);
caxis([-0.02 0.18]);
set(get(ha,'ylabel'),'string','F_{NV}\mumol N/m^2/sec','fontsize',fsize+2);
% npp plot
axes('Position',[fgx fgy-fgdh fgw fgh])
pcolor(years,t8d,npp_flt'./1E3); shading interp; caxis([0.8 1.3])
set(gca,'fontsize',fsize,...
    'xlim',xlims ,'xtick',xticks,'xticklabel',xticklabels, ...
    'ylim',ylimsp,'ytick',yticks,'yticklabel',yticklabels); box on;
set(gca,'layer','top')
hco = colorbar('position',[fgx+fgdw fgy-fgdh 0.02 fgh]);
set(get(hco,'ylabel'),'string','NPP (gC/m^2/day)','fontsize',fsize+2);    
colormap 'jet'
title 'b) NPP on EUS Outer Shelf'
ylabel('Month','fontsize',fsize+2);
xlabel('Year','fontsize',fsize+2);
return;

%#################
%## save figure ##
%#################
print("-dpng",'-r300',ffig)
print("-dpng",'-r300',ffig)

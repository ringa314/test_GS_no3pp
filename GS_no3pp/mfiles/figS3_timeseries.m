% time series of nflux and npp 
% nitrate flux 1992-2023
% CbPM npp 2003-2021
%
% Adrian Ring, 2/4/2026

close all; clear; clc; info_params;
fin = '../../GS_no3pp/MSdata/_tseries_figS3.mat';
ffig = '/home/ringa/proj/final/figS3_timeseries';
OSUprod = 'eppley';
%============================================
%##################
% figure properties
%##################
fgx=0.1; fgw=0.87; fgh=0.15;
fsize = 10; 
tlims = datenum([1992 2025],1,1);
tticks = datenum([1992:2:2025],1,1);
tticklabels = datestr(tticks,'yy');
flux_lims = [-0.1 0.5];
npp_lims  = [500 1700];

for kk = 1:length(regions) % loop for CAL and EUS
  region = regions{kk};
  eval(['Reg = ' region ';']);
        
    %##########
    % load data
    %##########
    % nitrate flux time series data
    load(fin);
      ftime =  tser.ftime;
      flux_flt = tser.flux_flt; % 200-day average filter nitrate flux
      flux = tser.flux;       %daily mean nitrate flux (umol/m^2/s)
      zr = tser.zr;
    % npp time series data
      ntime = tser.ntime;
      mnpp_flt = tser.(OSUprod).mnpp_flt; % 200-day average filter npp
      mnpp = tser.(OSUprod).mnpp;        % 8-day mean npp (mgC/m^2/day)
    
    for kw = 1:2 % loop for nflux and npp
      if kw == 1; wrk = flux; wrk_flt = flux_flt; ylims = flux_lims; time = ftime; 
                  color = 'red'; keylab = 'Daily Flux'; ylab = '(\mumol/m^2/s)'; end % nflux
             if kw == 1 & kk == 1; desc = 'Nitrate Flux on %s Shelf at %3.0f m'; fgy = 0.81; end % CAL nflux
             if kw == 1 & kk == 2; desc = 'Nitrate Flux off %s Shelf at %3.0f m'; fgy = 0.31; end % EUS nflux
      if kw ==2 ; wrk = mnpp; wrk_flt = mnpp_flt; ylims = npp_lims;  time = ntime; 
                  color = 'green'; keylab = '8-day NPP'; ylab = '(gC/m^2/day)'; end % npp
             if kw == 2 & kk == 1; desc = 'Net Primary Production on %s shelf %{}f'; fgy = 0.56; end % CAL npp
             if kw == 2 & kk == 2; desc = 'Net Primary Production on %s Outer shelf %{}f'; fgy = 0.07; end % EUS npp
    %#####################
    % figure time series
    %#####################
    axes('Position', [fgx fgy fgw fgh])
    plot(time, wrk, 'color', '#909090','Linewidth',0.1); hold on;
    plot(time, wrk_flt, 'color', color,'LineWidth',1.75); grid on;
    set(gca, 'fontsize', fsize-2, 'xlim', tlims, 'xtick', tticks, 'xticklabel', tticklabels,...
             'ylim', ylims);
        title(sprintf(desc,region,zr(Reg.zid)), 'fontsize', fsize); 
        ylabel(ylab, 'fontsize', fsize-1);
    hold on;
    legend({keylab, 'Low-pass Filter'}, 'fontsize', fsize-4, 'Location','northwest');
    if kw == 2 & kk == 2; xlabel('Years'); end
    end
end
print("-dpng",'-r300',ffig)
print("-dpng",'-r300',ffig)
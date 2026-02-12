% Regression plot npp vs NO3 flux for EUS
%
%            Adrian ring, 5/12/25
%            Adrian Ring, 9/9/25
close all; clear; clc; info_params;
%===========================================
region = 'EUS';
OSUprod = 'eppley';
%fin = [fdir_data region '_yearmon.mat']; % year-month aggregated 
%fnflux = [fdir_data region '_nflux.mat'];
%fin = [fdir_data region '_regress_' datestr(EUS.wd_npp(1),'mmdd') 't' datestr(EUS.wd_npp(2),'mmdd') '.mat'];
fin = '../../GS_no3pp/MSdata/_reg_fig4.mat';
ffig = '../MSfig/fig4_reg';
%===========================================
% figure properties%
fgx = 0.12; fgw = 0.43; fgdw = 0.53;
fgy = 0.12; fgh = 0.8;
fsize = 12;

%###########
% Load data
%###########
load(fin); eval(['Reg = ' region ';']); % regression plot
ynpp = rg.(OSUprod).ynpp;
yflux = rg.yflux; % 33 years x 80 time windows x 1 depth x frequency
%load(fnflux)                            % depth flux plot
zr = rg.zr;
nflux = rg.nflux; % 
nflux_mean = rg.nflux_mean;
nflux_std = rg.nflux_std;

%#################
% plot npp and no3
%#################
axes('Position', [fgx fgy fgw fgh]);
sz = 240; idx = (1:33);
%wdyears = wdyears(2:end);
scatter(yflux(idx,1),ynpp(idx), sz, 'b','filled','MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0 0 0]);
hold on
idx = (1:21);
scatter(yflux(idx,1),ynpp(idx), sz,'b','filled','MarkerEdgeColor',[0 .4 .4],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',2)
idx = 22:33; 
scatter(yflux(idx,1),ynpp(idx), sz,'b','filled','MarkerEdgeColor',[1 .1 .1],...
              'MarkerFaceColor',[1 .3 .3],...
              'LineWidth',2)
yy = num2str(mod(ayears(:),100),'%2.2i');    % 2-digit year string
text(yflux(1:end,1),ynpp(1:end),yy,'color','w','fontsize',fsize-2,'hor','cen','vert','mid','fontweight','bold');
set(gca,'fontsize', fsize-3,...
    'xlim',[0.0 0.3], 'xtick', 0:0.2:1.2,...
    'ylim',[730 1200], 'ytick',750:50:1200);
% plot redfield ratio 
  %   Carbon    106 molC   12.011 gC   1000 mgC  1 molN      1273166 mgC  
  %  -------- = -------- x --------- x ------- x --------- = --------------
  %  Nitrogen   16 molN     1 molC       1 gC    1E6 umolN   16000000 umolN
x = (0:100);
y = x*(106/16)*12.011*86400/1000; 
plot(x,y,'Color',htmlGray)

txt = {'Prediction from Redfield Ratio'};
h = text(0.14,900,txt);
set(h,'Rotation',83,'Color',htmlGray)
title('Surface NPP vs Nitrate Flux at 288 m', 'fontsize', fsize);
xlabel('NO3 Flux Dec-Feb (\mumol/m^2/s)', 'fontsize',fsize-1);
ylabel('NPP Feb-May (mg C/m^2/day)', 'fontsize',fsize-1);

%###################
% plot flux vs depth
%###################
axes('Position', [fgx+fgdw fgy fgw*0.7 fgh]);
h1 = plot(nflux(:,12)', zr, 'Color', [0.2 0.8 0.8]);
hold on;
h2 = plot(nflux(22,:), zr, 'Color', [0.7 0.3 0.3]);
h4 = plot(nflux(12:21,:), zr, 'Color', [0.2 0.8 0.8]);
h5 = plot(nflux(22:33,:), zr, 'Color', [0.7 0.3 0.3]);
h3 = errorbar(nflux_mean, zr, nflux_std,'horizontal', 'black', 'LineWidth', 2);
set(gca,'fontsize', fsize-3, ...
    'xlim', [0 1.8], 'xtick', 0:0.4:1.8, ...
	'ylim', [-400 -90], 'ytick', -400:50:-100);
title('Nitrate Flux', 'fontsize', fsize);
ylabel('Depth (m)','fontsize',fsize-1);
xlabel('Mean Nitrate Flux (\mumol/m^2/s)','fontsize',fsize-1);
legend([h1 h2 h3], '2003-2012','2013-2023','Mean 2003-2023', 'Location','northeast','fontsize',fsize-5);

print("-dpng",'-r300',ffig)
print("-dpng",'-r300',ffig)

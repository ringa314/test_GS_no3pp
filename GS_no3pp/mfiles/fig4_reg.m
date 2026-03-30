% Figure 4: Regression plot npp vs NO3 flux 
% for southeast US shelf
% vgpm and OfES datasets
%         
% by Adrian Ring and Yun Li
close all; clear; clc; info_params;
%===========================================
Oprod = 'vgpm'; % here or in get_fig?
fin = [fdir_data 'fig4.mat'];
ffig = '../MSfig/fig4_reg';
%===========================================

%#######################
%## figure properties ##
%#######################
fgx = 0.1; fgw = 0.4; fgdw = 0.5;
fgy = 0.25; fgh = 0.65;
fsize = 10;
xlims = [-1 1]*55; xticks = -50:20:50; xdesc = 'F_{NV} anomalies (mg N/m^2/day)';
ylims = [-1 1]*300; yticks = -300:50:300; ydesc = 'NPP anomalies (mg C/m^2/day)';

%###########
% Load data
%###########
load(fin);  % regression plot
ynpp = f4.(Oprod).ynpp;
yflux = squeeze(f4.yflux); % sept 1 offset x 90-day time window x 300-m depth x 33 years
zr = f4.zr;
nflux_mean = squeeze(f4.nflux_mean); % mg N /m^2/day
nflux_std = squeeze(f4.nflux_std);
wflux_mean = f4.wflux_mean; % m^3/day
wflux_std = f4.wflux_std;

%#################
% plot npp and no3
%#################
axes('Position', [fgx fgy fgw fgh]);
sz = 240; idx = (1:33); b = zeros(1:3);
scatter(yflux(idx,1),ynpp(idx), sz, 'b','filled','MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0 0 0]);
hold on
idx = (1:20);
scatter(yflux(idx,1),ynpp(idx), sz,'b','filled','MarkerEdgeColor',[0 .4 .4],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',2);
idx = 21:33; 
scatter(yflux(idx,1),ynpp(idx), sz,'b','filled','MarkerEdgeColor',[1 .1 .1],...
              'MarkerFaceColor',[1 .3 .3],...
              'LineWidth',2);
yy = num2str(mod(ayears(:),100),'%2.2i');    % 2-digit year string
text(yflux(1:end,1),ynpp(1:end),yy,'color','white','fontsize',fsize-2,'hor','cen','vert','mid','fontweight','bold');
set(gca,'tickdir', 'out', 'fontsize', fsize-3,...
    'xlim',xlims, 'xtick', xticks,...
    'ylim',ylims, 'ytick',yticks);

% plot redfield ratio 
  %   Carbon    106 molC   12.011 gC   1000 mgC  1 molN      1 gN       1273166 mgC  
  %  -------- = -------- x --------- x ------- x --------- x --------  = --------------
  %  Nitrogen   16 molN     1 molC       1 gC    14.007 gN   1000 mgN     224112 mgN
x = (-100:100);
y = x*(106/16)*12.011*1000/14.007/1000; 
Redfield = plot(x,y,'Color',htmlGray);
txt = {'Redfield Ratio'};
h = text(26,110,txt);
set(h,'Rotation',53,'Color',htmlGray)
xlabel(xdesc, 'fontsize',fsize-1);
ylabel(ydesc, 'fontsize',fsize-1);

%###################
% plot flux vs depth
%###################
pos = [fgx+fgdw fgy fgw*0.9 fgh];
% the 1st layer
axes('Position', pos,'YAxisLocation','left','XAxisLocation','bottom');
hold on
h1 = plot(nflux_mean, zr, 'Color', [1 0.2 0.2]);
patch([nflux_mean-nflux_std flip(nflux_mean+nflux_std)],...
      [zr' flip(zr')],[1 0.4 0.4],'facealpha',0.5, 'linestyle', 'none')
set(gca,'tickdir', 'out','fontsize', fsize-3, ...
    'xlim', [0 2250], 'xtick', 0:500:2000, ...
	'ylim', [-600 0], 'ytick', -600:50:0);
xlabel('Mean Nitrate Flux (mg/m^2/day)','fontsize',fsize-1);
ylabel('Depth (m)','fontsize',fsize-1);
% the 2nd layer
axes('Position', pos,'YAxisLocation','right','XAxisLocation','top','Color','none');
hold on
h4 = plot(wflux_mean, zr, 'Color', 'black');
patch([wflux_mean-wflux_std flip(wflux_mean+wflux_std)],...
      [zr' flip(zr')],[0.4 0.4 0.4],'facealpha',0.5, 'linestyle', 'none')
set(gca,'tickdir','out','fontsize', fsize-3, ...
    'xlim', [0 10], 'xtick', 0:2:10, ...
	'ylim', [-600 0], 'ytick', -600:50:0,'YTickLabel','');
xlabel('Mean Volume Flux (m/day)','fontsize',fsize-1);
legend([h1 h4], 'NO3 Flux','Volume Flux', 'Location','west','fontsize',fsize-4);

disp([ ' OfES: depth = ' num2str(f4.zr(f4.zid),'%3.0f m') ...
                           ', tid = ' num2str(f4.NPPstr(f4.tid),'%4.2f')]);

print("-dpng",'-r300',ffig)
print("-dpng",'-r300',ffig)

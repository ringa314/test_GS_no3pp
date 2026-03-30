% figure 3: year-month evolution of nflux + npp 
% for southeast US shelf
%  - OfES vertical no3 flux at 300 m
%  - cbpm npp
%
% by Adrian Ring and Yun Li

close all; clear; clc; info_params;
%========================================================
% User-defined parameter
region = 'EUS'; Oprod = 'cbpm';
%fin = [fdir_data region '_yearmon.mat']; % year-month aggregated 
fin = [fdir_data 'fig3.mat'];
ffig = '../MSfig/fig3_yearmon';        % generated figure name 
%========================================================
eval(['Reg = ' region ';'])
%#######################
%## figure properties ##
%#######################
fgx=0.10; fgw=0.70; fgdw=0.72;
fgy=0.55; fgh=0.38; fgdh=0.45;
fsize = 8; colormap(jet);

%##########################
%## year-month plot data ##
%##########################
load(fin); years = f3.years;          % years of data
wrk = f3.OfES;                     % FNV product chosen
[~,zid] = min(abs(wrk.zr-Reg.zref));      % representative depth
FNV_flt = wrk.FNV_flt;
npp_flt = f3.(Oprod).npp_flt; %squeeze(ymplot.OSU.npp_flt_anom(:,:,Oid));  % extract the npp

%###################
%## plot settings ##
%###################
xlims = years([1 end]);                   % x-axis lims
xticks = years(1:2:end);                  % x-axis ticks
xticklabels = datestr(datenum(xticks,1,1),'yy'); % x-axis ticklabels
ylimsw= datenum([1 2],1,0)+[-1 1]*5;      % FNV y-axis start time
ylimsp= datenum([1 2],1,0)+[-1 1]*5;      % NPP y-axis start time
yticks = datenum(0,1:2:48,1);             % y-axis ticks
yticklabels = datestr(yticks,'mmm');      % y-axis ticklabels
 
%######################
%## year-month plots ##
%######################
for kv = 1:2
  if kv==1; vwrk = FNV_flt; vtim = wrk.t3d;          % nflux plot 
	    clims = [-100 100]; ylims = ylimsw;
	    desc = {'F_{NV} anomalies';'(mg N/m^2/day)'};
            disp(['(A) ' region ' Vertical Nitrate Flux anomalies at ' num2str(wrk.zr(zid),'%3.0f m')]); end 
  if kv==2; vwrk = npp_flt; vtim = f3.t8d;   % npp plot 
	    clims = [-1.5 1.5]*1E2; ylims = ylimsp;
	    desc = {'NPP anomalies';'(mg C/m^2/day)'};
            disp(['(B) ' region ' mid-shelf NPP anomalies']); end
  dt = 0.5*diff(vtim(1:2));

axes('Position',[fgx fgy-fgdh*(kv-1) fgw fgh],'Yaxislocation','left','Xaxislocation','top');
  %pcolor(years-0.5,vtim-0.5*dt,vwrk'); shading interp; caxis(clims);
  set(gca,'tickdir','out','fontsize',fsize,'FontName','Courier',...
     'xlim',xlims,'xtick',xticks,'xticklabel',{''},...
     'ylim',ylims,'ytick',yticks,'yticklabel',yticklabels); box on;
  hold on
  axes('Position',[fgx fgy-fgdh*(kv-1) fgw fgh],'Yaxislocation','right','Xaxislocation','bottom');
  pcolor(years-0.5,vtim-0.5*dt,vwrk'); shading interp; caxis(clims);
  set(gca,'tickdir','out','fontsize',fsize,...
     'xlim',xlims,'xtick',xticks,'xticklabel',xticklabels, ...
     'ylim',ylims,'ytick',yticks,'yticklabel',{''}); box on;
  set(gca,'layer','top')
  text(xlims(1)+diff(xlims)*0.02,ylims(2)-diff(ylims)*0.05,mlabels{kv},...
       'fontsize',fsize+3,'fontweight','bold','horiz','left','vert','top'); xtickangle(0);
  ha = colorbar('vert','position',[fgx+fgdw fgy-fgdh*(kv-1) 0.02 fgh],'fontname','arial');
  set(get(ha,'ylabel'),'string',desc,'fontsize',fsize+1,'fontname','arial');
end
ylabel('Month','fontname','Arial','fontsize',fsize+1,'position',[xlims(1)-diff(xlims)*0.07 ylims(2) 0]);
xlabel('Year','fontname','Arial','fontsize',fsize+1);

%#################
%## save figure ##
%#################
print("-dpng",'-r300',ffig)
print("-dpng",'-r300',ffig)

% Model and Glider data of temperature, nflux and chl
% during the bloom season.
%                   Adrian Ring, UDel, Nov-04-2025
%                        Yun Li, UDel, Jan-11-2026

close all; clear all; clc; info_params; 
%==================================================
% User-defined parameters
Gids = [3 2 1 6 5 4 15 14 13];     % id of Ginfo
fin = [fdir_data 'fig2.mat']; load(fin);
ffig = '../MSfig/fig2_glider';
%==================================================
%#######################
%## figure properties ##
%#######################
fgx=0.15; fgw=0.18; fgdw = 0.205;
fgy=0.73; fgh=0.15; fgdh = 0.20;
fsize = 4; msize = 9;
load([fdir_data 'cmap_chla']); cmap_chl = cmap;
load([fdir_data 'cmap_temp']); cmap_temp = cmap;

for kg = 1:length(Gids)
  %######################
  %## load glider data ##
  %######################
  gid = Gids(kg); S = strrep(GLinfo{gid,1},'_','-');             % index in the Ginfo list (info_params.m)
  Gdir = GLinfo{gid,end};                    % GL transect info
  dep = f2(kg).dep;
  tid = f2(kg).tid;
  time = f2(kg).time;
  chla = f2(kg).chla;
  lon = f2(kg).lon; 
  lat = f2(kg).lat;
  temp = f2(kg).temp;
  Oh = f2(kg).Oh;
  name = f2(kg).name;
  if Gdir==0; xx = lon; xunit = 'W'; end
  if Gdir==1; xx = lat; xunit = 'N'; end
  xlims = [min(xx) max(xx)]+[-1 1]*0.02;
  tdesc = [mlabels{mod(kg-1,3)*3+ceil(kg/3)} ' '...
	   datestr(time(tid(1)),'mmm-dd') ' to ' datestr(time(tid(end)),'mmm-dd')];

  %#####################
  %## subpanel - chla ##
  %#####################
  ha = axes('pos',[fgx+fgdw*floor((kg-1)/3) fgy-fgdh*1.3*mod(kg-1,3)+fgdh*0.6 fgw fgh*0.4]); hold on;
  scatter(xx,-dep,msize, chla,'filled'); caxis([0 0.5]);
  plot(xx,Oh,'k'); colormap(ha,cmap_chl); ylims = [-260 0];
  set(gca,'fontsize',fsize,'tickdir','out',...
          'xlim',xlims,'xticklabel','','ylim',ylims,'ytick',-300:100:0); 
  box on; set(gca,'layer','top');
  if kg>3; set(gca,'yticklabel',''); end
  if Gdir==1; set(gca,'xdir','reverse'); end
  if mod(kg,3)==1; ...
     text(mean(xlims),ylims(2)+diff(ylims)*0.5,datestr(time(1),'yyyy'),'fontsize',fsize+2,'fontweight','bold','horiz','cen'); 
     text(mean(xlims),ylims(2)+diff(ylims)*0.2,S,'fontsize',fsize,'horiz','cen'); end
  if kg==9;
     hco = colorbar('vert','position',[fgx+fgdw*3,fgy-fgh*1.2,0.015,fgh*2.2],'fontsize',fsize+1);
     ylabel(hco,Ginfo{3},'fontsize',fsize+2); set(hco,'ytick',-0.1:0.1:1); end

  %#####################
  %## subpanel - temp ##
  %#####################
  hb = axes('pos',[fgx+fgdw*floor((kg-1)/3) fgy-fgh*0.3-fgdh*1.3*mod(kg-1,3) fgw fgh]); hold on;
  scatter(xx,-dep,msize, temp,'filled'); caxis([0 30]);
  plot(xx,Oh,'k'); colormap(hb,cmap_temp); ylims = [-1000 0];
  xtxt = xlims(1)+diff(xlims)*0.02;
  set(gca,'fontsize',fsize,'tickdir','out','xlim',xlims,'ylim',ylims,'ytick',-900:300:0);
  box on; set(gca,'layer','top');
  if Gdir==1; set(gca,'xdir','reverse'); xtxt = xlims(2)-diff(xlims)*0.02; end
  tmp = get(gca,'xtick'); tmp = num2str(tmp',['%4.1f^o' xunit]); set(gca,'xticklabel',tmp);
  text(xtxt,ylims(2)-diff(ylims)*0.1,tdesc,'fontsize',fsize+1,'fontweight','bold');
  if kg>3; set(gca,'yticklabel',''); end
  if kg==2; ylabel(hb,'depth (m)','fontsize',fsize+2); end
  if kg==9;
     hco = colorbar('vert','position',[fgx+fgdw*3,fgy-fgh*0.1-fgdh*1.3*mod(kg-1,3),0.015,fgh*2.2],'fontsize',fsize+1);
     ylabel(hco,'temperature (\circC)','fontsize',fsize+2); end
end

%#################
%## save figure ##
%#################
print('-dpng','-r300',ffig)
print('-dpng','-r300',ffig)


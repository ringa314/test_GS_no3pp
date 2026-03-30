% Figure 1: Upwelling occurence frequency + bathymetry glider track plots
% for Southeastern shelf region
% using OfES dataset
%
% by Adrian Ring and Dr Yun Li

clear; close all; clc; info_params;
%====================================
% edit based on user's needs
region = 'EUS'; % select southeast shelf     
Gids = [3 2 1 6 5 4 15 14 13];     % id of Ginfo for gliders
fin = [fdir_data 'fig1.mat']; 
ffig = '../MSfig/fig1_map';
%====================================
eval(['Reg = ' region ';']); 
ffig = [ffig '_' num2str(abs(Reg.zref),'%3.0fm')]; % append depth info to fig name

%#######################
%## figure properties ##
%#######################
fgx = 0.12; fgw = 0.40; fgdw = 0.44; fgcw = 0.022;
fgy = 0.10; fgh = 0.70; fgdh = 0.72; fsize = 8;

%###############
%## Load data ##
%###############
load(fin);
zid = f1.zid;                  % representative depth
foccu = f1.foccu;              % extract the freq at the selected depth
masknpp = f1.mask_npp;                   % outer shelf mask for npp
idx = find(f1.maskf2D==1 ...   % extract 2D mask for nflux ...
	 & f1.f_hetopo<Reg.cts(2));       %  and Bathymetry
disp(sprintf('%s\n%s%s\n%s',repmat('#',[1 35]),repmat(' ',[1 10]),...
             'Figure 1',repmat('#',[1 35])))
disp([' - depth   ' num2str(f1.zr(zid),'%3.0f') 'm @ layer ' num2str(zid)]);

%#######################################
% left panel - frequency occurrence map 
%#######################################
for kK = 1:2
  axes('Position',[fgx+fgdw*(kK-1) fgy fgw fgh]); hold on; 
  if kK==1                               % left panel - frequency occurence map
    cmap = cmap_freq; ctitle = 'Frequency of Upwelling Occurence';
    pcolor(f1.f_lon-f1.f_dlon/2,f1.f_lat-f1.f_dlat/2,foccu');% frequency of upwelling (shift coords to LL corner)
    shading flat; colormap(gca,cmap_freq); caxis([0.3 0.7]); 
    plot(f1.o_glon(masknpp==1),f1.o_glat(masknpp==1),'s',...   % control area for npp
         'markerfacecolor',color_npp,'markeredgecolor','none','markersize',4.5), 
    scatter(f1.f_glon(idx),f1.f_glat(idx),7,'.','LineWidth',1)  % upwelling > fcut
  elseif kK==2                           % right panel - glider map
    cmap = cmap_bathy; ctitle = 'Bathymetry (m)';
    pcolor(f1.o_glon,f1.o_glat,f1.o_hetopo); shading interp;
    for kg = 1:length(Gids); gid = Gids(kg);
      gcolor = GLinfo{gid,3}; 
      plot(f1.gl_lon{:,kg},f1.gl_lat{:,kg},'-','Color',gcolor,'LineWidth',0.5);  % all locations along track
      scatter(f1.gl_lon{:,kg},f1.gl_lat{:,kg},15,'o','filled','MarkerFaceColor',gcolor) % in-box locations along track
      gl_tid = f1.gl_tid{kg}; gl_tid = gl_tid(end);
      gl_lon = f1.gl_lon{kg}; gl_lon = gl_lon(gl_tid);
      gl_lat = f1.gl_lat{kg}; gl_lat = gl_lat(gl_tid);
      gl_time = f1.gl_time{kg}; gl_time = gl_time(gl_tid);
      tx(kg) = gl_lon+0.3; ty(kg) = gl_lat+0.3;
      %tx(kg) = f1.gl_lon{gl_tid,kg}-0.4; ty(kg) = f1.gl_lat(gl_tid,kg);
      %tdescs{kg} = [datestr(wrk.time(tid(1)),'mmm dd') '-' datestr(wrk.time(tid(end)),'dd,yyyy')];
      tdescs{kg} = datestr(gl_time,'yyyy');
    end
  end
  add_coast(region);                       % land patch and state borders
  text(Reg.xlims(1)+diff(Reg.xlims)*0.02,Reg.ylims(2)-diff(Reg.ylims)*0.02, mlabels{kK}, ...
	  'FontSize',fsize+3,'fontweight','bold','horiz','lef','vert','top');
  % add isobaths 
  [cc,hh] = contour(f1.o_glon,f1.o_glat,f1.o_hetopo,Reg.cts,'k','color',color_cts,'linewidth',0.3);
  clabel(cc,hh,Reg.cts,'color',color_cts,'fontsize',fsize-3)
  % adjust axes and additional labels
  set(gca,'TickDir','out','TickLength',[1 1]*0.01,'fontsize',fsize, ...
          'xlim',Reg.xlims,'xtick',Reg.xticks,'xticklabel',Reg.xticklabels,'xticklabelrot',0, ...
          'ylim',Reg.ylims,'ytick',Reg.yticks,'yticklabel',Reg.yticklabels); box on
  set(gca,'layer','top');
  % colorbar
  colormap(gca,cmap);
  hco = colorbar(gca,'horiz','Position',[fgx+fgdw*(kK-1) fgy+fgdh fgw fgcw],'fontsize',fsize-1);
  title(hco,ctitle,'fontsize',fsize+1)
  if kK == 1; tmp = get(hco,'xtick'); tmp = num2str(tmp(:)*100,'%2.0f%%'); set(hco,'xticklabel',tmp); end
  % additional adjustment for subpanel 2
  if kK==2; set(gca,'yticklabel',''); 
    for kg = 1:length(Gids)./3; gid = kg*3; gcolor = GLinfo{Gids(gid),3}; [tx(gid) ty(gid)]
    text(tx(gid),ty(gid),tdescs{gid},'fontsize',fsize-1,'fontweight','bold','color',gcolor,'horiz','right'); end
  end
end

%#################
%## save figure ##
%#################
print("-dpng",'-r300',ffig)
print("-dpng",'-r300',ffig)

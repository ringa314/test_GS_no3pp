% Upwelling occurence frequency + WVEL STD plots for EUS
% using OfES or ECCO2
% Figure 1
%
%         Adrian Ring, updated 5/29/25, 1/25/26
%         Adrian Ring, edited 9/10/25, 12-15-25

clear; close all; clc; info_params;
%====================================
% edit based on user's needs
region = 'EUS';      
ffig = ['../MSfig/fig1_map_' region];
%====================================
eval(['Reg = ' region ';']);              % geographic input
load(strrep(fgrd_all,'RRR',region));      % grid meshes of datasets
load([fdir_data_OfES region '_glider.mat']);   % selected glider tracks
  OSU = mgrid.OSU; OfES = mgrid.OfES;       % OSU and OfES grid info
fnpp  = [fdir_data region '_mask_npp.mat'];   load(fnpp)
ffreq = [fdir_data region '_foccu.mat']; load(ffreq);

%##################
% figure properties
%##################
fgx = 0.12; fgw = 0.40; fgdw = 0.44; fgcw = 0.022;
fgy = 0.10; fgh = 0.70; fgdh = 0.72; fsize = 8;

%#############
% Load data   
%#############
dlat = mean(diff(OfES.lat));              % y-dir resolution of OfES grid
dlon = mean(diff(OfES.lon));              % x-dir resolution of OfES grid
zr = freq.OfES.zr;                        % depth of OfES grid
[~,zid] = min(abs(zr-Reg.zref));          % representative depth
[~,fid] = min(abs(freq.OfES.fcuts-fcut)); % chosen foccu (.55)
foccu = freq.OfES.foccu(:,:,zid);         % extract the freq at the selected depth
foccu(freq.OfES.mask(:,:,zid)==0) = NaN;  % take out land values
maskf2D = freq.OfES.maskf2D(:,:,fid);     % extract 2D mask for spatial integration of nflux
masknpp = mask.mask_npp;                   % outer shelf mask for npp

%#######################################
% left panel - frequency occurrence map 
%#######################################
for kK = 1:2
  axes('Position',[fgx+fgdw*(kK-1) fgy fgw fgh]); hold on; 
  if kK==1;                               % left panel - frequency occurence map
    cmap = cmap_freq; ctitle = 'Frequency of Upwelling Occurence';
    pcolor(OfES.lon-dlon/2,OfES.lat-dlat/2,foccu');          % frequency of upwelling (shift coords to LL corner)
    shading flat; colormap(gca,cmap_freq); caxis([0.3 0.7]); 
    plot(OSU.glon(masknpp==1),OSU.glat(masknpp==1),'s',...   % control area for npp
         'markerfacecolor',color_npp,'markeredgecolor','none','markersize',4.5), 
    scatter(OfES.glon(maskf2D==1),OfES.glat(maskf2D==1),7,'.','LineWidth',1)  % upwelling > fcut
    plot(Reg.lgno3([1 2 2 1 1]),Reg.ltno3([1 1 2 2 1]),'color',[1 1 1]*0.55,'linewidth',0.5);
  elseif kK==2;                           % right panel - glider map
    cmap = cmap_bathy; ctitle = 'Bathymetry (m)';
    pcolor(OSU.glon,OSU.glat,OSU.hetopo); shading interp;
    for kg = 1:size(GLinfo,1)
      load([fpfx_gld strrep(GLinfo{kg,1},'_','-') '.mat']); 
      eval(['wrk = ' GLinfo{kg,1} '; clear ' GLinfo{kg,1} ';']);
      time = wrk.time./86400+datenum(1970,1,1);              % Glider time to MATLAB datenum()
      tid = find(time>=GLinfo{kg,2}(1) & time<=GLinfo{kg,2}(2)); 
      xtrak = wrk.longitude; ytrak = wrk.latitude; gcolor = GLinfo{kg,3}; 
      plot(xtrak,ytrak,'-','Color',gcolor,'LineWidth',0.5);  % all locations along track
      scatter(xtrak(tid),ytrak(tid),15,'o','filled','MarkerFaceColor',gcolor) % in-box locations along track
      tdescs{kg} = [datestr(time(tid(1)),'mmm dd') '-' datestr(time(tid(end)),'dd,yyyy')];
    end
  end
  add_coast(region);                       % land patch and state borders
  text(Reg.xlims(1)+diff(Reg.xlims)*0.02,Reg.ylims(2)-diff(Reg.ylims)*0.02, mlabels{kK}, ...
	  'FontSize',fsize+3,'fontweight','bold','horiz','lef','vert','top');
  % add isobaths 
  [cc,hh] = contour(OSU.glon,OSU.glat,OSU.hetopo,Reg.cts,'k','color',color_cts,'linewidth',0.3);
  clabel(cc,hh,Reg.cts,'color',color_cts,'fontsize',fsize-3)
  % adjust axes and additional labels
  set(gca,'TickDir','out','TickLength',[1 1]*0.01,'fontsize',fsize, ...
          'xlim',Reg.xlims,'xtick',Reg.xticks,'xticklabel',num2str(-Reg.xticks','%4.0f^oW'),'xticklabelrot',0, ...
          'ylim',Reg.ylims,'ytick',Reg.yticks,'yticklabel',num2str(Reg.yticks','%4.0f^oN')); box on
  set(gca,'layer','top');
  % colorbar
  colormap(gca,cmap);
  hco = colorbar(gca,'horiz','Position',[fgx+fgdw*(kK-1) fgy+fgdh fgw fgcw],'fontsize',fsize-1);
  title(hco,ctitle,'fontsize',fsize+1,'fontweight','bold')
  % additional adjustment for subpanel 2
  if kK==2; set(gca,'yticklabel',''); 
    for kg = 1:size(GLinfo,1); gcolor = GLinfo{kg,3};
    text(GLinfo{kg,4}(1),GLinfo{kg,4}(2),tdescs{kg},...
        'fontsize',fsize-1,'fontweight','bold','color',gcolor,'horiz','right'); end
  end
end

%#################
%## save figure ##
%#################
print("-dpng",'-r300',ffig)
print("-dpng",'-r300',ffig)

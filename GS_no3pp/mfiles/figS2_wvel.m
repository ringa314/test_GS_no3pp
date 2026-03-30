% fig S2: mean WVEL and WSTD map of CAL and EUS 
% OfES data
%
%      Adrian Ring, 1/27/26

clear; close all; info_params;
%=======================================
fin = [fdir_data 'figS2.mat']; load(fin);
ffig = '../MSfig/figS2_flux';
%=======================================
%##################
% figure properties
%##################
fgx = 0.1; fgw = 0.35; fgdw = 0.42; fgcw = 0.022;
fgy = 0.55; fgh = 0.4; fgdh = 0.45; fsize = 9; 
cff = 1-(diff(EUS.mapx)/diff(CAL.mapx)); % scale EUS wrt CAL region width
colormap(cmap_freq)
% User-defined parameters
mean_clims = [-1 1]*5;
std_clims = [0 1]*2.5;

disp('region     Area (10^3 km^2)   WVEL (umol/m^2/sec)')
disp(repmat('-',[1 55]));
for kk = 1:length(regions)                % loop for CAL and EUS
  region = regions{kk};
  eval(['Reg = ' region ';']);

  %###############
  % load OfES data
  %###############
  Wstd = cell2mat(fs2.Wstd(:,:,kk)).*1E5; if strcmp(region,'EUS'); Wstd = Wstd/5; end
  WVEL = cell2mat(fs2.WVEL(:,:,kk)).*1E6; if strcmp(region,'EUS'); WVEL = WVEL/5; end
  mask = cell2mat(fs2.mask(:,:,kk));
  lon = cell2mat(fs2.lon(:,kk));
  lat = cell2mat(fs2.lat(:,kk));
  [lon,lat] = meshgrid(lon,lat);
  %Wstd(out.hetopo>Reg.cts(1)) = NaN;
  %WVEL(out.hetopo>Reg.cts(1)) = NaN;
  switch region;
  case{'EUS'}; tx = Reg.mapx(1)+diff(Reg.mapx)*0.05; xalign='left';
      case{'CAL'}; tx = Reg.mapx(2)-diff(Reg.mapx)*0.05; xalign='right'; end % align subfigure labels
  
  %###############################
  %## assess intensity and area ##
  %###############################
  gA = fs2.dlat.*fs2.dlon... 
     .*cff_deg2m.*1E-7.*cos(lat/180*pi); % pixel area
  Atot = sum(gA(mask==1)); % total regional area
  Wavg = nanmean(WVEL(mask==1));
  disp(sprintf('%s\t\t%6.2f\t\t%7.8f',region,Atot,Wavg));

  %#############
  % region plots
  %#############
  for kw = 1:2
      if kw == 1; Wwrk = WVEL; clims = mean_clims; desc = 'Mean WVEL (10^{-6} m/s)'; end
      if kw == 2; Wwrk = Wstd; clims = std_clims; desc = 'WVEL STD (10^{-5} m/s)'; end
    pos = [fgx+fgdw*(kk-1) fgy-fgdh*(kw-1) fgw*(1-cff*(kk==2)) fgh];
  axes('Position', pos);hold on;
  pcolor(lon,lat,Wwrk'); shading interp; caxis(clims); 
  contour(lon,lat,mask',[1 1]*0.999,'color',[1 1 1]*0.25,'linewidth',1.5); 
%   [cc,hh] = contour(out.lon,out.lat,out.hetopo,Reg.cts(2:end),'k');
%   clabel(cc,hh,Reg.cts(2:end),'fontsize',fsize-2)
  set(gca,'TickDir','out','TickLength',[1 1]*0.01,'fontsize',fsize-1, ...
          'xlim',Reg.mapx,'xtick',Reg.xticks,'xticklabel',Reg.xticklabels,'xticklabelrot',0, ...
          'ylim',Reg.mapy,'ytick',Reg.yticks,'yticklabel',Reg.yticklabels);
  if kw == 1; set(gca, 'xticklabel', {}); end
  box on; add_coast(region); set(gca,'layer','top');
  text(tx,Reg.mapy(2)-diff(Reg.mapy)*0.03, mlabels{kk+2*(kw==2)},...
      'fontsize',fsize+2,'fontweight', 'bold','horiz',xalign,'vert','top')
  if kk == 2; hco = colorbar('vert','Position',pos.*[1 1 0 1]+[fgw-fgcw 0 fgcw 0],'fontsize',fsize-2);
  ylabel(hco, desc, 'fontsize', fsize); end
  end
end

%#################
%## save figure ##
%#################
print('-dpng','-r300',ffig)
print('-dpng','-r300',ffig)

% fig S2: mean WVEL and WSTD map of CAL and EUS 
% OfES data
%
%      Adrian Ring, 1/27/26

clear; close all; info_params;
%=======================================
fin = [fdir_data region '_foccu.mat'];
ffig = '../figures/figS2_CALvsEUS';
load(fcmap);
%=======================================
%##################
% figure properties
%##################
fgx = 0.1; fgw = 0.35; fgdw = 0.42; fgcw = 0.022;
fgy = 0.55; fgh = 0.4; fgdh = 0.45; fsize = 9; 
cff = 1-(diff(EUS.mapx)/diff(CAL.mapx)); % scale EUS wrt CAL region width
colormap(cmap);
% User-defined parameters
mean_clims = [-1 1]*5E-6;
std_clims = [0 1]*2.5E-5;

disp('region     Area (10^3 km^2)   WVEL (umol/m^2/sec)')
disp(repmat('-',[1 55]));
for kk = 1:length(regions)                % loop for CAL and EUS
  region = regions{kk};
  eval(['Reg = ' region ';']);

  %###############
  % load OfES data
  %###############
  load(fin);
  zr = freq.OfES.zr;                        % depth of OfES grid
  [~,zid] = min(abs(zr-Reg.zref));          % representative depth
  %[~,fid] = min(abs(freq.OfES.fcuts-fcut)); % chosen foccu (.55)
  Wstd = freq.OfES.Wstd(:,:,zid); if strcmp(region,'EUS'); Wstd = Wstd/5; end
  %Wstd = log10(Wstd);
  WVEL = freq.OfES.WVEL(:,:,zid); if strcmp(region,'EUS'); WVEL = WVEL/5; end
  mask = freq.OfES.mask(:,:,zid);
  %Wstd(out.hetopo>Reg.cts(1)) = NaN;
  %WVEL(out.hetopo>Reg.cts(1)) = NaN;
  switch region;
  case{'EUS'}; tx = Reg.mapx(1)+diff(Reg.mapx)*0.05; xalign='left';
      case{'CAL'}; tx = Reg.mapx(2)-diff(Reg.mapx)*0.05; xalign='right'; end % align subfigure labels
  
  %###############################
  %## assess intensity and area ##
  %###############################
  gA = mean(diff(freq.OfES.lat(1,:))).*mean(diff(freq.OfES.lon(:,1))) ...
     .*cff_deg2m.*1E-7.*cos(freq.OfES.lat/180*pi); % pixel area
  Atot = sum(gA(mask==1)); % total regional area
  Wavg = nanmean(WVEL(mask==1));
  disp(sprintf('%s\t\t%6.2f\t\t%7.4f',region,Atot,Wavg));

  %#############
  % region plots
  %#############
  for kw = 1:2
      if kw == 1; Wwrk = WVEL; clims = mean_clims; desc = 'Mean WVEL (m/s)'; end
      if kw == 2; Wwrk = Wstd; clims = std_clims; desc = 'WVEL STD (m/s)'; end
      pos = [fgx+fgdw*(kk-1) fgy-fgdh*(kw-1) fgw*(1-cff*(kk==2)) fgh];
  axes('Position', pos);hold on;
  pcolor(freq.OfES.lon,freq.OfES.lat,Wwrk); shading interp; caxis(clims); 
  contour(freq.OfES.lon,freq.OfES.lat,mask,[1 1]*0.999,'color',[1 1 1]*0.25,'linewidth',1.5); 
%   [cc,hh] = contour(out.lon,out.lat,out.hetopo,Reg.cts(2:end),'k');
%   clabel(cc,hh,Reg.cts(2:end),'fontsize',fsize-2)
  set(gca,'TickDir','out','TickLength',[1 1]*0.01,'fontsize',fsize-1, ...
          'xlim',Reg.mapx,'xtick',Reg.xticks,'xticklabel',Reg.xticklabels,'xticklabelrot',0, ...
          'ylim',Reg.mapy,'ytick',Reg.yticks,'yticklabel',Reg.yticklabels);
  if kw == 1; set(gca, 'xticklabel', {}); end
  box on; add_coast(region); set(gca,'layer','top');
  text(tx,Reg.mapy(2)-diff(Reg.mapy)*0.03, mlabels{kk+2*(kw==2)},...
      'fontsize',fsize+2,'fontweight','bold','horiz',xalign,'vert','top')
  if kk == 2; hco = colorbar('vert','Position',pos.*[1 1 0 1]+[fgw-fgcw 0 fgcw 0],'fontsize',fsize-2);
  ylabel(hco, desc, 'fontsize', fsize, 'fontweight', 'bold'); end
  end
end
return
  % Wstd (bottom plot)
  axes('Position', [fgx+fgdw*(kk-1) fgy fgw*(1-cff*(kk==2)) fgh]);hold on;
  pcolor(freq.OfES.lon,freq.OfES.lat,Wstd); shading interp; caxis(std_clims);
  contour(freq.OfES.lon,freq.OfES.lat,mask,[1 1]*0.999,'color',[1 1 1]*0.25,'linewidth',1.5); 
%   [cc,hh] = contour(out.lon,out.lat,out.hetopo,Reg.cts(2:end),'k');
%   clabel(cc,hh,Reg.cts(2:end),'fontsize',fsize-2)
  set(gca,'TickDir','out','TickLength',[1 1]*0.01,'fontsize',fsize-1, ...
          'xlim',Reg.mapx,'xtick',Reg.xticks,'xticklabel',num2str(-Reg.xticks','%4.0f^oW'),'xticklabelrot',0, ...
          'ylim',Reg.mapy,'ytick',Reg.yticks,'yticklabel',num2str(Reg.yticks','%4.0f^oN'));
  box on; add_coast(region); set(gca,'layer','top');
  text(tx,Reg.mapy(2)-diff(Reg.mapy)*0.03, mlabels{kk},...
      'fontsize',fsize+2,'fontweight','bold','horiz',xalign,'vert','top')
  hco = colorbar('horiz','Position',[fgx+fgdw+ fgy+fgh+fgcw fgdw+fgw*(1-cff) fgcw],'fontsize',fsize-2);
  xlabel(hco, 'Vertical Velocity STD (m/s)', 'fontsize', fsize, 'fontweight', 'bold')
%end


%#################
%## save figure ##
%#################
print('-dpng','-r300',ffig)
print('-dpng','-r300',ffig)

% fig S1: NPP averaged map of CAL and EUS cbpm
%
%      Adrian Ring, 1/27/26

clear; close all; info_params;
%=======================================
% User-defined parameters
OSUprod = 'eppley'; clims = [300 1700];
fin = '../../GS_no3pp/MSdata/_npp_figS1.mat'; 
ffig = '../MSfig/figS1_CALvsEUS_npp';
%=======================================
%##################
% figure properties
%##################
fgx = 0.12; fgw = 0.40; fgdw = 0.48; fgcw = 0.022;
fgy = 0.12; fgh = 0.50; fgdh = 0.54; fsize = 9; 
cff = 1-(diff(EUS.mapx)/diff(CAL.mapx)); % scale EUS wrt CAL region width
colormap(cmap_npp);

disp('region     Area (10^3 km^2)   NPP (mgC/m^2/day)')
disp(repmat('-',[1 55]));
for kk = 1:length(regions)                % loop for CAL and EUS
  region = regions{kk};
  eval(['Reg = ' region ';']);
    
  %##############
  % load npp data
  %##############
  load(fin);
  glat = pp.(region).glat;
  glon = pp.(region).glon;
  hetopo = pp.(region).hetopo;
  mask_npp = pp.(region).mask_npp;
  npp = pp.(OSUprod).(region).npp;
  switch region
  case{'EUS'}; tx = Reg.mapx(1)+diff(Reg.mapx)*0.05; xalign='left';
      case{'CAL'}; tx = Reg.mapx(2)-diff(Reg.mapx)*0.05; xalign='right'; end % align subfigure labels
  
  %###############################
  %## assess intensity and area ##
  %###############################
  gA = mean(diff(glat(1,:))).*mean(diff(glon(:,1))) ...
     .*cff_deg2m.*1E-7.*cos(glat/180*pi); % pixel area
  Atot = sum(gA(mask_npp==1)); % total regional area
  NPPavg = nanmean(npp(mask_npp==1));
  disp(sprintf('%s\t\t%6.2f\t\t%7.2f',region,Atot,NPPavg));

  %#############
  % region plots
  %#############
  axes('Position', [fgx+fgdw*(kk-1) fgy fgw*(1-cff*(kk==2)) fgh]);hold on;
  pcolor(glon,glat,npp); shading interp; caxis(clims);
  contour(glon,glat,mask_npp,[1 1]*0.999,'color',[1 1 1]*0.25,'linewidth',1.5); 
  [cc,hh] = contour(glon,glat,hetopo,Reg.cts(2:end),'k');
  clabel(cc,hh,Reg.cts(2:end),'fontsize',fsize-2)
  set(gca,'TickDir','out','TickLength',[1 1]*0.01,'fontsize',fsize-1, ...
          'xlim',Reg.mapx,'xtick',Reg.xticks,'xticklabel',num2str(-Reg.xticks','%4.0f^oW'),'xticklabelrot',0, ...
          'ylim',Reg.mapy,'ytick',Reg.yticks,'yticklabel',num2str(Reg.yticks','%4.0f^oN'));
  box on; add_coast(region); set(gca,'layer','top');
  text(tx,Reg.mapy(2)-diff(Reg.mapy)*0.03, mlabels{kk},...
      'fontsize',fsize+2,'fontweight','bold','horiz',xalign,'vert','top')
end
hco = colorbar('horiz','Position',[fgx fgy+fgdh fgdw+fgw*(1-cff) fgcw],'fontsize',fsize);
xlabel(hco, 'NPP (mg C m^{-2}day^{-1})', 'fontsize', fsize+2, 'fontweight', 'bold')

%#################
%## save figure ##
%#################
print('-dpng','-r300',ffig)
print('-dpng','-r300',ffig)

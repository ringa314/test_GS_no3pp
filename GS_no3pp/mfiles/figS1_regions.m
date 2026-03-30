% fig S1: NPP averaged map of CAL and EUS cbpm
%
%      Adrian Ring, 1/27/26

clear all; close all; clc; info_params;
%=======================================
% User-defined parameters
vars = {'chl','npp'};  Oprod = 'cbpm'; 
npp_lims = [300 1700]; chl_lims = [-1 0];
fin = [fdir_data 'figS1.mat']; load(fin);
ffig = '../MSfig/figS1_nppchl';
%=======================================
%#######################
%## figure properties ##
%#######################
fgx = 0.12; fgw = 0.30; fgdw = 0.38; fgcw = 0.022;
fgy = 0.55; fgh = 0.38; fgdh = 0.43; fsize = 7; 
cff = 1-(diff(EUS.mapx)/diff(CAL.mapx)); colormap(cmap_npp);

%##############################
%## variable info and report ##
%##############################
tlims = [datenum(nyears(1),1,1) datenum(nyears(end),12,31)];
tdesc = num2str(year(tlims),'%i-%i');
disp(['Product used for chl: ' tdesc ' GlobColour'])
disp(['Product used for npp: ' tdesc ' OSU ' Oprod])
disp(repmat('-',[1 65]));
disp('region   Area (m^2)  CHL (mg/m^3)  NPP (mgC/m^2/day)')
disp(repmat('-',[1 65]));

for kr = 1:length(regions)               % loop for CAL and EUS
  %###################
  %## regional info ##
  %###################
  region = regions{kr}; eval(['Reg = ' region ';']);
%   fnpp = [fdir_data region '_npp_' Oprod '.nc'];
%   fchl = [fdir_data region '_chl_glob.nc'];
  switch region
  case{'EUS'}; tx = Reg.mapx(1)+diff(Reg.mapx)*0.03; xalign='left';
  case{'CAL'}; tx = Reg.mapx(2)-diff(Reg.mapx)*0.03; xalign='right'; 
  end

  for kv = 1:2; var = vars{kv};
    %######################
    %## load npp and chl ##
    %######################
%     load([fdir_data region '_' var '.mat']); 
%     eval(['out= ' var ';'       ]);        % regional information
%     eval(['msk= ' var '.mask_' var ';']);  % regional variable mask
%     eval(['fin= f' var ';']);              % var NetCDF file
%     time= ncread(fin,'time')+dref;         % time of var available
%     tid = find(time>=tlims(1) & time<tlims(2));
%     if year(time( 1 ))>year(tlims(1)); error(['Warning: ' var ' unavailable for ' num2str(year(tlims(1)))]); end
%     if year(time(end))<year(tlims(2)); error(['Warning: ' var ' unavailable for ' num2str(year(tlims(2)))]); end
%     wrk = double(ncread(fin,var));         % var across all years
%     wrk = nanmean(wrk(:,:,tid),3);         % averaged var over study period
    wrk = cell2mat(fs1.wrk(:,:,kv,kr)); 
    msk = cell2mat(fs1.msk(:,:,kv,kr));
    A = cell2mat(fs1.A(:,:,kv,kr));
    Asum(kv) = sum(A(msk==1));         % area of mid-shelf region
    Vavg(kv) = nanmean(wrk(msk==1));       % intensity of mean NPP

    %##################
    %## region plots ##
    %##################
    if kv==1; clims = chl_lims; Vdesc = {[tdesc ' Chlorophyll a'];['log_{10} ' Ginfo{2}]}; wrk = log10(wrk); end 
    if kv==2; clims = npp_lims; Vdesc = {[tdesc ' NPP'];Oinfo{2}}; end
    pos = [fgx+fgdw*(kr-1) fgy-fgdh*(kv-1) fgw*(1-cff*(kr==2)) fgh];
    axes('pos',pos); hold on;
    pcolor(cell2mat(fs1.glon(:,:,kv,kr)),cell2mat(fs1.glat(:,:,kv,kr)),wrk); shading interp; caxis(clims);
    contour(cell2mat(fs1.glon(:,:,kv,kr)),cell2mat(fs1.glat(:,:,kv,kr)),msk,[1 1]*0.999,'color',[1 1 1]*0.25,'linewidth',1.5); 
    [cc,hh] = contour(cell2mat(fs1.glon(:,:,kv,kr)),cell2mat(fs1.glat(:,:,kv,kr)),cell2mat(fs1.hetopo(:,:,kv,kr)),Reg.cts(2:end),'k');
    clabel(cc,hh,Reg.cts(2:end),'fontsize',fsize-2)
    set(gca,'TickDir','out','TickLength',[1 1]*0.03,'fontsize',fsize, ...
            'xlim',Reg.mapx,'xtick',Reg.xticks,'xticklabel',Reg.xticklabels,'xticklabelrot',0, ...
            'ylim',Reg.mapy,'ytick',Reg.yticks,'yticklabel',Reg.yticklabels);
    if kv==1; set(gca,'xticklabel',''); end
    box on; add_coast(region); set(gca,'layer','top');
    text(tx,Reg.mapy(2)-diff(Reg.mapy)*0.02, mlabels{kr+(kv-1)*2},...
        'fontsize',fsize+2,'fontweight','bold','horiz',xalign,'vert','top')
    % colorbar
    if kr==2; 
    hco = colorbar('vert','position',pos.*[1 1 0 1]+[fgw*(1-cff)+0.02 0 fgcw 0],'fontsize',fsize+1);
    ylabel(hco,Vdesc,'fontsize',fsize+1,'fontweight','bold'); end
  end
  % report the assessment of intensity and area
  disp(sprintf('%s\t%4.2e  %4.2e    %4.2e      %4.2e',region,Asum,Vavg));
end
disp(repmat('-',[1 65]));

%#################
%## save figure ##
%#################
print('-dpng','-r300',ffig)
print('-dpng','-r300',ffig)

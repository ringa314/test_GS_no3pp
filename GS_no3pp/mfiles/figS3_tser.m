% time series of vertical nutrient flux and npp
%                       Yun Li, UDel, 02-17-2026

clear all; close all; clc; info_params;
%===================================================
% User-defined parameters
fin = [fdir_data 'figS3.mat']; load(fin)
ffig = '../MSfig/figS3_tser';
%===================================================
%#######################
%## figure properties ##
%#######################
fgx=0.1; fgw=0.40; fgdw=0.43;
fgy=0.6; fgh=0.30; fgdh=0.33;
fsize = 6.5;
tlims = datenum(ayears([1 end])+[0 1],1,1);
tticks = datenum([ayears(1:3:end) 2025],1,1);
tticklabels = datestr(tticks,'yy');

for kr = 1:2
  %#################
  %## region info ##
  %#################
  region = regions{kr,1};
  rdesc = regions{kr,2};
  eval(['Reg = ' region ';']);

  for kv = 1:2
    %###############
    %## load data ##
    %###############
    if kv==1; 
              twrk = fs3.ftime;                     % OfES time
	          wrk = fs3.nflux_flt_anom(:,kr); uwrk = Finfo{3};  % unit conversion
	      uwrk = strrep(uwrk,'(','at 100 m (');
	      ylims = [-45 45]; yticks = -40:20:40; mcolors = [0.85 0.33 0.1];
              disp([region ' OfES: depth = ' num2str(fs3.zr(fs3.zid),'%3.0f m') ...
                           ', fcut = ' num2str(fs3.fcuts(fs3.fid),'%4.2f')]); end
    if kv==2; Oids = 1:3;     % exclude cafe
              twrk = cell2mat(fs3.otime(:,kr));                     % OSU time
               wrk = cell2mat(fs3.npp_flt_anom(:,:,kr));     % OSU npps
	      uwrk = Oinfo{3}; mcolors = lines(6); mcolors = [0 0 0; mcolors([3 5],:)];
	      ylims = [-350 350]; yticks = -300:100:300; end

    %######################
    %## plot time series ##
    %######################
    axes('pos',[fgx+fgdw*(kr-1) fgy-fgdh*(kv-1) fgw fgh]); hold on;
    colororder(gca,[0.85 0.33 0.1]);
    plot(twrk,wrk,'linewidth',0.8); colororder(gca,mcolors);
    set(gca,'fontsize',fsize,'tickdir','in','TickLength',[1 1]*0.01,...
            'xlim',tlims,'xtick',tticks,'xticklabel',tticklabels,...
	    'ylim',ylims,'ytick',yticks); xtickangle(0); box on;
    text(tlims(1)+diff(tlims)*0.05,ylims(2)-diff(ylims)*0.05,mlabels{kr+(kv-1)*2},...
         'horiz','left','vert','top','fontsize',fsize+2,'fontweight','bold');
    if kv==1; set(gca,'xticklabel',''); else; xlabel('year','fontsize',fsize+1); end
    if kr==1; ylabel(uwrk,'fontsize',fsize+0.5); else; set(gca,'yaxisloc','right'); end
    if kv==1; title(rdesc,'fontsize',fsize+1,'fontweight','bold'); end
    if kr==1 & kv==2; legend(OSUprods{Oids},'location','southwest','box','off','fontsize',fsize); end
  end
end

%#################
%## save figure ##
%#################
print('-dpng','-r300',ffig);
print('-dpng','-r300',ffig);

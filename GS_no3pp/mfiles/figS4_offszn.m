%% glider data of chl and temperature during summer off-seasons
%
%
%  adrian ring, 11/4/25, edited 2/5/26
close all; clear; info_params;
addpath(genpath('/home/yunli/papers/2025_HUNT/data/GLIDER'));
ffig = '/home/ringa/proj/final/figS4_offszn';
%##################
% figure properties
%##################
fgx=0.07; fgw=0.22; fgdw = 0.25;
fgy=0.1; fgh=0.21; fgdh = 0.27;
fsize = 10;

%###########
% file names
%###########
minfo = {'sp065-20230414T1618.mat', [datenum(2023,5,2) datenum(2023,5,11)];
         'sp007-20230614T1428.mat', [datenum(2023,7,16) datenum(2023,7,24)];
         'sp069-20240703T1534.mat', [datenum(2024,7,31) datenum(2024,8,8)]};
colors = lines(3);  % distinct colors

%####################
% load OSU bathymetry
%####################
load ../data/EUS_OSU_grid.mat
dlon = mean(diff(OSU.lon));
dlat = mean(diff(OSU.lat));

%#################
% load glider data
%#################
for kk = 1:size(minfo,1)
    S = load(minfo{kk,1}); tw = minfo{kk,2};
    fn = fieldnames(S);
    wrk = S.(fn{1});
    time = wrk.time./86400+datenum(1970,1,1);
    % self-defined time window index
    wrk.tid = find(time>=tw(1) & time<=tw(2));
    eval(['wrk' num2str(kk) ' = wrk;'])
end

figure('Position', [100 100 1200 600]);
%###########
% glider map
%###########
axes('Position',[fgx fgy fgw*1.5 fgh+fgdh*2]); hold on;
% contours
add_coast('EUS');

    [cc,hh] = contour(OSU.glon,OSU.glat,OSU.hetopo,[-30 -300 -1000 -4000],'k','color',[1 1 1]*0.35,'linewidth',0.5);
  clabel(cc,hh,[-30 -300 -1000 -4000],'color',[1 1 1]*0.35)
% add glider tracks
for kk = 1:size(minfo,1)
    eval(['wrk = wrk' num2str(kk) ';'])
    plot(wrk.longitude, wrk.latitude, '-', 'Color', colors(kk,:), 'LineWidth', 2);
    plot(wrk.longitude(wrk.tid), wrk.latitude(wrk.tid), '-o', 'Markersize', 5, 'Markerfacecolor', colors(kk,:), 'Color', colors(kk,:), 'LineWidth', 1, ...
         'DisplayName', sprintf('Glider %d', kk));
end
set(gca, 'fontsize', fsize, 'xlim', [-81 -75], 'xtick', -80:2:-76, 'xticklabel', {'80^oW', '78^oW', '76^oW'},...
'ylim',[29 36], 'ytick', 30:2:36, 'yticklabel', {'30^oN', '32^oN', '34^oN', '36^oN'});
xlabel('Longitude', 'fontsize', fsize+2);
ylabel('Latitude', 'fontsize', fsize+2);
title('Glider Tracks: Off-Season', 'fontsize',fsize+5);
box on;

axTemp = gobjects(size(minfo,1),1);
axChl = gobjects(size(minfo,1),1);

%############
% depth plots
%############
for kk = 1:size(minfo,1)
    % self-defined OSU bathymetry
        eval(['wrk = wrk' num2str(kk) ';'])
    wrk_id  = sub2ind(size(OSU.glon),...
                 ceil((wrk.longitude(wrk.tid)-OSU.lon(1))./dlon+0.5),... % lon index
                 ceil((wrk.latitude(wrk.tid)-OSU.lat(1))./dlat+0.5));    % lat index
    wrk.hb = OSU.hetopo(wrk_id);
    

    %temp plots
    axTemp = axes('Pos', [fgx+fgdw*1.5 fgy+(3-kk)*(fgdh) fgw fgh]);
    scatter(wrk.latitude(wrk.tid), -wrk.depth(wrk.tid), 17, wrk.temperature(wrk.tid), 'filled'); hold on; plot(wrk.latitude(wrk.tid),wrk.hb,'k')
    xlim([31 33.25])
    ylim([-1000 0])
    set(gca,'fontsize',fsize, 'ytick', -1000:200:0, 'xdir', 'reverse');
    title([minfo{kk,1}(1:end-4) '  ' datestr(minfo{kk,2}(1), 'mmm-dd') ' to ' datestr(minfo{kk,2}(2), 'mmm-dd-yyyy')], ...
        'Color', colors(kk,:), 'Pos', [30.98 5 0], 'fontsize', fsize+2);
    colormap(axTemp, 'jet');
    grid on;
    if kk ==3; xlabel(axTemp, 'Latitude (^oN)', 'fontsize', fsize+2); else; set(gca, 'xticklabel', ''); end

    % chlorophyll plots
    axChl = axes('Pos', [fgx+fgdw*2.5 fgy+(3-kk)*(fgdh) fgw fgh]);
    scatter(wrk.latitude(wrk.tid), -wrk.depth(wrk.tid), 17, wrk.chlorophyll_a(wrk.tid), 'filled'); hold on; plot(wrk.latitude(wrk.tid),wrk.hb,'k')
    xlim([31 33.25])
    ylim([-1000 0])
    set(gca,'fontsize',fsize, 'ytick', -1000:200:0, 'yticklabel', '', 'xdir', 'reverse');
    %title(sprintf('Glider %d Chlorophyll', kk), 'Color', colors(kk,:));
    colormap(axChl, 'jet');
    grid on;
    if kk ==3; xlabel(axChl, 'Latitude (^oN)', 'fontsize', fsize+2); else; set(gca, 'xticklabel', ''); end
end

% Label bottom plots x-axes only
for ax = findall(gcf,'Type','axes')'
    if ax.Position(2) < 0.15 % crude check for bottom row
        
    end
end

% Shared colorbar: temp
cb = colorbar(axTemp(1), 'Orientation', 'horizontal');     
cb.Position =[fgx+fgdw*1.5 fgy+fgdh*3-0.02 fgw 0.02];
caxis(axTemp(1),[0 30])
cb.Ticks = 0:5:30;
cb.Label.String = 'Temperature (^oC)';
cb.Label.FontSize = fsize+3; 
% Shared colorbar: Chl
cc = colorbar(axChl(1),'Orientation', 'horizontal');     
cc.Position =[fgx+fgdw*2.5 fgy+fgdh*3-0.02 fgw 0.02];
caxis(axChl(1),[0 0.5])
cc.Label.String = 'Chlorophyll (mg/m^3)';
cc.Label.FontSize = fsize+3; 

print('-dpng','-r300',ffig)
print('-dpng','-r300',ffig)
function [hp] = add_coast(region)

% add the land mask and coast to the study region
% Usage
%   [hp] = add_coast(region); 
% Input
%   region    name of the study region (EUS or CAL)
% Output
%   hp        handle of MALTAB patch() objects
%
%                       Yun Li, UDel, Jan-29-2026

info_params;
load(strrep(fgrd_coast,'RRR',region));    % regional coastline 
eval(['mcoast = ' region '_coast;']);
for ks = 1:length(mcoast.state)
  idd = find(isnan(mcoast.state(ks).X+mcoast.state(ks).Y));
  nend = -1;
  for kn = 1:length(idd)
    nstr = nend+2; nend = idd(kn)-1; idn = nstr:nend;
    hp(ks,kn) = patch(mcoast.state(ks).X(idn), mcoast.state(ks).Y(idn),'r');
    set(hp(ks,kn),'facecolor',color_land,'edgecolor',[1 0.8 0.6]*0.25,'linewidth',0.4);
  end
end

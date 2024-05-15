% This script loads a NetCDF file named wind_stress_zonal_monthly_maps.nc and plots the 
% zonal monthly wind stress field for January.
%
% wind_stress_zonal_monthly_maps.nc contains global ocean zonal monthly wind stress fields 
% for January through December. These fields form part of the SCOW wind atlas, which is avaiable at 
% http://cioss.coas.oregonstate.edu/scow/.
% 
% This script was written by Craig Risien on 20 January 2010 and tested using Matlab 5.3.1.29215a (R11.1), 
% Matlab 7.1.0.183 (R14) Service Pack 3, the NetCDF toolbox for Matlab-5, and the m_map toolbox.


clear all
close all

dummy = netcdf('wind_stress_zonal_monthly_maps.nc','nowrite');

ncdump(dummy)	% the ncdump command will give you a listing of the NetCDF file headers.

% extract NetCDF variables of interest from wind_stress_zonal_monthly_maps.nc.

temp = dummy{'january'};	% to plot the zonal wind stress for other months replace 'january' with 'february', 'march', ..., or 'december'.
january = squeeze(temp(:,:));
january(find(january==-9999))=nan;	% missing data are flagged as -9999.

temp = dummy{'latitude'};
latitude = squeeze(temp(:,:));

temp = dummy{'longitude'};
longitude = squeeze(temp(:,:));

% plot the zonal monthly wind stress field for January.

m_proj('Miller Cylindrical','lon',[0 360],'lat',[-70 70]);
m_pcolor(longitude,latitude,january)
shading flat 
caxis([-.4 .4])
colorbar
title('SCOW January Zonal Wind Stress (N/m^2)','FontSize',12)
xlabel('longitude','FontSize',12)
ylabel('latitude','FontSize',12)
m_grid('tickdir','in','colour','k','FontSize',10,'linestyle','none');
orient landscape
print -dpng -r300 January_Zonal_Wind_Stress

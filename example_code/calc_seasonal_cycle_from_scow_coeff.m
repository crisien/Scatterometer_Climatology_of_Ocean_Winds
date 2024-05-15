% This script loads a NetCDF file named wind_stress_zonal_coefficients.nc and calculates a 12 point (monthly)
% seasonal cycle, using the first 5 regression coefficients, for each 0.25 x 0.25 deg grid cell.
%
% wind_stress_zonal_coefficients.nc contains 9 zonal wind stress regression coefficients.
% These regression coefficients form part of the SCOW wind atlas, which is avaiable at 
% http://cioss.coas.oregonstate.edu/scow/.
% 
% This script was written by Craig Risien on 20 January 2010 and tested using Matlab 5.3.1.29215a (R11.1), 
% Matlab 7.1.0.183 (R14) Service Pack 3, the NetCDF toolbox for Matlab-5, and the m_map toolbox.


clear all
close all

dummy = netcdf('wind_stress_zonal_coefficients.nc','nowrite');

ncdump(dummy)	% the ncdump command will give you a listing of the NetCDF file headers.

% extract NetCDF variables of interest from wind_stress_zonal_coefficients.nc.

temp = dummy{'regress_coefficients'};
regress_coefficients = squeeze(temp(:,:,:));
regress_coefficients(find(regress_coefficients == -9999)) = nan;	% missing data are flagged as -9999.

% calculate a 12 point (monthly) seasonal cycle, using the first 5 coefficients, for each 0.25 x 0.25 deg grid cell.

taux_seasonal_cycle = repmat(nan,[560 1440 12]);

% to calculate a daily, 365 point, seasonal cycle change new_t=0:1:364, f=1/365, and taux_seasonal_cycle = repmat(nan,[560 1440 365]).
% for a 365 point seasonal cycle taux_seasonal_cycle(:,:,1) is equal to 16 September and taux_seasonal_cycle(:,:,365) is 15 September.

new_t = 0:1:11;
f = 1/12;

for i = 1:560,

	for j = 1:1440,
	
	T=(regress_coefficients(i,j,1)+regress_coefficients(i,j,2)*sin(2*pi*f*new_t)+regress_coefficients(i,j,3)...
	*cos(2*pi*f*new_t)+regress_coefficients(i,j,4)*sin(4*pi*f*new_t)+regress_coefficients(i,j,5)*cos(4*pi*f*new_t));
	
	% to calculate a 12 point (monthly) seasonal cycle using all 9 coefficients comment out the above 2 lines and 
	% uncomment the 4 lines below.
	
	%T=(regress_coefficients(i,j,1)+regress_coefficients(i,j,2)*sin(2*pi*f*new_t)+regress_coefficients(i,j,3)*cos(2*pi*f*new_t)...
	%+regress_coefficients(i,j,4)*sin(4*pi*f*new_t)+regress_coefficients(i,j,5)*cos(4*pi*f*new_t)...
	%+regress_coefficients(i,j,6)*sin(6*pi*f*new_t)+regress_coefficients(i,j,7)*cos(6*pi*f*new_t)...
	%+regress_coefficients(i,j,8)*sin(8*pi*f*new_t)+regress_coefficients(i,j,9)*cos(8*pi*f*new_t));

	taux_seasonal_cycle(i,j,:) = T;	% where taux_seasonal_cycle(:,:,1) is equal to 16 September.

	end

end

% plot the zonal monthly wind stress field for January.

january = taux_seasonal_cycle(:,:,5);
january(find(january==-9999))=nan;

temp = dummy{'latitude'};
latitude = squeeze(temp(:,:));

temp = dummy{'longitude'};
longitude = squeeze(temp(:,:));

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

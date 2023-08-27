%% Measured AKDEs
% C.S. Riebe, C.E. Lukens, L.S. Sklar, and D.L Shuster, 2023 

% create an AKDE for each of the measured age distributions and smooth with
% error in age-elevation relationship

clear
%close all
addpath('input')
addpath('functions')
addpath('akde1d')


%% Functions used
% ageZinyo, akde1d

%% User Inputs
%set limits and spacing of age axis:
spacing = 0.25; %Ma
lowLimit = 10; %Ma
highLimit = 90; %Ma
lbin=49; 
ubin=223;

nG = [73 75 41 66 25 79 73 42 74 97 40 37 50]; % number of measured ages in each grain size
nGsizes = {'1-2 mm','2-4 mm','4-8 mm','8-16 mm','16-32 mm',...
    '32-48 mm (2012)','32-48 mm (2011)','48-64 mm','64-96 mm',...
    '96-128 mm','128-192 m','192-256 mm','>256 mm'};
%13CL097INYc (1-2 mm) col 1-3 %13CL097INYd (2-4 mm) col 4-6
%13CL097INYe (4-8 mm) col 7-9 %13CL030INY (8-16 mm) col 10-12
%13CL062INY (16-32 mm) col 13-15 %12CL003INY (32-48 mm) col 16-18
%11CL016INY (32-48 mm) col 19-21 %13CL031INY (48-64 mm) col 22-24
%13CL064INY (64-96 mm) col 25-27 %13CL065INY (96-128 mm) col 28-30
%13CL008INY (128-192 mm) col 31-33 %13CL066INY (192-256 mm) col 34-36 
%13CL029INY (>256 mm) col 37-39


%% Read in Data and Assign Data to Local Variables
A=readtable('AllAges_noOutliers.xlsx');

%% Define Age Range for plotting space
nPts=(highLimit-lowLimit)/spacing+1; 
%number of plotting points for density trace
agePlot = (lowLimit: spacing : highLimit)'; 
%ages at each plotting point along density trace
[zPlot,zPlotUnc]=ageZ(agePlot); 
%convert age range into elevation range based on age-elevation relationship and using inverse prediction to get elevationm from age

akdeA=zeros(nPts,length(nG));  % uses the aKDE function of Botev, 2022
%akdeZ=zeros(nPts,length(nG));
for i = 0:length(nG)-1
    %% Read Data
    j=i*3+1;
    ageMeas = table2array(A(1:nG(i+1),j)); %measured age for size class i
    
    %% Create akde based distribution of ages from sample
    [akdeAge,agePlot]=akde1d(ageMeas,agePlot);
    akdeAgeArea=sum(akdeAge); %calculate area under the akde
    akdeA(:,i+1)=akdeAge/akdeAgeArea; %normalize akde by area

end

akdeZ=akdeA;

figure
plot(zPlot,akdeZ(:,5)) % Change the 2nd value in the akdeZ term to plot a different grain size. ("5" will return the 16-32 mm size). The x-axis here is elevation; the y-axis is frequency. 


%% Trim matrices to elevation range of catchment
akdeZTrimmed=akdeZ((lbin:ubin),:);
zPlotTrimmed=zPlot((lbin:ubin),1);

%% Write Output
dlmwrite('output/akde_Z_measured.csv',akdeZTrimmed)
dlmwrite('output/zPlot.csv',zPlotTrimmed)
dlmwrite('output/nG.csv',nG)
writecell(nGsizes,'output/nGsizes.csv')



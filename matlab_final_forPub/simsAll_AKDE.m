%% Bootstrappying code: Simulations for departures 
% C.S. Riebe, C.E. Lukens, L.S. Sklar, and D.L Shuster, 2023 

% Runs Monte-Carlo-style simulations using a specific catchment hypsometry 
% and generates likelihood that a measured age distribution with n grains 
% will be departed from the catchment hypsometry for given thresholds 
% (alpha values)

clear
close all
addpath('input')
addpath('output')
addpath('functions')
addpath('akde1d')
addpath('akdeResults')


%% User Inputs
nL=500; nP=2000; N=nL*nP; %This setup gets around matrix size limits, so we can run 10^6 simulations.
lbin=49; % lbin and ubin define upper and lower bins for the actual range of elevations at Inyo Creek (2050-3995m)
ubin=223; 

%multiply nL time nP to get number of samples in Monte Carlo Simulation
thresholds=[0.05,0.1,0.5,1,2.5,(5:5:95),97.5,99,99.5,99.9,99.95]';
nThresh=length(thresholds);

%set limits and spacing of age axis:
spacing = 0.25; %Ma
lowLimit = 10; %Ma
highLimit = 90; %Ma
nPts=(highLimit-lowLimit)/spacing+1; %number of plotting points for density trace
agePlot = (lowLimit: spacing : highLimit)'; %ages at each plotting point along density trace
[zPlot,zPlotUnc]=ageZ(agePlot); %convert age range into elevation range

% Read in Data and Assign Data to Local Variables
A=importdata('input/inyoXYZS.csv',',',1);
elev=A.data(:,3);

B=importdata('output/nG1.csv',',',0);
nG=B'; % number of grains measured

% C=importdata('output/nGsizes.csv',',');
nGsizes={'1-2';'2-4';'4-8';'8-16';'16-32';'32-48-2012';'32-48-2011';...
    '48-64';'64-96';'96-128';'128-192';'192-256';'>256'};

%for j=1:length(nG) - loops through each grain size
for j=10:10
    disp(['Number of grains = ',num2str(nG(j)),', iteration ',...
        num2str(j),' out of ',num2str(length(nG)),'.'])
   

%% Create Synthetic Age Distributions
    disp('Taking random samples...')
    tic

    nTotal=N*nG(j);
    pdfNorm=zeros(nPts,nL*nP);
    akdeA=zeros(nPts,nL*nP);
    
    distG=datasample(elev,nTotal);
    %sample the population of elevations for N 
    %simulations of nG measured grains

    R=random('Normal',0,1,[nTotal 1]); 
    %Gaussian scaling factor for uncertainty in age at any given elevation

    [age,ageUnc,ageUnc2]=zAge(distG);
    %convert elevations to bedrock ages with associated uncertainties

    ageRand=age+R.*ageUnc;
    ageSim=reshape(ageRand,[nG(j),N]);

    toc
    
%% Use AKDE to create simulated distributions
    disp('Using AKDE function to generate age distributions...')    
    tic
    parfor i=1:N        
        [akdeAge,agelist]=akde1d(ageSim(:,i),agePlot);
        akdeAgeArea=sum(akdeAge); %calculate area under the akde
        akdeA(:,i)=akdeAge/akdeAgeArea; %normalize akde by area
        
        pdfNorm(:,i)=akdeA(:,i); %normalize akde by area
        
    end
    
    toc

    
%% Percentile Calculations
    disp('Determining percentile thresholds on departures for simulations...')
    tic
    D=zeros(nPts,nThresh); %initialize D, which is going to store all the 
    %percentiles of the Monte Carlo simulations
    D50 = median(pdfNorm,2); %median - need this first to calculate
    %departures (difference between percentile thresholds and median)
    depOut=zeros(nPts,nThresh);
    for i=1:nThresh %cycles through all of the %tile thresholds established 
        %earlier
        D(:,i)=prctile(pdfNorm,thresholds(i),2); %these are the percentiles
        depOut(:,i)=D(:,i)-D50; %these are the departures
    end
    toc


%% Trim Matrices to Elevations Spanned by Catchment
    disp('Trimming matrices to elevations spanned by catchments...')
    tic
    depOut=depOut((lbin:ubin),:);
    pdfNorm=pdfNorm((lbin:ubin),:);
    D50=D50((lbin:ubin),:);
    zPlotA=zPlot((lbin:ubin),1);
    nPtsA = size(depOut,1);
    toc


%% Probability Calculations
    disp('Calculating probabilities of departures...')
    tic
    [probSum, probArea, elevFrac, nPrime, l, a] = ...
        depStatsLengthArea(depOut,pdfNorm,D50,nPtsA,N,nL);
    toc


%% Save Data
    disp('Saving data to files...')
    tic
    dlmwrite(['output/N_',num2str(nP*nL),'_nG_',num2str(nG(j)),'_',...
        nGsizes{j},'_depOutMC.csv'],depOut)
    dlmwrite(['output/N_',num2str(nP*nL),'_nG_',num2str(nG(j)),'_',...
        nGsizes{j},'_probSum.csv'],probSum)
    dlmwrite(['output/N_',num2str(nP*nL),'_nG_',num2str(nG(j)),'_',...
        nGsizes{j}, '_D50.csv'],D50)
    dlmwrite(['output/N_',num2str(nP*nL),'_nG_',num2str(nG(j)),'_',...
        nGsizes{j},'_probArea.csv'],probArea)
    dlmwrite('output/z.csv',zPlot)
    dlmwrite('output/e.csv',elevFrac)
    toc


%% Plot
    disp('Plotting data...')
    tic
    [filename]=figureDepStats(zPlotA,depOut,elevFrac,probSum,nPrime,N,nG(j));
    toc

end
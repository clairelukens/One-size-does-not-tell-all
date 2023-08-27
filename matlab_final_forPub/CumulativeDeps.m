
%% Cumulative depature calculation and plotting
% Functions used: figureDepStatsPoints

clear
close all
addpath('output')
addpath('functions')
addpath('suppInfo')

SPDF=importdata('akde_Z_measured.csv',',',0);
nG=importdata('suppInfo/nG.csv',',',0);
nGsizes={'1-2';'2-4';'4-8';'8-16';'16-32';'32-48-2012';'32-48-2011';...
    '48-64';'64-96';'96-128';'128-192';'192-256';'>256'};
z=importdata('zPlot.csv',',',0);
elevFrac=(0:0.001:1);

N=1000000;

%for i=1:length(nG) -- turn this line on and comment out "i=10:10" below to
%plot ALL sizes. 
    
for i=10:10 % this will just plot a single size (in this case, size #10, 96-128 mm)
    file1=(['output/N_',num2str(N),'_nG_',num2str(nG(i)),...
        '_',nGsizes{i},'_depOutMC.csv']);
    depOut=importdata(file1,',',0);
    file2=(['output/N_',num2str(N),'_nG_',num2str(nG(i)),...
        '_',nGsizes{i},'_probSum.csv']);
    probSum=importdata(file2,',',0);
    file3=(['output/N_',num2str(N),'_nG_',num2str(nG(i)),...
        '_',nGsizes{i},'_D50.csv']);
    D50=importdata(file3,',',0);
    
    nPrime = size(depOut,2)-1;
    nPts = size(depOut,1);
    
    depSPDF=SPDF(:,i)-D50;
    depSPDFrep=repmat(depSPDF,[1,nPrime+1]);
    depSPDFneg=depOut-depSPDFrep;
    depSPDFpos=depSPDFrep-depOut;
    Lm=zeros(nPts,nPrime);
    Lm(:,(1:14)) = depSPDFneg(:,(1:14));
    Lm(:,(15:28)) = depSPDFpos(:,(16:29));
    lm=(Lm>0);
    am=lm.*Lm;

    sm=sum(lm,1);
    smnorm=sm/nPts;

    smSum=zeros(nPrime/2,1);
    intSum=zeros(nPrime/2,1);
    
    for j= 0:(nPrime/2-1)
        smSum(j+1)=smnorm(1,j+1)+smnorm(1,nPrime-j);
        ind=round(smSum(j+1)*1000)+1;
        intSum(j+1)=probSum(ind,j+1);
    end
    
    [filename]=figureDepStatsPoints(z,depOut,elevFrac,probSum,...
        nPrime,N,nG(i),smSum,intSum,nGsizes(i),depSPDF);
    
end


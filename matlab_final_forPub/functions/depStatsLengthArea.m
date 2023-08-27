function[probSum, probArea, elevFrac, nPrime, l, a] =...
    depStatsLengthArea(depOut, pdfNorm, D50, nPts, N, nL)
% by C Riebe, C Lukens, and L Sklar, Mar 29, 2021

%% Background and Goals
%   In previous work, we have generated synthetic distributions of random
% samples of bedrock ages from a catchment with known age-elevation
% relationship in order to obtain a statistical understanding of the
% likelihood of "departure" (i.e., whether it unlikely to arise by chance 
% from spatially uniform erosion of hypsometry for observed age 
% distributions from various grain size classes in the stream. Using a 
% percentile analysis, we generated thresholds of excedence to define
% departures of varying likelihood (e.g., 95%, 99%, etc.). Because we
% normalized the excedence thresholds to the median, they created bounding
% intervals that bracket zero and look like "eyeballs" when plotted as a
% function of elevation, because of the way catchments pinch out in area at
% the outlet and in the headwaters.
%   Our goal in the current analysis was to use the using the completely 
% synthetic data involved in the eyeball analysis to:
% 1) quantify the sum of the lengths of the departures for each simulation
%   to generate a distribution of simulated lengths;
% 2) also calculate height at each departure and ultimately area departed
% 3) get contiguous lengths (sum total but also keep track of longest 
%   continuous strand
% 4) also calculate contiguous area
% 
% Thus we can find, for each of our measured distirbutions, the probability
%    that we:
% would get a longer total length of departure by chance;
% would get a greater area of departure by chance; and
% would get a longer contiguous length of departure by chance;
% would get a greater contiguous area of departure by chance.

%% Input Data
nP=N/nL; %this is the number of points in each loop
elevFrac=(0:0.001:1)'; %specified fraction of the elevations 

nPrime=size(depOut,2)-1; %number of percentile thresholds (excluding the 
%median)
d50=repmat(D50,[1,N]); % median departure
depPDF=pdfNorm-d50;  % individual synthetic departures from median 

Lneg=zeros(nPts,N);
Lpos=zeros(nPts,N);

probSum=zeros(length(elevFrac),nPrime/2);
probArea=zeros(length(elevFrac),nPrime/2);

l=zeros(length(elevFrac),nPrime/2);
a=zeros(length(elevFrac),nPrime/2);


%% Calculations
for j=0:(nPrime/2-1)
    depOutL=depOut(:,(j+1));
    depOutLrep=repmat(depOutL,[1,N]);
    depOutU=depOut(:,nPrime+1-j);   
    depOutUrep=repmat(depOutU,[1,N]);
    %negative departures (below %tile threshold) are positive:
    for i = 0:(nL-1)
        n1=1+i*nP;
        n2=(i+1)*nP;
        Lneg (:,(n1:n2)) = depOutLrep(:,(n1:n2))-depPDF(:,(n1:n2)); 
        %positive departures (above %tile threshold) are positive:  
        Lpos (:,(n1:n2)) = depPDF(:,(n1:n2))-depOutUrep(:,(n1:n2));
    end
    lneg=(Lneg>0);
    lpos=(Lpos>0);
    aneg=Lneg.*lneg;
    apos=Lpos.*lpos;
    l=lneg+lpos;
    a=aneg+apos;
    
    
    %% Goal 1
    s=sum(l,1); 
%this is the sum of departures in each simulation for each of
%the different percentile thresholds
    snorm=s/nPts; %normalizing s to number of bins
    %achieve goal 1: probability of having cumulative departure at least as 
%long as fraction of catchment elevation (calculated for each fraction 
%from 0 to 1)

    probSum(:,j+1)=sum((snorm>=elevFrac),2)/N;
%this vector represents a pair of percentile 
%thresholds; each column is the fraction out of 1,000,000 instances that we
%have a departed fraction (above or below the eyeball) that is at least as 
%long as the specified elevation fraction (cumulative)


    %% Goal 2
%sum height at each departure and thus area departed across all departures
    aT=sum(a,1);
%achieve goal 2: probability of having area of departure at
%least as large as specified values
    probAreaAwk=sum((aT>=elevFrac),2)/N;
    probArea(:,j+1)=squeeze(probAreaAwk);
    

    
    
    
    
    
    
    
end

end

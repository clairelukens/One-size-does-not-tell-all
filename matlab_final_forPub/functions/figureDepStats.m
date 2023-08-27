function[filename]=figureDepStats(z,depOut,elevFrac,probSum,nPrime,N,nG)

addpath('label_v5')
addpath('plots')

set(0,'defaultaxesfontname','Arial'); set(0,'defaultaxesfontsize',12);
set(0,'defaultaxesfontweight','Normal');
set(0,'defaulttextfontname','Arial'); set(0,'defaulttextfontsize',12);

CI = {'0.999','0.998','0.99','0.98','0.95','0.90',...
    '0.80','0.70','0.60','0.50','0.40','0.30',...
    '0.20','0.10'};
colors = {'k','c','r','g','b','m','k','c','r','g','b','m','k','c'};

%set plotting range and tick locations
ticksX=(0:0.1:1);
ticksY=([0.001 0.003 0.01 0.03 0.1 0.3 1]);

figure('Name',['N grains=',num2str(nG),...
    '; N sims=',num2str(N)],...
    'Position',[100 200 1200 500])

subplot(1,2,1)
for i=0:nPrime/2-1
    h1=plot(z,depOut(:,(i+1)),colors{i+1});
    hold on
    h2=plot(z,depOut(:,(nPrime+1-i)),colors{i+1});
    if floor((i+1)/2)==(i+1)/2
    else
        label(h1,CI{i+1},'location','center','slope')
        label(h2,CI{i+1},'location','center','slope')       
    end
end

plot(z,depOut(:,15),'k')

xlabel('Elevation (m)'); 
ylabel('Departure from hypsometry (1/m)')
xlim([2000 4000]);
ylim([-16E-3 20E-3]);
set(gca,'TickDir','out')
titletext=(['Departure plot; N = ',num2str(N),'; nG =',num2str(nG)]);
title(titletext)

subplot(1,2,2)
for j=1:nPrime/2
    semilogy(elevFrac,probSum(:,j),colors{j},'Linewidth',1);
    hold on
end

xlabel('Cumulative length of departure (as a fraction of elevations)'); 
ylabel('Fraction of simulations with departures ≥ cumulative length')
xlim([0.002 max(ticksX)]);
xticks(ticksX)
ylim([min(ticksY) max(ticksY)]);
yticks(ticksY)
set(gca,'TickDir','out')
title('Probability of total departure length')

filename=(['plots/log_length_N',num2str(N),'_nG',num2str(nG),'.png']);

saveas(gcf,filename)

end
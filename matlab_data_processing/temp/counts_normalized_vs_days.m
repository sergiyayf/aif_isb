clc 
clear 
close all

data = restructure_5D_all(); 

CHX=[0 25 50 100 150];
BED=[0 0.5 1 1.5 2 4 10];
DAYS=[1:6];
sets=[1 2];

% plotting
colors=winter(length(BED))
if BED(end)==10
    colors(end,:)=[1 0 0];
end
for set = sets
    
for chxIndex=1:length(CHX)
    chx=CHX(chxIndex);
    figure(chxIndex+(set-1)*5);
       
    for bedIndex=1:length(BED)
        bed=BED(bedIndex);
        y=squeeze(data(chxIndex,bedIndex,:,set,:));
        x=DAYS;
        plot(x,y(:,3)./y(1,3),'-o',"color",colors(bedIndex,:),'linewidth',2)
        hold on
        plot(x,y(:,2)./y(:,3),':o',"color",colors(bedIndex,:),'linewidth',2)
            
    end
    legend
    title(['CHX=' num2str(chx) 'set=' num2str(set)]);
    hold off
end

end


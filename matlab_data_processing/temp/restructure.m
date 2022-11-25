% script to restructure data colony data structure for easier visualization
clc
clear
close all
% parameter space
CHX=[0 25 50 100];
BED=[0 0.5 1 1.5 2 4 10];
DAYS=[1:6];

% load data from raw
if exist("dataCol")==0
    for day=DAYS
        load(['data_day_' num2str(day) '.mat'],'Colony');
        dataCol{day}=Colony;
       
    end
end

%restructure
data=zeros(length(CHX),length(BED),length(DAYS),3);
for day=DAYS
    for chxIndex=1:length(CHX)
        chx=CHX(chxIndex);
        for bedIndex=1:length(BED)
            bed=BED(bedIndex);
            data(chxIndex,bedIndex,day,1)=0;  
            data(chxIndex,bedIndex,day,2)=0; 
            data(chxIndex,bedIndex,day,3)=0; 
            for file=1:length(dataCol{1})
                if dataCol{day}(file).metadata.CHX==chx && dataCol{day}(file).metadata.BED==bed
                    data(chxIndex,bedIndex,day,1)=data(chxIndex,bedIndex,day,1)+dataCol{day}(file).count_red;  %number of red sectors
                    data(chxIndex,bedIndex,day,2)=data(chxIndex,bedIndex,day,2)+dataCol{day}(file).count_blue;  %number of blue sectors
                    data(chxIndex,bedIndex,day,3)=data(chxIndex,bedIndex,day,3)+dataCol{day}(file).count_total;  %total number of sectors
                elseif bed==10 && contains(dataCol{day}(file).name,"yJK26c")
                    data(chxIndex,bedIndex,day,1)=data(chxIndex,bedIndex,day,1)+dataCol{day}(file).count_red;  %number of red sectors
                    data(chxIndex,bedIndex,day,2)=data(chxIndex,bedIndex,day,2)+dataCol{day}(file).count_blue;  %number of blue sectors
                    data(chxIndex,bedIndex,day,3)=data(chxIndex,bedIndex,day,3)+dataCol{day}(file).count_total;
                end
            end
        end
    end
end

% plotting
colors=winter(length(BED))
if BED(end)==10
    colors(end,:)=[1 0 0];
end

for chxIndex=1:length(CHX)
    chx=CHX(chxIndex);
    figure(chxIndex);
       
    for bedIndex=1:length(BED)
        bed=BED(bedIndex);
        y=squeeze(data(chxIndex,bedIndex,:,:));
        x=DAYS;
        plot(x,y(:,3)./y(1,3),'-o',"color",colors(bedIndex,:),'linewidth',2, 'DisplayName', num2str(bed))
        hold on
        plot(x,y(:,2)./y(:,3),':o',"color",colors(bedIndex,:),'linewidth',2, 'DisplayName', num2str(bed))
            
    end
    legend
    title(['CHX=' num2str(chx)]);
    hold off
end

        
% script to restructure data colony data structure for easier visualization
% 5D matrix 
function data = restructure_5D_all()
% parameter space
CHX=[0 25 50 100 150];
BED=[0 0.5 1 1.5 2 4 10];
DAYS=[1:6];
sets=[1 2]; % 1 is new, 2 is old 
% load data from raw
if exist("dataCol")==0
    for day=DAYS
        load(['data_day_' num2str(day) '.mat'],'Colony');
        dataCol{day,1}=Colony;
        load(['JK_data_day_' num2str(day) '.mat'],'Colony');
        dataCol{day,2}=Colony;
    end
end

%restructure
data=zeros(length(CHX),length(BED),length(DAYS),length(sets),3);
%restructure new data
for set = sets 
    
for day=DAYS
    for chxIndex=1:length(CHX)
        chx=CHX(chxIndex);
        for bedIndex=1:length(BED)
            bed=BED(bedIndex);
            data(chxIndex,bedIndex,day,set,1)=0;  
            data(chxIndex,bedIndex,day,set,2)=0; 
            data(chxIndex,bedIndex,day,set,3)=0;
            for file=1:length(dataCol{1,set})
                if dataCol{day,set}(file).metadata.CHX==chx && dataCol{day,set}(file).metadata.BED==bed
                    data(chxIndex,bedIndex,day,set,1)=data(chxIndex,bedIndex,day,set,1)+dataCol{day,set}(file).count_red;  %number of red sectors
                    data(chxIndex,bedIndex,day,set,2)=data(chxIndex,bedIndex,day,set,2)+dataCol{day,set}(file).count_blue;  %number of blue sectors
                    data(chxIndex,bedIndex,day,set,3)=data(chxIndex,bedIndex,day,set,3)+dataCol{day,set}(file).count_total;  %total number of sectors
                elseif bed==10 && contains(dataCol{day,set}(file).name,"yJK26c")
                    data(chxIndex,bedIndex,day,set,1)=data(chxIndex,bedIndex,day,set,1)+dataCol{day,set}(file).count_red;  %number of red sectors
                    data(chxIndex,bedIndex,day,set,2)=data(chxIndex,bedIndex,day,set,2)+dataCol{day,set}(file).count_blue;  %number of blue sectors
                    data(chxIndex,bedIndex,day,set,3)=data(chxIndex,bedIndex,day,set,3)+dataCol{day,set}(file).count_total;
                end
            end
        end
    end
end

end


end
        
clc 
clear 
close all

% load day 1 for the purpose of normalization; 
day_to_look = 1; 
load(['data_day_' num2str(day_to_look) '.mat'],'Colony');
Colonyday1 = Colony;

d1_BED_vector = [];
d1_CHX_vector = [];
d1_scene_vector = []; 
d1_plate_vector = []; 
for j = 1:1:length(Colonyday1)
        FileName = Colonyday1(j).name; 
        day_start = strfind(FileName, 'day');
        Colonyday1(j).metadata.plate = FileName(day_start+4);
        if isempty(strfind(Colonyday1(j).name,'yJK26c')) == false
            Colonyday1(j).metadata.BED = 10;  
        end
        
        d1_BED_vector = [d1_BED_vector; Colonyday1(j).metadata.BED];
        d1_CHX_vector = [d1_CHX_vector; Colonyday1(j).metadata.CHX]; 
        d1_scene_vector = [d1_scene_vector; Colonyday1(j).metadata.scene];
        d1_plate_vector = [d1_plate_vector; Colonyday1(j).metadata.plate]; 
end

% go through all days 
for day_to_look = 1:9
clear onelt tots normalized blues blues_normalized
load(['data_day_' num2str(day_to_look) '.mat'],'Colony');
dataCol = Colony; 

% find condition 
BED_vector = [];
CHX_vector = []; 
for j = 1:1:length(dataCol)
        if isempty(strfind(dataCol(j).name,'yJK26c')) == false
            dataCol(j).metadata.BED = 10;  
        end
        BED_vector = [BED_vector; dataCol(j).metadata.BED];
        CHX_vector = [CHX_vector; dataCol(j).metadata.CHX]; 
        
        FileName = dataCol(j).name; 
        day_start = strfind(FileName, 'day');
        dataCol(j).metadata.plate = FileName(day_start+4);
end

% plot ones with certain condition
% CHX 0 BED 0 here 
inds = find(BED_vector == 0 & CHX_vector == 0);
for j = 1:length(inds)
    
tots(j) = dataCol(inds(j)).count_total;
blues(j) = dataCol(inds(j)).count_blue + dataCol(inds(j)).count_mixed;
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 6 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalized(j) = tots(j)/Colonyday1(index).count_total; 
blues_normalized(j) = blues(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(tots));

meanNumTot(day_to_look) = mean(tots);
meanNumBlue(day_to_look) = mean(blues);

stdNumTot(day_to_look) = std(tots);
stdNumBlue(day_to_look) = std(blues);

% CHX 0 BED 10 here 
inds = find(BED_vector == 10 & CHX_vector == 0);
for j = 1:length(inds)
    
tots10(j) = dataCol(inds(j)).count_total;
blues10(j) = dataCol(inds(j)).count_blue + dataCol(inds(j)).count_mixed;
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 10 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalized10(j) = tots10(j)/Colonyday1(index).count_total; 
blues_normalized10(j) = blues10(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(tots10));

meanNumTot10(day_to_look) = mean(tots10);
meanNumBlue10(day_to_look) = mean(blues10);

stdNumTot10(day_to_look) = std(tots10);
stdNumBlue10(day_to_look) = std(blues10);

% CHX 0 BED 10 here 
inds = find(BED_vector == 6 & CHX_vector == 50);
for j = 1:length(inds)
    
tots6(j) = dataCol(inds(j)).count_total;
blues6(j) = dataCol(inds(j)).count_blue + dataCol(inds(j)).count_mixed;
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 6 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalized6(j) = tots6(j)/Colonyday1(index).count_total; 
blues_normalized6(j) = blues6(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(tots6));

meanNumTot6(day_to_look) = mean(tots6);
meanNumBlue6(day_to_look) = mean(blues6);

stdNumTot6(day_to_look) = std(tots6);
stdNumBlue6(day_to_look) = std(blues6);

% CHX 50 BED 0 here 
inds = find(BED_vector == 0 & CHX_vector == 50);
for j = 1:length(inds)
    
totsCHX50BED0(j) = dataCol(inds(j)).count_total;
bluesCHX50BED0(j) = dataCol(inds(j)).count_blue + dataCol(inds(j)).count_mixed;
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 0 & d1_CHX_vector == 50 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalizedCHX50BED0(j) = totsCHX50BED0(j)/Colonyday1(index).count_total; 
blues_normalizedCHX50BED0(j) = bluesCHX50BED0(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(totsCHX50BED0));

meanNumTotCHX50BED0(day_to_look) = mean(totsCHX50BED0);
meanNumBlueCHX50BED0(day_to_look) = mean(bluesCHX50BED0);

stdNumTotCHX50BED0(day_to_look) = std(totsCHX50BED0);
stdNumBlueCHX50BED0(day_to_look) = std(bluesCHX50BED0);

end

errorbar([1:9],meanNumTot,stdNumTot,'ro-', 'DisplayName', 'tot num ctrl-')
hold on
errorbar([1:9],meanNumTot10,stdNumTot10,'bo-', 'DisplayName', 'tot num ctrl+')
errorbar([1:9],meanNumTot6,stdNumTot6,'co-', 'DisplayName', 'tot num BED 6')
errorbar([1:9],meanNumTotCHX50BED0,stdNumTotCHX50BED0,'ko-', 'DisplayName', 'tot num BED 0 CHX 50')
legend


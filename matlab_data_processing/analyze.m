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
        BED_vector = [BED_vector; dataCol(j).metadata.BED];
        CHX_vector = [CHX_vector; dataCol(j).metadata.CHX]; 
        
        FileName = dataCol(j).name; 
        day_start = strfind(FileName, 'day');
        dataCol(j).metadata.plate = FileName(day_start+4);
end

% plot ones with BED == 6 
inds = find(BED_vector == 6);
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
%scatter(day_to_look,mean(tots), 'red')
%errorbar(day_to_look, mean(tots), std(tots), 'red') 

%scatter(day_to_look,mean(blues), 'm')
%errorbar(day_to_look, mean(blues), std(blues), 'm') 

meanNumTot(day_to_look) = mean(tots);
meanNumBlue(day_to_look) = mean(blues);

stdNumTot(day_to_look) = std(tots);
stdNumBlue(day_to_look) = std(blues);
hold on 
end

errorbar([1:9],meanNumTot,stdNumTot,'ro-', 'DisplayName', 'tot num BED 6')
hold on
errorbar([1:9],meanNumBlue,stdNumBlue,'bo-', 'DisplayName', 'blue num BED 6')
legend


%% here BED 4 

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
        BED_vector = [BED_vector; dataCol(j).metadata.BED];
        CHX_vector = [CHX_vector; dataCol(j).metadata.CHX]; 
        
        FileName = dataCol(j).name; 
        day_start = strfind(FileName, 'day');
        dataCol(j).metadata.plate = FileName(day_start+4);
end

% plot ones with BED == 4 
inds = find(BED_vector == 4);
for j = 1:length(inds)
    
tots(j) = dataCol(inds(j)).count_total;
blues(j) = dataCol(inds(j)).count_blue + dataCol(inds(j)).count_mixed; 
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 4 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalized(j) = tots(j)/Colonyday1(index).count_total; 
blues_normalized(j) = blues(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(tots));
%scatter(day_to_look,mean(tots), 'blue')
%errorbar(day_to_look, mean(tots), std(tots), 'blue') 

%scatter(day_to_look,mean(blues), 'c')
%errorbar(day_to_look, mean(blues), std(blues), 'c') 

meanNumTot(day_to_look) = mean(tots);
meanNumBlue(day_to_look) = mean(blues);

stdNumTot(day_to_look) = std(tots);
stdNumBlue(day_to_look) = std(blues);

hold on 
end

%errorbar([1:9],meanNumTot,stdNumTot,'*-', 'DisplayName', 'tot num BED 4')
%hold on
%errorbar([1:9],meanNumBlue,stdNumBlue,'*-', 'DisplayName', 'blue num BED 4')
%legend

%% here CHX 50 BED 0 

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
        d1_BED_vector = [d1_BED_vector; Colonyday1(j).metadata.BED];
        d1_CHX_vector = [d1_CHX_vector; Colonyday1(j).metadata.CHX]; 
        d1_scene_vector = [d1_scene_vector; Colonyday1(j).metadata.scene];
        d1_plate_vector = [d1_plate_vector; Colonyday1(j).metadata.plate]; 
end

% go through all days 
for day_to_look = 1:9
clear onelt tots normalized
load(['data_day_' num2str(day_to_look) '.mat'],'Colony');
dataCol = Colony; 


% find condition 
BED_vector = [];
CHX_vector = []; 
for j = 1:1:length(dataCol)
        BED_vector = [BED_vector; dataCol(j).metadata.BED];
        CHX_vector = [CHX_vector; dataCol(j).metadata.CHX]; 
        
        FileName = dataCol(j).name; 
        day_start = strfind(FileName, 'day');
        dataCol(j).metadata.plate = FileName(day_start+4);
end

% plot ones with BED == 6 
inds = find(BED_vector == 0 & CHX_vector == 50);
for j = 1:length(inds)
    
tots(j) = dataCol(inds(j)).count_total;
blues(j) = dataCol(inds(j)).count_blue + dataCol(inds(j)).count_mixed; 
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 0 & d1_CHX_vector ==50 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalized(j) = tots(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(tots));
meanNumTot(day_to_look) = mean(tots);
meanNumBlue(day_to_look) = mean(blues);

stdNumTot(day_to_look) = std(tots);
stdNumBlue(day_to_look) = std(blues);

%scatter(day_to_look,mean(tots), 'black')
%errorbar(day_to_look, mean(tots), std(tots), 'black') 
hold on 
end
errorbar([1:9],meanNumTot,stdNumTot,'ko-', 'DisplayName', 'tot num BED 0')
xlabel('Day') 
ylabel('tot num')
title('CHX = 50 nM')
legend
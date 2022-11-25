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
freqs_red(j) = dataCol(inds(j)).red_pixels/dataCol(inds(j)).total_pixels; 
freqs_blue(j) = dataCol(inds(j)).blue_pixels/dataCol(inds(j)).total_pixels; 
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 6 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalized(j) = tots(j)/Colonyday1(index).count_total; 
blues_normalized(j) = blues(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(tots));
%plot(day_to_look,mean(freqs_red), 'red')
%errorbar(day_to_look, mean(freqs_red), std(freqs_red), 'red') 

meanFreqR(day_to_look) = mean(freqs_red);
stdFreqR(day_to_look) = std(freqs_red);

meanFreqB(day_to_look) = mean(freqs_blue);
stdFreqB(day_to_look) = std(freqs_blue);

%scatter(day_to_look,mean(freqs_blue), 'm')
%errorbar(day_to_look, mean(freqs_blue), std(freqs_blue), 'm') 

%hold on 
end
%plot([1:9],meanFreqR,'ro', 'DisplayName', 'red freq BED 6')
errorbar([1:9],meanFreqR,stdFreqR,'ro', 'DisplayName', 'red freq BED 6')
hold on
errorbar([1:9],meanFreqB,stdFreqB,'bo', 'DisplayName', 'blue freq BED 6')
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
freqs_red(j) = dataCol(inds(j)).red_pixels/dataCol(inds(j)).total_pixels; 
freqs_blue(j) = dataCol(inds(j)).blue_pixels/dataCol(inds(j)).total_pixels;
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

hold on 
end

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
freqs_red(j) = dataCol(inds(j)).red_pixels/dataCol(inds(j)).total_pixels; 
freqs_blue(j) = dataCol(inds(j)).blue_pixels/dataCol(inds(j)).total_pixels;
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 0 & d1_CHX_vector ==50 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalized(j) = tots(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(tots));
%plot(day_to_look,mean(freqs_red), 'red')
%errorbar(day_to_look, mean(freqs_red), std(freqs_red), 'red') 

meanFreqR(day_to_look) = mean(freqs_red);
stdFreqR(day_to_look) = std(freqs_red);

meanFreqB(day_to_look) = mean(freqs_blue);
stdFreqB(day_to_look) = std(freqs_blue);

%scatter(day_to_look,mean(freqs_blue), 'm')
%errorbar(day_to_look, mean(freqs_blue), std(freqs_blue), 'm') 

%hold on 
end
%plot([1:9],meanFreqR,'ro', 'DisplayName', 'red freq BED 6')
errorbar([1:9],meanFreqR,stdFreqR,'ko', 'DisplayName', 'red freq BED 0')
xlabel('Day') 
ylabel('Frequency')
title('CHX = 50 nM')
legend
hold on

%% control 
figure; 

% go through all days 
for day_to_look = 1:9
clear onelt tots normalized
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

% plot ones with BED == 6 
inds = find(BED_vector == 0 & CHX_vector == 0);
for j = 1:length(inds)
    
tots(j) = dataCol(inds(j)).count_total;
freqs_red(j) = dataCol(inds(j)).red_pixels/dataCol(inds(j)).total_pixels; 
freqs_blue(j) = dataCol(inds(j)).blue_pixels/dataCol(inds(j)).total_pixels;
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 

index = find( d1_BED_vector == 0 & d1_CHX_vector ==0 & d1_plate_vector == plate & d1_scene_vector == scene); 

normalized(j) = tots(j)/Colonyday1(index).count_total; 
end 

onelt = day_to_look*ones(1,length(tots));
%plot(day_to_look,mean(freqs_red), 'red')
%errorbar(day_to_look, mean(freqs_red), std(freqs_red), 'red') 

meanFreqR(day_to_look) = mean(freqs_red);
stdFreqR(day_to_look) = std(freqs_red);

meanFreqB(day_to_look) = mean(freqs_blue);
stdFreqB(day_to_look) = std(freqs_blue);

%scatter(day_to_look,mean(freqs_blue), 'm')
%errorbar(day_to_look, mean(freqs_blue), std(freqs_blue), 'm') 

%hold on 
end
%plot([1:9],meanFreqR,'ro', 'DisplayName', 'red freq BED 6')
errorbar([1:9],meanFreqR,stdFreqR,'ko', 'DisplayName', 'blue freq BED 0')
xlabel('Day') 
ylabel('Frequency')
title('CHX = 50 nM')
ylim([0,0.5])
legend
hold on
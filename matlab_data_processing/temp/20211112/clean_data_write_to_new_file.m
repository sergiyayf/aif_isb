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
for day_to_look = 1:5
clear onelt tots normalized blues blues_normalized
load(['data_day_' num2str(day_to_look) '.mat'],'Colony');
dataCol = Colony; 


% find condition 
BED_vector = [];
CHX_vector = []; 
scene_vector = [];
plate_vector = [];
for j = 1:1:length(dataCol)
        FileName = dataCol(j).name; 
        day_start = strfind(FileName, 'day');
        dataCol(j).metadata.plate = FileName(day_start+4);
        if isempty(strfind(dataCol(j).name,'yJK26c')) == false
            dataCol(j).metadata.BED = 10;  
        end
        BED_vector = [BED_vector; dataCol(j).metadata.BED];
        CHX_vector = [CHX_vector; dataCol(j).metadata.CHX]; 
        scene_vector = [scene_vector; dataCol(j).metadata.scene];
        plate_vector = [plate_vector; dataCol(j).metadata.plate];
        
        FileName = dataCol(j).name; 
        day_start = strfind(FileName, 'day');
        dataCol(j).metadata.plate = FileName(day_start+4);
end

% plot ones with BED == 6 
inds = find(CHX_vector == 0 & BED_vector ==10 & plate_vector=='C' & (plate_vector ~= 'D' | scene_vector ~= 5) );
for j = 1:length(inds)
    
tots(j) = dataCol(inds(j)).count_total;
blues(j) = dataCol(inds(j)).count_blue;
mixed(j) =  dataCol(inds(j)).count_mixed;
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 
Rad(j) = dataCol(inds(j)).radius_microns;
freqs_red(j) = dataCol(inds(j)).red_pixels/dataCol(inds(j)).total_pixels; 
freqs_blue(j) = dataCol(inds(j)).blue_pixels/dataCol(inds(j)).total_pixels; 

index = find( d1_CHX_vector == 0 & d1_BED_vector == 10 & d1_plate_vector == plate & d1_scene_vector == scene); 

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
meanNumMixed(day_to_look) = mean(mixed);

stdNumTot(day_to_look) = std(tots);
stdNumBlue(day_to_look) = std(blues);
stdNumMixed(day_to_look) = std(mixed);

TotNum(day_to_look) = sum(tots);
TotBlue(day_to_look) = sum(blues);
TotMixed(day_to_look) = sum(mixed); 

meanRad(day_to_look) = mean(Rad);

meanFreqRed(day_to_look) = mean(freqs_red);
stdFreqRed(day_to_look) = std(freqs_red); 

meanFreqBlue(day_to_look) = mean(freqs_blue); 
stdFreqBlue(day_to_look) = std(freqs_blue); 

numColonies(day_to_look) = length(inds); 

hold on 
end

csvwrite('CHX0BED0yJK26cplateA.txt',[meanRad.' meanNumTot.' stdNumTot.' meanNumBlue.' stdNumBlue.' meanNumMixed.' stdNumMixed.' TotNum.' TotBlue.' TotMixed.' meanFreqRed.' stdFreqRed.' meanFreqBlue.' stdFreqBlue.' numColonies.'])
errorbar([1:9],meanNumTot,stdNumTot,'ro-', 'DisplayName', 'tot num BED 6')
hold on
errorbar([1:9],meanNumBlue,stdNumBlue,'bo-', 'DisplayName', 'blue num BED 6')
legend

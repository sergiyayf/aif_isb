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
for day_to_look = 5
clear onelt tots normalized blues blues_normalized
load(['data_day_' num2str(day_to_look) '.mat'],'Colony');
dataCol = Colony; 


% find condition 
BED_vector = [];
CHX_vector = []; 
scene_vector = [];
plate_vector = [];
width = [];
color = [];
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
%inds = find(CHX_vector == 50 & BED_vector ==6 & plate_vector=='B' & (plate_vector ~= 'D' | scene_vector ~= 5) );
inds = find(CHX_vector == 50 & BED_vector ==0 );%& (plate_vector~='C' | scene_vector~=6) );
for j = 1:length(inds)
    
tots(j) = dataCol(inds(j)).count_total;
blues(j) = dataCol(inds(j)).count_blue;
mixed(j) =  dataCol(inds(j)).count_mixed;
scene = dataCol(inds(j)).metadata.scene;
plate = dataCol(inds(j)).metadata.plate; 
Rad(j) = dataCol(inds(j)).radius_microns;
freqs_red(j) = dataCol(inds(j)).red_pixels/dataCol(inds(j)).total_pixels; 
freqs_blue(j) = dataCol(inds(j)).blue_pixels/dataCol(inds(j)).total_pixels; 

width = [width; dataCol(inds(j)).streaks.size*dataCol(inds(j)).radius_microns];
color = [color; dataCol(inds(j)).streaks.color];

end 

end
numcol = ones(size(color))
numcol(color=='r') = 0; 
numcol(color=='b') = 1;
numcol(color=='m') = 2;

csvwrite('CHX50BED0_day5_width.txt',[width numcol])
%errorbar([1:9],meanNumTot,stdNumTot,'ro-', 'DisplayName', 'tot num BED 6')
%hold on
%errorbar([1:9],meanNumBlue,stdNumBlue,'bo-', 'DisplayName', 'blue num BED 6')
%legend

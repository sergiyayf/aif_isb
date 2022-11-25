clc 
clear
close all 

day = 1; 


filename = 'h5_data_cleaned.h5';

Colony_index = 0; 


for j = 1:9
load(['data_day_' num2str(j) '.mat'],'Colony');
for i=1:length(Colony)
% get plate name
FileName = Colony(i).name; 
day_start = strfind(FileName, 'day');
Colony(i).metadata.plate = FileName(day_start+4);

if isempty(strfind(Colony(i).name,'yJK26c')) == false
     Colony(i).metadata.BED = 10;  
end

% remove bad colonies   
if (Colony(i).metadata.BED == 0 & Colony(i).metadata.CHX == 0 & Colony(i).metadata.plate == 'A' & Colony(i).metadata.scene == 4)
    disp(Colony(i).metadata.day)
elseif (Colony(i).metadata.BED == 0 & Colony(i).metadata.CHX == 0 & Colony(i).metadata.plate == 'B' & Colony(i).metadata.scene == 1)
    disp(Colony(i).metadata.day)
elseif (Colony(i).metadata.BED == 10 & Colony(i).metadata.CHX == 0 & Colony(i).metadata.plate == 'D' & Colony(i).metadata.scene == 5)
    disp(Colony(i).metadata.day)
elseif (Colony(i).metadata.BED == 6 & Colony(i).metadata.CHX == 50 & Colony(i).metadata.plate == 'C' & Colony(i).metadata.scene == 6)
    disp(Colony(i).metadata.day)
else
    
    label = Colony(i).streaks.label;
    width = Colony(i).streaks.size;
    start = Colony(i).streaks.angle_start; 
    color = Colony(i).streaks.color ;
    numcol = ones(1,length(color));
    numcol(color=='r') = 0; 
    numcol(color=='b') = 1;
    numcol(color=='m') = 2;
    numcol = numcol';
    
    ds = [width,start,numcol]; 
    h5create(filename,['/colonies/col' num2str(Colony_index)],size(ds));
    h5write(filename, ['/colonies/col' num2str(Colony_index)],ds);

h5writeatt(filename, ['/colonies/col' num2str(Colony_index)],'plate',Colony(i).metadata.plate);

BED = Colony(i).metadata.BED;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)],'BED',BED);

CHX = Colony(i).metadata.CHX;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'CHX',CHX);

day = Colony(i).metadata.day;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'day',day);

scene = Colony(i).metadata.scene;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'scene',scene);

Radius = Colony(i).radius_microns;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'Radius',Radius);

count_red = Colony(i).count_red;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'count_red',count_red);

count_blue = Colony(i).count_blue;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'count_blue',count_blue);

count_mixed = Colony(i).count_mixed;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'count_mixed',count_mixed);

count_total = Colony(i).count_total;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'count_total',count_total);

red_pixels = Colony(i).red_pixels;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'red_pixels',red_pixels);

blue_pixels = Colony(i).blue_pixels;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'blue_pixels',blue_pixels);

total_pixels = Colony(i).total_pixels;
h5writeatt(filename, ['/colonies/col' num2str(Colony_index)], 'total_pixels',total_pixels);

Colony_index = Colony_index + 1 ;
end
end

end
h5writeatt(filename, ['/colonies'], 'order',['width', 'start', 'color']);
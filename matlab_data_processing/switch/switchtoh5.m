clc 
clear
close all 

day = 1; 


filename = 'data_switch.h5';

Colony_index = 0; 

for j = 1:7
load(['switch_' num2str(j) '.mat'],'Colony');
for i=1:length(Colony)

freq= [Colony(i).red_frequency, Colony(i).blue_frequency]; 
h5create(filename,['/colonies/col' num2str(Colony_index)],size(freq));
h5write(filename, ['/colonies/col' num2str(Colony_index)],freq);

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

Colony_index = Colony_index + 1 ;
end

end
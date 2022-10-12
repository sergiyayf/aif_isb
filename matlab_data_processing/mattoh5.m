clc 
clear
close all 

day = 1; 


filename = 'h5_data_cleaned.h5';
%h5create(filename,'/DS',1)

%A = convertCharsTonum2strings([Colony(1).name])
%B = Colony(1).count_red
%h5create(filename,'/1/',length(B))
%h5write(filename, '/1/',B)
Colony_index = 0; 
streak_index = 0;
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
h5create(filename,['/colonies/' num2str(Colony_index) '/label'],length(label));
h5write(filename, ['/colonies/' num2str(Colony_index) '/label'],label);

size = Colony(i).streaks.size;
h5create(filename,['/colonies/' num2str(Colony_index) '/size'],length(size));
h5write(filename, ['/colonies/' num2str(Colony_index) '/size'],size);

color = Colony(i).streaks.color ;
numcol = ones(1,length(color));
numcol(color=='r') = 0; 
numcol(color=='b') = 1;
numcol(color=='m') = 2;

h5create(filename,['/colonies/' num2str(Colony_index) '/color'],length(numcol));
h5write(filename, ['/colonies/' num2str(Colony_index) '/color'],numcol);

BED = Colony(i).metadata.BED;
h5create(filename,['/colonies/' num2str(Colony_index) '/BED'],length(BED));
h5write(filename, ['/colonies/' num2str(Colony_index) '/BED'],BED);

CHX = Colony(i).metadata.CHX;
h5create(filename,['/colonies/' num2str(Colony_index) '/CHX'],length(CHX));
h5write(filename, ['/colonies/' num2str(Colony_index) '/CHX'],CHX);

day = Colony(i).metadata.day;
h5create(filename,['/colonies/' num2str(Colony_index) '/day'],length(day));
h5write(filename, ['/colonies/' num2str(Colony_index) '/day'],day);

scene = Colony(i).metadata.scene;
h5create(filename,['/colonies/' num2str(Colony_index) '/scene'],length(scene));
h5write(filename, ['/colonies/' num2str(Colony_index) '/scene'],scene);

Radius = Colony(i).radius_microns;
h5create(filename,['/colonies/' num2str(Colony_index) '/Radius'],length(Radius));
h5write(filename, ['/colonies/' num2str(Colony_index) '/Radius'],Radius);

count_red = Colony(i).count_red;
h5create(filename,['/colonies/' num2str(Colony_index) '/count_red'],length(count_red));
h5write(filename, ['/colonies/' num2str(Colony_index) '/count_red'],count_red);

count_blue = Colony(i).count_blue;
h5create(filename,['/colonies/' num2str(Colony_index) '/count_blue'],length(count_blue));
h5write(filename, ['/colonies/' num2str(Colony_index) '/count_blue'],count_blue);

count_mixed = Colony(i).count_mixed;
h5create(filename,['/colonies/' num2str(Colony_index) '/count_mixed'],length(count_mixed));
h5write(filename, ['/colonies/' num2str(Colony_index) '/count_mixed'],count_mixed);

count_total = Colony(i).count_total;
h5create(filename,['/colonies/' num2str(Colony_index) '/count_total'],length(count_total));
h5write(filename, ['/colonies/' num2str(Colony_index) '/count_total'],count_total);

red_pixels = Colony(i).red_pixels;
h5create(filename,['/colonies/' num2str(Colony_index) '/red_pixels'],length(red_pixels));
h5write(filename, ['/colonies/' num2str(Colony_index) '/red_pixels'],red_pixels);

blue_pixels = Colony(i).blue_pixels;
h5create(filename,['/colonies/' num2str(Colony_index) '/blue_pixels'],length(blue_pixels));
h5write(filename, ['/colonies/' num2str(Colony_index) '/blue_pixels'],blue_pixels);

total_pixels = Colony(i).total_pixels;
h5create(filename,['/colonies/' num2str(Colony_index) '/total_pixels'],length(total_pixels));
h5write(filename, ['/colonies/' num2str(Colony_index) '/total_pixels'],total_pixels);


%{
for q = 1:length(label)
   h5create(filename,['/width/' num2str(streak_index) '/label'],length(label(q)));
   h5write(filename,['/width/' num2str(streak_index) '/label'],label(q));
   
   h5create(filename,['/width/' num2str(streak_index) '/size'],length(size(q)));
   h5write(filename,['/width/' num2str(streak_index) '/size'],size(q));
   
   h5create(filename,['/width/' num2str(streak_index) '/color'],length(numcol(q)));
   h5write(filename,['/width/' num2str(streak_index) '/color'],numcol(q));
   
   h5create(filename,['/width/' num2str(streak_index) '/BED'],length(BED));
   h5write(filename,['/width/' num2str(streak_index) '/BED'],BED);
   
   h5create(filename,['/width/' num2str(streak_index) '/CHX'],length(CHX));
   h5write(filename,['/width/' num2str(streak_index) '/CHX'],CHX);
   
   h5create(filename,['/width/' num2str(streak_index) '/day'],length(day));
   h5write(filename,['/width/' num2str(streak_index) '/day'],day);
   
   h5create(filename,['/width/' num2str(streak_index) '/scene'],length(scene));
   h5write(filename,['/width/' num2str(streak_index) '/scene'],scene);
   
    h5create(filename,['/width/' num2str(streak_index) '/Radius'],length(Radius));
   h5write(filename,['/width/' num2str(streak_index) '/Radius'],Radius);
   
    h5create(filename,['/width/' num2str(streak_index) '/count_red'],length(count_red));
   h5write(filename,['/width/' num2str(streak_index) '/count_red'],count_red);
   
    h5create(filename,['/width/' num2str(streak_index) '/count_blue'],length(count_blue));
   h5write(filename,['/width/' num2str(streak_index) '/count_blue'],count_blue);
   
    h5create(filename,['/width/' num2str(streak_index) '/count_mixed'],length(count_mixed));
   h5write(filename,['/width/' num2str(streak_index) '/count_mixed'],count_mixed);
   
    h5create(filename,['/width/' num2str(streak_index) '/count_total'],length(count_total));
   h5write(filename,['/width/' num2str(streak_index) '/count_total'],count_total);
   
    h5create(filename,['/width/' num2str(streak_index) '/red_pixels'],length(red_pixels));
   h5write(filename,['/width/' num2str(streak_index) '/red_pixels'],red_pixels);
   
    h5create(filename,['/width/' num2str(streak_index) '/blue_pixels'],length(blue_pixels));
   h5write(filename,['/width/' num2str(streak_index) '/blue_pixels'],blue_pixels);
   
    h5create(filename,['/width/' num2str(streak_index) '/total_pixels'],length(total_pixels));
   h5write(filename,['/width/' num2str(streak_index) '/total_pixels'],total_pixels);
    
   streak_index = streak_index+1;
end
%}
Colony_index = Colony_index + 1 ;
end
end

end
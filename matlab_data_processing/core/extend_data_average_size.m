clc 
clear 
close all

CHX=[0 25 50 100 150];
BED=[0 0.5 1 1.5 2 4 10];
DAYS=[1:7];
DAYS_JK=[1:6];
sets=[1 2]; % 1 is new, 2 is old 

zooms_new = [8 6.3 4.5];
scaling_factors_new = [5.675 7.212 10.022];
zooms_old = [8 6.3 4.5 4 3.5];
scaling_factors_old = [8.063 10.246 14.333 16.125 18.429];

day_to_look = 6; 
% load data from raw
%new
dataCol = [];
for day=DAYS
        load(['data_experiment_extended' num2str(day) '.mat'],'Colony');
        dataCol = Colony;



Sn = size(dataCol);

 
%set BED to 10 if infinity and also translate the radius to microns 
rad_microns = [];
cd 'C:\Users\saif\Desktop\Serhii\Projects\code\ER\Experiments_analysis\matlab\data\data_experiment_extended'
for j = 1:1:Sn(2)
      if isempty(strfind(dataCol(j).name,'yJK26c')) == false
            dataCol(j).metadata.BED = 10;  
      end
      z = dataCol(j).metadata.zoom; 
      [zm, zm_ind] = find(zooms_new == z);
      rad_microns = [rad_microns scaling_factors_new(zm_ind)*dataCol(j).radius];
      %dataCol(j).radius_microns = scaling_factors_new(zm_ind)*dataCol(j).radius;
      
      %dataCol(j).frequency = sum(dataCol(j).streaks.size)/(2*pi);
      
          Color = [];
      for strk=1:1:max(dataCol(j).streaks.label) 
         if dataCol(j).streaks.color(strk,:) == 'red ' 
               Color = [Color, 0];
         elseif dataCol(j).streaks.color(strk,:) == 'blue' 
               Color = [Color, 1];
         end    
      end
      [strk_red, strk_red_ind] = find(Color == 0); 
      [strk_blue, strk_blue_ind] = find(Color ==1); 
      % frequency is now average size of clones; 
      red_freq = sum(dataCol(j).streaks.size(strk_red_ind))/(length(strk_red_ind)); 
      blue_freq = sum(dataCol(j).streaks.size(strk_blue_ind))/(length(strk_blue_ind)); 
      tot_freq = sum(dataCol(j).streaks.size)/(2*pi);
      dataCol(j).red_av_size = red_freq; 
      dataCol(j).blue_av_size = blue_freq; 
      
end
Colony_output_name = ['data_experiment_extended' num2str(day) '.mat'];
Colony = dataCol;
save(Colony_output_name, 'Colony');

end

%old
dataCol_JK = [];
for day=DAYS_JK
        load(['data_experiment_extended' num2str(day) '_JK.mat'],'Colony');
        dataCol_JK = Colony;
        
        Sn = size(dataCol_JK);

 
%set BED to 10 if infinity and also translate the radius to microns 
rad_microns = [];
cd 'C:\Users\saif\Desktop\Serhii\Projects\code\ER\Experiments_analysis\matlab\data\data_experiment_extended'
for j = 1:1:Sn(2)
      if isempty(strfind(dataCol_JK(j).name,'yJK26c')) == false
            dataCol_JK(j).metadata.BED = 10;  
      end
      z = dataCol_JK(j).metadata.zoom; 
      [zm, zm_ind] = find(zooms_old == z);
      rad_microns = [rad_microns scaling_factors_old(zm_ind)*dataCol_JK(j).radius];
      %dataCol_JK(j).radius_microns = scaling_factors_old(zm_ind)*dataCol_JK(j).radius;
      
      %dataCol_JK(j).frequency = sum(dataCol_JK(j).streaks.size)/(2*pi);
      
      Color = [];
      for strk=1:1:max(dataCol_JK(j).streaks.label) 
         if dataCol_JK(j).streaks.color(strk,:) == 'red ' 
               Color = [Color, 0];
         elseif dataCol_JK(j).streaks.color(strk,:) == 'blue' 
               Color = [Color, 1];
         end    
      end
      [strk_red, strk_red_ind] = find(Color == 0); 
      [strk_blue, strk_blue_ind] = find(Color ==1); 
      red_freq = sum(dataCol_JK(j).streaks.size(strk_red_ind))/(length(strk_red_ind)); 
      blue_freq = sum(dataCol_JK(j).streaks.size(strk_blue_ind))/(length(strk_blue_ind)); 
      tot_freq = sum(dataCol_JK(j).streaks.size)/(2*pi);
      dataCol_JK(j).red_av_size = red_freq; 
      dataCol_JK(j).blue_av_size = blue_freq; 
      
end
Colony_output_name = ['data_experiment_extended' num2str(day) '_JK.mat'];
Colony = dataCol_JK;
save(Colony_output_name, 'Colony');


end
cd 'C:\Users\saif\Desktop\Serhii\Projects\code\ER\Experiments_analysis\matlab'
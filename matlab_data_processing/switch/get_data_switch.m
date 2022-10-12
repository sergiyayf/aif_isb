%function to store all the data from the images
 
 
 function Colony = get_data_switch(File, radius, radius_count, center, load_streaks, segment_color, count_red, count_blue, count_mixed, count_total, freq_red, freq_blue ) 
 
 FileName = File; 
 
 Colony.name = FileName; 
 
 %find specific strings in the filename; 
 %CHX is always 2:4 
 CHX = FileName(2:4); 
 CHX = str2num(CHX);
 Colony.metadata.CHX = CHX; 
 %BED is always 15:17 it has _, so a string for now 
 BED = FileName(15:17);
 BED(2) = '.';
 BED = str2num(BED);
 Colony.metadata.BED = BED;
 %zoom. still shit, becasue 8 is single, 6_3 is not 
 zoom_start = strfind(FileName, 'zoom');
 start = zoom_start+4;
 stop = zoom_start+6;
 zoom = FileName(start:stop);
 if zoom(2) == '_'
     zoom(2) = '.';
     zoom = str2num(zoom);
 elseif zoom(2) == ' '
     zoom = zoom(1); 
     zoom = str2num(zoom);
 end
 Colony.metadata.zoom = zoom; 
 % day can be stored as number 
 day_start = strfind(FileName, 'day');
 day = FileName(day_start-2);
 day = str2num(day);
 Colony.metadata.day = day; 
 %scene can also be stored as number 
 export = strfind(FileName, 'Export');
 scene = FileName(export+11);
 scene = str2num(scene); 
 Colony.metadata.scene = scene; 
 Colony.center = center;
 %sore radius; 
 Colony.radius = radius; 
 Colony.radius_microns = radius_count;
 
 %store streaks; 
 %load or calculate streaks here; 
 streaks = load_streaks;
 Colony.streaks.label = streaks(:,1);
 Colony.streaks.angle_start = streaks(:,2);
 Colony.streaks.angle_stop = streaks(:,3);
 Colony.streaks.size = streaks(:,4); 
 Colony.streaks.color = segment_color;

 %{
 streaks = load_streaks; 
 num_of_streaks = length(streaks); 
 for i=1:1:num_of_streaks
     Colony.streaks.label(i) = i; 
     Colony.streaks.angle(i) = angle;
     Colony.streaks.color(i) = color; 
     Colony.streaks.size(i) = streak_size; 
 end 
 %}
 Colony.count_red = count_red;
 Colony.count_blue = count_blue; 
 Colony.count_mixed = count_mixed; 
 Colony.count_total = count_total; 

 Colony.red_frequency = freq_red;
 Colony.blue_frequency = freq_blue; 
 end

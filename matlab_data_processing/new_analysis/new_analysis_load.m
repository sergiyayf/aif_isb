
function [unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std, rad_process, rad_mean, rad_std, red_size_process, red_size_mean, red_size_std, blue_size_process,blue_size_mean, blue_size_std] = new_analysis_load(day, chx_f)
day_look = day;
chx_find = chx_f; 
File = ['data_experiment_extended' day_look '.mat'];

load(File, 'Colony');

% initialize variables
filename = [];
CHXs = [];
BEDs = [];
total_counts = [];
blue_counts = [];
red_counts = [];
Rad_microns = []; 
red_size = []; 
blue_size = [];

% load from colony essentials 
for i = 1:1:length(Colony)
    
CHXs = [CHXs Colony(i).metadata.CHX];
BEDs = [BEDs Colony(i).metadata.BED];
total_counts = [total_counts Colony(i).count_total];
blue_counts = [blue_counts Colony(i).count_blue];
red_counts = [red_counts Colony(i).count_red]; 
Rad_microns = [Rad_microns Colony(i).radius_microns]; 

red_size = [red_size Colony(i).red_av_size];
blue_size = [blue_size Colony(i).blue_av_size];

end 

[chosen_chx, chx_ind] = find(CHXs == chx_find); 
chosen_chx = chosen_chx*chx_find;

bed_process = BEDs(chx_ind); 
tot_process = total_counts(chx_ind); 
blue_process = blue_counts(chx_ind);
rad_process = Rad_microns(chx_ind); 

red_size_process = red_size(chx_ind); 
blue_size_process = blue_size(chx_ind);
%plot(bed_process, tot_process, 'o');
%hold on

[ux_BED,~,id] = unique(bed_process);
%find mean counts
counts_mean = accumarray(id,tot_process,[],@mean);
blue_mean = accumarray(id,blue_process,[],@mean);
rad_mean = accumarray(id,rad_process, [], @mean); 

red_size_mean = accumarray(id,red_size_process,[],@mean);
blue_size_mean = accumarray(id,blue_size_process, [],@mean);

tot_std = accumarray(id,tot_process,[],@std);
blue_std = accumarray(id,blue_process,[],@std);
rad_std = accumarray(id,rad_process,[],@std);

red_size_std = accumarray(id,red_size_process,[],@std);
blue_size_std = accumarray(id,blue_size_process,[],@std);
%plot(ux_BED, counts_mean, '+');

unique_BED = ux_BED;
mean_tot = counts_mean; 
mean_blue = blue_mean; 

all_BED = bed_process; 
tot = tot_process;
blue = blue_process; 
end
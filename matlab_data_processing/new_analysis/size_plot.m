clc
clear 
close all


% initialize conditions 
day = '4'; 
day_1 = '1';
chx_f = 50; 

% load that day and plot
[unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std, rad_process, rad_mean, rad_std, red_size_process, red_size_mean, red_size_std, blue_size_process,blue_size_mean, blue_size_std] = new_analysis_load(day, chx_f)

figure;
errorbar(unique_BED, red_size_mean, red_size_std, '+', 'color', [1 0.5 0], 'DisplayName', 'std', 'MarkerSize', 4, 'Linewidth', 1.5); 
hold on 
plot(unique_BED, mean_tot, 'o', 'color', 'r', 'DisplayName', 'mean values', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); 
plot(all_BED, tot, '.', 'color', 'b', 'DisplayName', 'all data');
ylim([0 0.1]);
xlim([0 10]);
title(['CHX=' num2str(chx_f) '  day' num2str(day)]);
xlabel('Estradiol concentration');
ylabel('total number of sectors'); 
legend
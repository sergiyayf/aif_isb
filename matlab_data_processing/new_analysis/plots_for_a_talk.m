clc
clear 
close all


% initialize conditions 
day = '5'; 
day_1 = '1';
chx_f = 25; 

% load that day and plot
[unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std, rad_process, rad_mean, rad_std, red_size_process, red_size_mean, red_size_std, blue_size_process,blue_size_mean, blue_size_std] = new_analysis_load(day, chx_f)

figure;
errorbar(unique_BED, mean_blue, tot_std, '+', 'color', [1 0.5 0], 'DisplayName', 'std', 'MarkerSize', 4, 'Linewidth', 1.5); 
hold on 
plot(unique_BED, mean_blue, 'o', 'color', 'r', 'DisplayName', 'mean values', 'MarkerSize', 5, 'MarkerFaceColor', 'r'); 
plot(all_BED, blue, '.', 'color', 'b', 'DisplayName', 'all data');
ylim([0 120]);
title(['CHX=' num2str(chx_f) '  day' num2str(day)]);
xlabel('Estradiol concentration');
ylabel('total number of sectors'); 
legend

% load day 1 

[unique_BED_d1, mean_tot_d1, mean_blue_d1, all_BED_d1, tot_d1, blue_d1, tot_std_d1, blue_std_d1] = new_analysis_load(day_1, chx_f)

% plot normalized to day 1, means; 
figure; 
plot(unique_BED, mean_tot./mean_tot_d1, 's', 'MarkerFaceColor', [0.1 0.1 0.1], 'DisplayName', ['total normalized' day]);
ylim([0 1])
title(['CHX=' num2str(chx_f) '  day' num2str(day)]);
xlabel('Estradiol concentration');
ylabel('tot number normalized to day 1'); 
legend

figure;
boxplot(blue, all_BED,'Colors',[0, 0.4470, 0.7410], 'Symbol','+')


figure;


boxplot(tot, all_BED,'Colors',[0, 0.4470, 0.7410], 'Symbol','+')
%plot(all_BED, tot, 'd', 'color', 'b', 'DisplayName', 'all data');
hold on 
[unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std, rad_process, rad_mean, rad_std, red_size_process, red_size_mean, red_size_std, blue_size_process,blue_size_mean, blue_size_std] = new_analysis_load(day, 50)
boxplot(tot, all_BED,'Colors',[0.8500, 0.3250, 0.0980],'Symbol','+')
hold on 

[unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std, rad_process, rad_mean, rad_std, red_size_process, red_size_mean, red_size_std, blue_size_process,blue_size_mean, blue_size_std] = new_analysis_load(day, 100)
boxplot(tot, all_BED,'Colors', [0.9290, 0.6940, 0.1250],'Symbol','+')

h = zeros(3, 1);
h(1) = plot(NaN,NaN,'s','Color',[0, 0.4470, 0.7410]);
h(2) = plot(NaN,NaN,'s','Color',[0.8500, 0.3250, 0.0980]);
h(3) = plot(NaN,NaN,'s','Color',[0.9290, 0.6940, 0.1250]);
legend(h, 'Low','Intermediate','High');


%%% 



clc
clear 
%close all


% initialize conditions 
figure;
mtrx_tot = [];
mtrx_blue = [];
mtrx_rad = [];
mtrx_std = [];
days=[1:6];
for d = days

day = [num2str(d) ]; 
day_1 = '1';

%day = [num2str(d) '_JK']; 
%day_1 = '1_JK';

chx_f = 100; 

% load that day and plot
[unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std, rad_process, rad_mean, rad_std, red_size_process, red_size_mean, red_size_std, blue_size_process,blue_size_mean, blue_size_std] = new_analysis_load(day, chx_f);

[unique_BED_d1, mean_tot_d1, mean_blue_d1, all_BED_d1, tot_d1, blue_d1, tot_std_d1, blue_std_d1] = new_analysis_load(day_1, chx_f);
% plot normalized to day 1, means; 
dd = d*ones(size(mean_tot));
mtrx_tot = [mtrx_tot mean_tot];
mtrx_blue = [mtrx_blue mean_blue]; 
mtrx_rad = [mtrx_rad rad_mean];
mtrx_std = [mtrx_std tot_std];
end

coloring_vec = [1,2,3,4,5,10,15]
C = hot(21)
colormap hot
for j =1:1:length(unique_BED)
    
plot(mtrx_rad(j,:)-mtrx_rad(j,1), mtrx_tot(j,:)./mtrx_tot(j,2), '-d','color',C(coloring_vec(j),:), 'DisplayName', ['BED=' num2str(unique_BED(j)) ' tot'], 'LineWidth', 2);
hold on
plot(mtrx_rad(j,:)-mtrx_rad(j,1), (mtrx_blue(j,:))./mtrx_tot(j,:),':s','color',C(coloring_vec(j),:),'DisplayName', ['BED=' num2str(unique_BED(j)) ' delta blue'],'LineWidth', 2);
colorbar
end

ylim([-0.1 1])
title(['CHX=' num2str(chx_f) '  day' num2str(day) ' totals normalized to day 1, delta blue normalized to day x']);
xlabel('delta R');
ylabel('P survive'); 
legend
figure;

for j =1:1:length(unique_BED)
plot(mtrx_rad(j,:)-mtrx_rad(j,1), mtrx_tot(j,:), '-d', 'DisplayName', ['BED=' num2str(unique_BED(j)) ' tot' ], 'LineWidth', 2);
hold on
plot(mtrx_rad(j,:)-mtrx_rad(j,1), (mtrx_blue(j,:)-mtrx_blue(j,1)),':s','DisplayName', ['BED=' num2str(unique_BED(j)) ' delta blue'], 'LineWidth', 2);

errorbar(mtrx_rad(j,:)-mtrx_rad(j,1), mtrx_tot(j,:), mtrx_std(j,:), '+', 'color', [1 0.5 0], 'DisplayName', 'std', 'MarkerSize', 4, 'Linewidth', 1.5); 

end
ylim([-5 130])
title(['CHX=' num2str(chx_f) '  day' num2str(day) 'not normalized']);
xlabel('delta R');
ylabel('# total'); 
legend

%figure; 
%plot(mtrx_rad(7,:)-mtrx_rad(7,1), mtrx_tot(7,:)/mtrx_tot(7,1))
figure;
for k = 1:1:5
plot(days(k), mtrx_rad(:,k+1)-mtrx_rad(:,k),'-d')
hold on
end
%disp(mtrx_rad(2,:))
%disp(mtrx_tot(2,:)/mtrx_tot(2,2))
mtrx_rad
mtrx_blue
mtrx_tot
mtrx_blue./mtrx_tot
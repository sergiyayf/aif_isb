clc
clear 
close all


% initialize conditions 
chx = [25 50 100]; 

for chx_f = chx
figure;
mtrx_tot = [];
mtrx_blue = [];
mtrx_rad = [];
days=[1:6];
for d = days
    
day = [num2str(d)]; 
day_1 = '1';


% load that day and plot
[unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std, rad_process, rad_mean, rad_std, red_size_process, red_size_mean, red_size_std, blue_size_process,blue_size_mean, blue_size_std] = new_analysis_load(day, chx_f)

[unique_BED_d1, mean_tot_d1, mean_blue_d1, all_BED_d1, tot_d1, blue_d1, tot_std_d1, blue_std_d1] = new_analysis_load(day_1, chx_f)

% plot normalized to day 1, means; 
dd = d*ones(size(mean_tot));
mtrx_tot = [mtrx_tot mean_tot];
mtrx_blue = [mtrx_blue mean_blue]; 
mtrx_rad = [mtrx_rad rad_mean];
end



plot(unique_BED(:), mtrx_tot(:,days(length(days)))./mtrx_tot(:,1), '-d', 'LineWidth', 2, 'DisplayName', ['tot(' num2str(days(length(days))) ')/tot(1)']);
hold on
plot(unique_BED(:), mtrx_blue(:,days(length(days)))./mtrx_tot(:,days(length(days))), ':o', 'LineWidth',2, 'DisplayName', ['blue(' num2str(days(length(days))) ')/tot(' num2str(days(length(days))) ')']);
line([0,10],[mtrx_tot(length(unique_BED),days(length(days)))/mtrx_tot(length(unique_BED),1) , mtrx_tot(length(unique_BED),days(length(days)))/mtrx_tot(length(unique_BED),1)], 'DisplayName', ['neutral tot(' num2str(days(length(days))) ')/neutral tot(1)'])           
plot(unique_BED(:), mtrx_tot(:,1)./mtrx_tot(length(unique_BED),1), 'd', 'LineWidth',2, 'DisplayName', ['tot(1)/neutral(1)']);

% interpolation  
x = unique_BED(1:6);
y = mtrx_tot(1:6,days(length(days)))./mtrx_tot(1:6,1);
coef2 = polyfit(x, y, 1);
y = polyval(coef2,x);
plot(x,y, 'LineWidth',2, 'DisplayName', ['fit']);

x1 = unique_BED(1:6);
y1 = mtrx_tot(1:6,1)./mtrx_tot(length(unique_BED),1);
coef2 = polyfit(x1, y1, 1);
y1 = polyval(coef2,x1);
plot(x1,y1, 'LineWidth',2, 'DisplayName', ['fit']);

line([2,2],[y1(5),y(5)],'LineStyle', '--', 'color','k','LineWidth',2,'DisplayName', ['genetic drift after day 1']);
line([3,3],[y(5),mtrx_tot(length(unique_BED),days(length(days)))/mtrx_tot(length(unique_BED),1) ],'LineStyle', '--', 'color','r','LineWidth',2,'DisplayName', ['selection after day 1']);
line([2.5,2.5],[y1(5),1],'LineStyle', '--', 'color','c','LineWidth',2,'DisplayName', ['selection before day 1']);
line([0,10],[1,1], 'color', 'yellow');
%

ylim([-0.1 1.1])
title(['CHX=' num2str(chx_f) '  day' num2str(day)]);
xlabel('BED');
ylabel('Ratios'); 
legend

figure;

plot(mtrx_rad(1,:)-mtrx_rad(1,1), mtrx_tot(length(unique_BED),days)./mtrx_tot(length(unique_BED),1) - mtrx_tot(:,days)./mtrx_tot(:,1) , '--', 'LineWidth',2, 'DisplayName', [num2str(unique_BED(:))]);
hold on
plot(mtrx_rad(1,:)-mtrx_rad(1,1), mtrx_tot(length(unique_BED),days)./mtrx_tot(length(unique_BED),1) - mtrx_tot(:,days)./mtrx_tot(:,1) + 1 - mtrx_tot(:,1)./mtrx_tot(length(unique_BED),1), ':o', 'LineWidth',2, 'DisplayName', ['neutral()/neutral(1)-tot(x)/tot(1) + 1 - tot(1)/neutral(1)']);
legend([num2str(unique_BED(:))]);

ylim([-0.1 1.2]);
title(['CHX=' num2str(chx_f) '  selection']);
xlabel('delta R');
ylabel('loss'); 
end
% CHX 50 

%{
clear
figure;
mtrx_tot = [];
mtrx_blue = [];
days=[1:6];
for d = days
    
day = [num2str(d)]; 
day_1 = '1';
chx_f = 50; 

% load that day and plot
[unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std] = new_analysis_load(day, chx_f)

[unique_BED_d1, mean_tot_d1, mean_blue_d1, all_BED_d1, tot_d1, blue_d1, tot_std_d1, blue_std_d1] = new_analysis_load(day_1, chx_f)

% plot normalized to day 1, means; 
dd = d*ones(size(mean_tot));
mtrx_tot = [mtrx_tot mean_tot];
mtrx_blue = [mtrx_blue mean_blue]; 

end



plot(unique_BED(:), mtrx_tot(:,6)./mtrx_tot(:,1), '-d', 'LineWidth', 2, 'DisplayName', ['tot(6)/tot(1)']);
hold on
plot(unique_BED(:), mtrx_blue(:,6)./mtrx_tot(:,6), 'o', 'LineWidth',2, 'DisplayName', ['blue(6)/tot(6)']);
line([0,10],[mtrx_tot(length(unique_BED),6)/mtrx_tot(length(unique_BED),1) , mtrx_tot(length(unique_BED),6)/mtrx_tot(length(unique_BED),1)], 'DisplayName', ['neutral tot(6)/neutral tot(1)'])        
plot(unique_BED(:), mtrx_tot(:,1)./mtrx_tot(length(unique_BED),1), 'd', 'LineWidth',2, 'DisplayName', ['tot(1)/neutral(1)']);
        
ylim([-0.1 1])
title(['CHX=' num2str(chx_f) '  day' num2str(day)]);
xlabel('BED');
ylabel('Ratios'); 
legend

% CHX 100
clear
figure;
mtrx_tot = [];
mtrx_blue = [];
days=[1:6];
for d = days
    
day = [num2str(d)]; 
day_1 = '1';
chx_f = 100; 

% load that day and plot
[unique_BED, mean_tot, mean_blue, all_BED, tot, blue, tot_std, blue_std] = new_analysis_load(day, chx_f)

[unique_BED_d1, mean_tot_d1, mean_blue_d1, all_BED_d1, tot_d1, blue_d1, tot_std_d1, blue_std_d1] = new_analysis_load(day_1, chx_f)

% plot normalized to day 1, means; 
dd = d*ones(size(mean_tot));
mtrx_tot = [mtrx_tot mean_tot];
mtrx_blue = [mtrx_blue mean_blue]; 

end



plot(unique_BED(:), mtrx_tot(:,6)./mtrx_tot(:,1), '-d', 'LineWidth', 2, 'DisplayName', ['tot(6)/tot(1)']);
hold on
plot(unique_BED(:), mtrx_blue(:,6)./mtrx_tot(:,6), ':o', 'LineWidth',2, 'DisplayName', ['blue(6)/tot(6)']);
line([0,10],[mtrx_tot(length(unique_BED),6)/mtrx_tot(length(unique_BED),1) , mtrx_tot(length(unique_BED),6)/mtrx_tot(length(unique_BED),1)], 'DisplayName', ['neutral tot(6)/neutral tot(1)'])            
plot(unique_BED(:), mtrx_tot(:,1)./mtrx_tot(length(unique_BED),1), 'd', 'LineWidth',2, 'DisplayName', ['tot(1)/neutral(1)']);
        
ylim([-0.1 1])
title(['CHX=' num2str(chx_f) '  day' num2str(day)]);
xlabel('BED');
ylabel('Ratios'); 
legend

%}
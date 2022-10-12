clc 
clear 
close all

load('data_day_1.mat', 'Colony'); 
Col_1 = Colony; 
load('JK_data_day_1.mat', 'Colony'); 
Col_1 = [Col_1 Colony]; 
load('data_day_2.mat', 'Colony'); 
Col_2 = Colony; 
load('JK_data_day_2.mat', 'Colony'); 
Col_2 = [Col_2 Colony]; 
load('data_day_3.mat', 'Colony'); 
Col_3 = Colony;
load('JK_data_day_3.mat', 'Colony'); 
Col_3 = [Col_3 Colony]; 
load('data_day_4.mat', 'Colony'); 
Col_4 = Colony; 
load('JK_data_day_4.mat', 'Colony'); 
Col_4 = [Col_4 Colony]; 
load('data_day_5.mat', 'Colony'); 
Col_5 = Colony; 
load('JK_data_day_5.mat', 'Colony'); 
Col_5 = [Col_5 Colony]; 
load('data_day_6.mat', 'Colony'); 
Col_6 = Colony;
load('JK_data_day_6.mat', 'Colony'); 
Col_6 = [Col_6 Colony]; 
col = [Col_1; Col_2; Col_3; Col_4; Col_5; Col_6];

S = size(col);

% day 6 data 

%initialize BEDS 
BED_0 = [];
count_CHX_0 = [];
BED_25 = [];
count_CHX_25 = [];
BED_50 = [];
count_CHX_50 = [];
BED_100 = [];
count_CHX_100 = [];
for j =1:1:S(2)
  
         if isempty(strfind(col(6,j).name,'yJK26c')) == false
            col(6,j).metadata.BED = 10;  
         end
        
         %get different_condition_vectors 
         if col(6,j).metadata.CHX == 0 
             BED_0 = [BED_0 col(6,j).metadata.BED];
             count_CHX_0 = [count_CHX_0 col(6,j).count_total];
         end
         if col(6,j).metadata.CHX == 25
             BED_25 = [BED_25 col(6,j).metadata.BED];
             count_CHX_25 = [count_CHX_25 col(6,j).count_total];
         end
         if col(6,j).metadata.CHX == 50 
             BED_50 = [BED_50 col(6,j).metadata.BED];
             count_CHX_50 = [count_CHX_50 col(6,j).count_total];
         end
         if col(6,j).metadata.CHX == 100 
             BED_100 = [BED_100 col(6,j).metadata.BED];
             count_CHX_100 = [count_CHX_100 col(6,j).count_total];
         end
     
    
end
%scatter(BED_0, count_CHX_0, 'b','filled')
hold on 
% Unique x's and their locations
[ux_BED_0,~,idx] = unique(BED_0);
% Accumulate 
ymean_CHX_0 = accumarray(idx,count_CHX_0,[],@mean);
scatter(ux_BED_0, ymean_CHX_0,50,'b', 'filled')
hold on
%scatter(BED_25, count_CHX_25, 'r', 'filled')
hold on 
% Unique x's and their locations
[ux_BED_25,~,idx] = unique(BED_25);
% Accumulate 
ymean_CHX_25 = accumarray(idx,count_CHX_25,[],@mean);
scatter(ux_BED_25, ymean_CHX_25, 50, 'r', 'filled')
hold on
scatter(BED_50, count_CHX_50, 'o','filled')
hold on 
% Unique x's and their locations
[ux_BED_50,~,idx] = unique(BED_50);
% Accumulate 
ymean_CHX_50 = accumarray(idx,count_CHX_50,[],@mean);
scatter(ux_BED_50, ymean_CHX_50, 50, 'o', 'filled')
hold on
%scatter(BED_100, count_CHX_100, 'k','filled')
% Unique x's and their locations
[ux_BED_100,~,idx] = unique(BED_100);
% Accumulate 
ymean_CHX_100 = accumarray(idx,count_CHX_100,[],@mean);
scatter(ux_BED_100, ymean_CHX_100, 50, 'k', 'filled')
hold on
title('counts (average over 6 colonies) against BED, 10 is inf')
legend('CHX 0', 'CHX 25', 'CHX 50', 'CHX 100', 'Location', 'SouthEast')


%now same with CHX 
figure 
CHX_0 = [];
count_BED_0 = [];
CHX_05 = [];
count_BED_05 = [];
CHX_1 = [];
count_BED_1 = [];
CHX_1_5 = [];
count_BED_1_5 = [];
CHX_2 = [];
count_BED_2 = [];
CHX_4 = [];
count_BED_4 = [];
CHX_10 = [];
count_BED_10 = [];
for j =1:1:S(2)
  
         if isempty(strfind(col(6,j).name,'yJK26c')) == false
            col(6,j).metadata.BED = 10;  
         end
        
         %get different_condition_vectors 
         if col(6,j).metadata.BED == 0 
             CHX_0 = [CHX_0 col(6,j).metadata.CHX];
             count_BED_0 = [count_BED_0 col(6,j).count_total];
         end
         if col(6,j).metadata.BED == 0.5 
             CHX_05 = [CHX_05 col(6,j).metadata.CHX];
             count_BED_05 = [count_BED_05 col(6,j).count_total];
         end
         if col(6,j).metadata.BED == 1 
             CHX_1 = [CHX_1 col(6,j).metadata.CHX];
             count_BED_1 = [count_BED_1 col(6,j).count_total];
         end
         if col(6,j).metadata.BED == 1.5 
             CHX_1_5 = [CHX_1_5 col(6,j).metadata.CHX];
             count_BED_1_5 = [count_BED_1_5 col(6,j).count_total];
         end
         if col(6,j).metadata.BED == 2 
             CHX_2 = [CHX_2 col(6,j).metadata.CHX];
             count_BED_2 = [count_BED_2 col(6,j).count_total];
         end
         if col(6,j).metadata.BED == 4 
             CHX_4 = [CHX_4 col(6,j).metadata.CHX];
             count_BED_4 = [count_BED_4 col(6,j).count_total];
         end
         if col(6,j).metadata.BED == 10 
             CHX_10 = [CHX_10 col(6,j).metadata.CHX];
             count_BED_10 = [count_BED_10 col(6,j).count_total];
         end
     
    
end
%scatter(CHX_0, count_BED_0, 'filled')
hold on 
% Unique x's and their locations
[ux_CHX_0,~,idx] = unique(CHX_0);
% Accumulate 
ymean_BED_0 = accumarray(idx,count_BED_0,[],@mean);
scatter(ux_CHX_0, ymean_BED_0,50, 'filled')
hold on

%scatter(CHX_05, count_BED_05, 'filled')
[ux_CHX_05,~,idx] = unique(CHX_05);
% Accumulate 
ymean_BED_05 = accumarray(idx,count_BED_05,[],@mean);
scatter(ux_CHX_05, ymean_BED_05,50, 'filled')
hold on

%scatter(CHX_1, count_BED_1, 'filled')
[ux_CHX_1,~,idx] = unique(CHX_1);
% Accumulate 
ymean_BED_1 = accumarray(idx,count_BED_1,[],@mean);
scatter(ux_CHX_1, ymean_BED_1,50, 'filled')
hold on

%scatter(CHX_1_5, count_BED_1_5, 'filled')
[ux_CHX_1_5,~,idx] = unique(CHX_1_5);
% Accumulate 
ymean_BED_1_5 = accumarray(idx,count_BED_1_5,[],@mean);
scatter(ux_CHX_1_5, ymean_BED_1_5,50, 'filled')
hold on

%scatter(CHX_2, count_BED_2, 'filled')
[ux_CHX_2,~,idx] = unique(CHX_2);
% Accumulate 
ymean_BED_2 = accumarray(idx,count_BED_2,[],@mean);
scatter(ux_CHX_2, ymean_BED_2,50, 'filled')
hold on

%scatter(CHX_4, count_BED_4, 'filled')
[ux_CHX_4,~,idx] = unique(CHX_4);
% Accumulate 
ymean_BED_4 = accumarray(idx,count_BED_4,[],@mean);
scatter(ux_CHX_4, ymean_BED_4,50, 'filled')
hold on

%scatter(CHX_10, count_BED_10, 'filled')
[ux_CHX_10,~,idx] = unique(CHX_10);
% Accumulate 
ymean_BED_10 = accumarray(idx,count_BED_10,[],@mean);
scatter(ux_CHX_10, ymean_BED_10,50, 'filled')
hold on
title('counts (average over 6 colonies) against CHX, colors BED')
legend('BED 0', 'BED 0.5', 'BED 1', 'BED 1.5', 'BED 2', 'BED 4', 'inf', 'Location', 'SouthWest')


figure 
%day dependency 
X = [];
Y = [];
Z = [];
CHX = [];
for j =1:1:S(2)
    for i =1:1:S(1) 
    X = [X col(i,j).metadata.day]; 
    Y = [Y col(i,j).metadata.CHX+Col_1(j).metadata.BED]; 
    CHX = [CHX col(i,j).metadata.CHX];
    Z = [Z col(i,j).count_total]; 
    end
end
%Colormap is defined as a 3 column matrix, each row being an RGB triplet
map = zeros(numel(Y),3);
map(:,1)=Y./max(Y);
map(:,2)=Y./max(Y);
map(:,3)=Y./max(Y);
%Set the current Colormap

scatter(X,Z,30,map,'filled')

colormap(map);
%Display Colorbar
colorbar
title('counts against time, colorbar -> condition')
 

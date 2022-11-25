clc 
clear 
close all

% load data files saved with Multifile_analysis
% save them to new variables for each day.
load('data_day_1.mat', 'Colony'); 
Col_1 = Colony; 

load('data_day_2.mat', 'Colony'); 
Col_2 = Colony; 

load('data_day_3.mat', 'Colony'); 
Col_3 = Colony;

load('data_day_4.mat', 'Colony'); 
Col_4 = Colony; 

load('data_day_5.mat', 'Colony'); 
Col_5 = Colony; 

load('data_day_6.mat', 'Colony'); 
Col_6 = Colony; 


%Now go through each colony in the structure fo each day  
for j =10:1:20%length(Col_1) 
    figure(j)
% X is a day
X = ones([max(Col_1(j).streaks.label) 1]);
X = X.';
X0 = 0*X;
Color = [];
%calculate central angular coordinate of the streak
day_1_angle = (Col_1(j).streaks.angle_start + Col_1(j).streaks.angle_stop)/2;

Z = day_1_angle.';
%get the color of the streak from the Colony.streaks data 
for i=1:1:max(Col_1(j).streaks.label) 
   if Col_1(j).streaks.color(i,:) == 'r ' 
       Color = [Color, 'r'];
   elseif Col_1(j).streaks.color(i,:) == 'b' 
       Color = [Color, 'b'];
   end    
end
for i= 1:1:length(X)

%plot the angles against days as lines of the sector color
plot([X0(i) X(i)], [Z(i) Z(i)], Color(i), 'LineWidth', 2.0)
hold on
end

% do the same for each day :D  -> because of very high dimensionality of
% the data decided to do it stupid way and did not create an array for
% different days, so it is just copy pasted code here 
X = ones([max(Col_2(j).streaks.label) 1]);
X = X.';
X0 = X;
X = 2*X;
Color = [];
day_2_angle = (Col_2(j).streaks.angle_start + Col_2(j).streaks.angle_stop)/2;

for i=1:1:max(Col_2(j).streaks.label) 
   if Col_2(j).streaks.color(i,:) == 'r' 
       Color = [Color, 'r'];
   elseif Col_2(j).streaks.color(i,:) == 'b' 
       Color = [Color, 'b'];
   end    
end
Z = day_2_angle.';
for i= 1:1:length(X)
%plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
plot([X0(i) X(i)], [Z(i) Z(i)], Color(i), 'LineWidth', 2.0)
hold on
end




X = ones([max(Col_3(j).streaks.label) 1]);
X = X.';
X0 = 2*X;
X = 3*X;
Color = [];
day_3_angle = (Col_3(j).streaks.angle_start + Col_3(j).streaks.angle_stop)/2;

for i=1:1:length(Col_3(j).streaks.label) 
   if Col_3(j).streaks.color(i,:) == 'r' 
       Color = [Color, 'r'];
   elseif Col_3(j).streaks.color(i,:) == 'b' 
       Color = [Color, 'b'];
   end    
end
Z = day_3_angle.';
for i= 1:1:length(X)
%plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
plot([X0(i) X(i)], [Z(i) Z(i)], Color(i), 'LineWidth', 2.0)
hold on
end



X = ones([max(Col_4(j).streaks.label) 1]);
X = X.';
X0 = 3*X;
X = 4*X;
Color = [];
day_4_angle = (Col_4(j).streaks.angle_start + Col_4(j).streaks.angle_stop)/2;

for i=1:1:length(Col_4(j).streaks.label) 
   if Col_4(j).streaks.color(i,:) == 'r' 
       Color = [Color, 'r'];
   elseif Col_4(j).streaks.color(i,:) == 'b' 
       Color = [Color, 'b'];
   end    
end
Z = day_4_angle.';
for i= 1:1:length(X)
%plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
plot([X0(i) X(i)], [Z(i) Z(i)], Color(i), 'LineWidth', 2.0)
hold on
end




X = ones([max(Col_5(j).streaks.label) 1]);
X = X.';
X0 = 4*X;
X = 5*X;
Color = [];
day_5_angle = (Col_5(j).streaks.angle_start + Col_5(j).streaks.angle_stop)/2;

for i=1:1:length(Col_5(j).streaks.label) 
   if Col_5(j).streaks.color(i,:) == 'r' 
       Color = [Color, 'r'];
   elseif Col_5(j).streaks.color(i,:) == 'b' 
       Color = [Color, 'b'];
   end    
end
Z = day_5_angle.';
for i= 1:1:length(X)
%plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
plot([X0(i) X(i)], [Z(i) Z(i)], Color(i), 'LineWidth', 2.0)
hold on
end



X = ones([max(Col_6(j).streaks.label) 1]);
X = X.';
X0 = 5*X;
X = 6*X;
Color = [];
day_6_angle = (Col_6(j).streaks.angle_start + Col_6(j).streaks.angle_stop)/2;

for i=1:1:length(Col_6(j).streaks.label) 
   if Col_6(j).streaks.color(i,:) == 'r' 
       Color = [Color, 'r'];
   elseif Col_6(j).streaks.color(i,:) == 'b' 
       Color = [Color, 'b'];
   end    
end
Z = day_6_angle.';
for i= 1:1:length(X)
%plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
plot([X0(i) X(i)], [Z(i) Z(i)], Color(i), 'LineWidth', 2.0)
hold on
title(Col_6(j).name);
end



end
hold off
cd images
% here I load the images with the same name as the first colony and plot
% them in one figure for visualization, for now only the first colony. plot
% is not that good
for k = 10:1:20
Im1 = imread(Col_1(k).name);
Im2 = imread(Col_2(k).name);
Im3 = imread(Col_3(k).name);
Im4 = imread(Col_4(k).name);
Im5 = imread(Col_5(k).name);
Im6 = imread(Col_6(k).name);
figure(100+k);

subplot(2,3,1); 
imshow(Im1); 
zoom(2.5);
subplot(2,3,2); 
imshow(Im2);
zoom(2.2);
subplot(2,3,3); 
imshow(Im3);
zoom(2);
subplot(2,3,4); 
imshow(Im4);
zoom(1.9)
subplot(2,3,5); 
imshow(Im5);
zoom(1.7);
subplot(2,3,6); 
imshow(Im6); 
zoom(1.5);
end
cd C:\Users\saif\Desktop\Serhii\Evolutionary_rescue\Git\matlab
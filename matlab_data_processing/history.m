clc 
clear 
close all
col = [];

% Load data 
% and remove plate A from the data (treatment at day 5) 
for day_to_look = 1:9

load(['data_day_' num2str(day_to_look) '.mat'],'Colony');
if day_to_look < 6 
    indices_to_keep = [7:12 19:24 31:48 55:72 79:96] 
    col = [col; Colony(indices_to_keep)]
else 

col = [col; Colony]
end
end
S = size(col);

% main tracking 
for j = 63
    counts = [];
    % initialize width and color matrices for visualization
    widthMatrix = zeros (9, max(col(1,j).streaks.label)); 
    colorMatrix = char(zeros(9, max(col(1,j).streaks.label))); 
    cmsize = size(colorMatrix); 
    % Color matrix is char, so have to initialize it with some color first
    for qq = 1:1:cmsize(1)
        for qqq = 1:1:cmsize(2)
            colorMatrix(qq,qqq) = 'k';
        end
    end
    
% Calculate the angular position of center of the streak    
for i = 1:1:S(1) 
    counts = [counts col(i,j).count_total];
    col(i,j).mean_angle = (col(i,j).streaks.angle_start + col(i,j).streaks.angle_stop)/2;
end
% keep angle data for day 1 with max streaks 
angle_max = col(1,j).mean_angle;
fig = figure(j)

for n = 1:1:S(1)
% set colors and X positions
X = ones([max(col(n,j).streaks.label) 1]);
X1 = n*X.';
X0 = (n-1)*X;
Color = [];
for k=1:1:max(col(n,j).streaks.label) 
   Color = [Color, col(n,j).streaks.color(k,:)] ;
end

% calculate width in microns  = angle * Radius 
angle_this = col(n,j).mean_angle;
this_angle_start = col(n,j).streaks.angle_start; 
this_angle_end = col(n,j).streaks.angle_stop; 
this_width = abs(this_angle_start - this_angle_end)*col(n,j).radius_microns; 
if n~=1
    angle_before = col(n-1,j).mean_angle;
end

% labeling code by nearest neighbor starts here 
label = [];
if n~=1
    % if at some day there are more streaks that at day before (error by
    % counting) (this must not occure, but to keep it safe) compare with
    % the positions at day 1 
    if n>1 & length(angle_this)>=length(angle_before)
for i = 1:1:col(n,j).count_total 
    
    diff = abs(angle_max - angle_this(i)); 
    M = min(diff);
    idx = find ( diff == M); 
    idx = idx(1);
    while find(label==col(1,j).streaks.label(idx))
        diff(idx) = 10;
        M = min(diff);
        idx = find( diff ==M);
        idx = idx(1);
    end
    label = [label col(1,j).streaks.label(idx)];
    col(n,j).streaks.label(i) = col(1,j).streaks.label(idx); 
    
end
% compare the angles of day X with day X-1
    elseif n>1 & length(angle_this)<length(angle_before)
        for i = 1:1:col(n,j).count_total 
   
    diff = abs(angle_before - angle_this(i)); 
    M = min(diff);
    idx = find ( diff == M); 
    idx = idx(1);
    while find(label==col(n-1,j).streaks.label(idx))
        diff(idx) = 10;
        M = min(diff);
        idx = find( diff ==M);
        idx = idx(1);
    end
    g = col(n-1,j).streaks.label(idx);
    label = [label g];
    col(n,j).streaks.label(i) = col(n-1,j).streaks.label(idx); 
    
        end
    end
end
Y = col(n,j).streaks.label;
Y = Y.' ;
Z = angle_this.';
width = this_width.';

% width matrix sorted by labels

for k = 1:1:length(Y)
   widthMatrix(n, Y(k)) = width(k);
   
   colorMatrix(n, Y(k)) = Color(1,k); 
end


    subplot(1,2,1)
for i= 1:1:length(X)
   
    plot([X0(i) X1(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 0.01*width(i))
    hold on
    
end

    subplot(1,2,2)
for i= 1:1:length(X)
   
    plot([X0(i) X1(i)], [Z(i) Z(i)], Color(i), 'LineWidth', 0.01*width(i))
    hold on
    
end


end

figure;
for d = 1:8
    for streak = 1:1:length(widthMatrix)
plot([d:d+1],widthMatrix(d:d+1,streak), 'Color', colorMatrix(d,streak))
hold on 
    end
end
end


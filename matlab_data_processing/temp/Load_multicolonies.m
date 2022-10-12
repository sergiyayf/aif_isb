clc 
clear 
close all

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
col = [Col_1; Col_2; Col_3; Col_4; Col_5];

S = size(col);
%set streak counter to 0
streak_counter = 0; 
all_streaks = 0; 
%initialize array for streack switch at day 
switched_at_day = []; 
%cd images\history
for j = 1:1:S(2)
    counts = [];
for i = 1:1:S(1) 
    counts = [counts col(i,j).count_total];
    col(i,j).mean_angle = (col(i,j).streaks.angle_start + col(i,j).streaks.angle_stop)/2;
end
day_with_max_colonies = find(counts==max(counts));
angle_max = col(day_with_max_colonies,j).mean_angle;
fig = figure(j)

for n = 1:1:S(1)
% set colors and X positions
X = ones([max(col(n,j).streaks.label) 1]);
X1 = n*X.';
X0 = (n-1)*X;
Color = [];
for k=1:1:max(col(n,j).streaks.label) 
   if col(n,j).streaks.color(k,:) == 'red ' 
       Color = [Color, 'r'];
   elseif col(n,j).streaks.color(k,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color;
% angle stuff here 
angle_this = col(n,j).mean_angle;
if n~=1
    angle_before = col(n-1,j).mean_angle;
end

label = [];
if n~=day_with_max_colonies
    if n>1 & length(angle_this)>=length(angle_before)
for i = 1:1:col(n,j).count_total 
   
    diff = abs(angle_max - angle_this(i)); 
    M = min(diff);
    idx = find ( diff == M); 
    idx = idx(1);
    while find(label==col(day_with_max_colonies,j).streaks.label(idx))
        diff(idx) = 10;
        M = min(diff);
        idx = find( diff ==M);
        idx = idx(1);
    end
    label = [label col(day_with_max_colonies,j).streaks.label(idx)];
    col(n,j).streaks.label(i) = col(day_with_max_colonies,j).streaks.label(idx); 
    
end
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
%{
    subplot(1,2,1)
for i= 1:1:length(X)
   
    plot([X0(i) X1(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
    hold on
    
end

    subplot(1,2,2)
for i= 1:1:length(X)
   
    plot([X0(i) X1(i)], [Z(i) Z(i)], Color(i), 'LineWidth', 2.0)
    hold on
    
end
%}
end


% for each streak starting at day 6 
all_streaks = all_streaks + col(5,j).count_total;
for q = 1:1:col(5,j).count_total
    %check color of this colony streak
    % if read then assigned day when switched to 0
    %col(6,j).streaks.color(q)
    
    if col(5,j).streaks.color(q) == 'r'
        %if initialy red -> set switched day to 0
        day_switched = 0;
        switched_at_day = [switched_at_day day_switched];
        streak_counter = streak_counter+1; 
    % if blue look at previous days
    elseif col(5,j).streaks.color(q) == 'b'
        % find the label of this streak 
        
        label_of_this_streak = col(5,j).streaks.label(q);
        for u = 5:-1:1
            % find the same label at previous day
            k = find(col(u,j).streaks.label == label_of_this_streak);
            
            if isempty(k) & u == 1 
                % if empty till the very beginning -> set da_switched to 6
                day_switched = 6;
                switched_at_day = [switched_at_day day_switched];
                streak_counter = streak_counter+1;
            elseif col(u,j).streaks.color(k) == 'b' & u == 1 
                % if blue till the beginning -> set day switched to 1 
                day_switched = 1;
                switched_at_day = [switched_at_day day_switched];
                streak_counter = streak_counter+1;
            elseif col(u,j).streaks.color(k) == 'r'
                % if changed to red -> set day switched to day_when_red +1 
                day_switched = u+1;
                switched_at_day = [switched_at_day day_switched];
                streak_counter = streak_counter+1;
                break
            end
                       
        end
    end
    
end
%here ended code for calculating when switched 
fname = [num2str(j),'.png'];
%saveas(fig, fname);
close all
end
cd C:\Users\saif\Desktop\Serhii\Evolutionary_rescue\Git\matlab
did_not_switch_but_made_it = length(find(switched_at_day == 0 ))
switched_at_day_2 = length(find(switched_at_day == 2 ))
switched_at_day_3 = length(find(switched_at_day == 3 ))
switched_at_day_4 = length(find(switched_at_day == 4 ))
switched_at_day_5 = length(find(switched_at_day == 5 ))
switched_at_day_6 = length(find(switched_at_day == 6 ))

num_survived = [switched_at_day_2 switched_at_day_3 switched_at_day_4 switched_at_day_5 switched_at_day_6]; 
days = [2 3 4 5 6]; 
figure 
bar(days, num_survived)

%for i = 1:1:size(col(1))
%Now process here: 
%{
for j =1:1:length(Col_1) 
    
    figure(j)
Y = Col_1(j).streaks.label;
Y = Y.' ;
X = ones([max(Col_1(j).streaks.label) 1]);
X = X.';
X0 = 0*X;
Color = [];
for i=1:1:max(Col_1(j).streaks.label) 
   if Col_1(j).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_1(j).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end
day_1_angle = (Col_1(j).streaks.angle_start + Col_1(j).streaks.angle_stop)/2;


X = ones([max(Col_2(j).streaks.label) 1]);
X = X.';
X0 = X;
X = 2*X;
Color = [];
day_2_angle = (Col_2(j).streaks.angle_start + Col_2(j).streaks.angle_stop)/2;

for i = 1:1:length(day_2_angle) 
    diff = abs(day_1_angle - day_2_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.0
        Col_2(j).streaks.label(i) = Col_1(j).streaks.label(idx); 
    end 
end

Y = Col_2(j).streaks.label;
Y = Y.' ;
for i=1:1:max(Col_2(j).streaks.label) 
   if Col_2(j).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_2(j).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end

for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end




X = ones([max(Col_3(j).streaks.label) 1]);
X = X.';
X0 = 2*X;
X = 3*X;
Color = [];
day_3_angle = (Col_3(j).streaks.angle_start + Col_3(j).streaks.angle_stop)/2;

for i = 1:1:length(day_3_angle) 
    diff = abs(day_2_angle - day_3_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.01
        Col_3(j).streaks.label(i) = Col_2(j).streaks.label(idx); 
    end 
end
Y = Col_3(j).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_3(j).streaks.label) 
   if Col_3(j).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_3(j).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end



X = ones([max(Col_4(j).streaks.label) 1]);
X = X.';
X0 = 3*X;
X = 4*X;
Color = [];
day_4_angle = (Col_4(j).streaks.angle_start + Col_4(j).streaks.angle_stop)/2;

for i = 1:1:length(day_4_angle) 
    diff = abs(day_3_angle - day_4_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.01
        Col_4(j).streaks.label(i) = Col_3(j).streaks.label(idx); 
    end 
end
Y = Col_4(j).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_4(j).streaks.label) 
   if Col_4(j).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_4(j).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end




X = ones([max(Col_5(j).streaks.label) 1]);
X = X.';
X0 = 4*X;
X = 5*X;
Color = [];
day_5_angle = (Col_5(j).streaks.angle_start + Col_5(j).streaks.angle_stop)/2;

for i = 1:1:length(day_5_angle) 
    diff = abs(day_4_angle - day_5_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.01
        Col_5(j).streaks.label(i) = Col_4(j).streaks.label(idx(1));
    end 
end
Y = Col_5(j).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_5(j).streaks.label) 
   if Col_5(j).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_5(j).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end



X = ones([max(Col_6(j).streaks.label) 1]);
X = X.';
X0 = 5*X;
X = 6*X;
Color = [];
day_6_angle = (Col_6(j).streaks.angle_start + Col_6(j).streaks.angle_stop)/2;

for i = 1:1:length(day_6_angle) 
    diff = abs(day_5_angle - day_6_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.01
        Col_6(j).streaks.label(i) = Col_5(j).streaks.label(idx);
    end 
end
Y = Col_6(j).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_6(j).streaks.label) 
   if Col_6(j).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_6(j).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end


end
%}
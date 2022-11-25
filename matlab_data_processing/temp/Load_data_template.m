% This is a draft of the data loading script, and it is actually trash now

clc 
clear 
close all

load('struct_colony_day_1.mat', 'Colony'); 
Col_1 = Colony; 

load('struct_colony_day_2.mat', 'Colony'); 
Col_2 = Colony; 

load('struct_colony_day_3.mat', 'Colony'); 
Col_3 = Colony;

load('struct_colony_day_4.mat', 'Colony'); 
Col_4 = Colony; 

load('struct_colony_day_5.mat', 'Colony'); 
Col_5 = Colony; 

load('struct_colony_day_6.mat', 'Colony'); 
Col_6 = Colony; 

load('struct_colony_day_7.mat', 'Colony'); 
Col_7 = Colony; 


%Now process here: 

Y = Col_1(1).streaks.label;
Y = Y.' ;
X = ones([max(Col_1(1).streaks.label) 1]);
X = X.';
X0 = 0*X;
Color = [];
for i=1:1:max(Col_1(1).streaks.label) 
   if Col_1(1).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_1(1).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end
day_1_angle = (Col_1(1).streaks.angle_start + Col_1(1).streaks.angle_stop)/2;

Y = Col_2(1).streaks.label;
Y = Y.' ;
X = ones([max(Col_2(1).streaks.label) 1]);
X = X.';
X0 = X;
X = 2*X;
Color = [];
day_2_angle = (Col_2(1).streaks.angle_start + Col_2(1).streaks.angle_stop)/2;

for i=1:1:max(Col_2(1).streaks.label) 
   if Col_2(1).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_2(1).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end

for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end




X = ones([max(Col_3(1).streaks.label) 1]);
X = X.';
X0 = 2*X;
X = 3*X;
Color = [];
day_3_angle = (Col_3(1).streaks.angle_start + Col_3(1).streaks.angle_stop)/2;

for i = 1:1:length(day_3_angle) 
    diff = abs(day_2_angle - day_3_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.1
        Col_3(1).streaks.label(i) = Col_2(1).streaks.label(idx); 
    end 
end
Y = Col_3(1).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_3(1).streaks.label) 
   if Col_3(1).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_3(1).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end



X = ones([max(Col_4(1).streaks.label) 1]);
X = X.';
X0 = 3*X;
X = 4*X;
Color = [];
day_4_angle = (Col_4(1).streaks.angle_start + Col_4(1).streaks.angle_stop)/2;

for i = 1:1:length(day_4_angle) 
    diff = abs(day_3_angle - day_4_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.1
        Col_4(1).streaks.label(i) = Col_3(1).streaks.label(idx); 
    end 
end
Y = Col_4(1).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_4(1).streaks.label) 
   if Col_4(1).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_4(1).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end




X = ones([max(Col_5(1).streaks.label) 1]);
X = X.';
X0 = 4*X;
X = 5*X;
Color = [];
day_5_angle = (Col_5(1).streaks.angle_start + Col_5(1).streaks.angle_stop)/2;

for i = 1:1:length(day_5_angle) 
    diff = abs(day_4_angle - day_5_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.1
        Col_5(1).streaks.label(i) = Col_4(1).streaks.label(idx);
    end 
end
Y = Col_5(1).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_5(1).streaks.label) 
   if Col_5(1).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_5(1).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end



X = ones([max(Col_6(1).streaks.label) 1]);
X = X.';
X0 = 5*X;
X = 6*X;
Color = [];
day_6_angle = (Col_6(1).streaks.angle_start + Col_6(1).streaks.angle_stop)/2;

for i = 1:1:length(day_6_angle) 
    diff = abs(day_5_angle - day_6_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.05
        Col_6(1).streaks.label(i) = Col_5(1).streaks.label(idx);
    end 
end
Y = Col_6(1).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_6(1).streaks.label) 
   if Col_6(1).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_6(1).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end



X = ones([max(Col_7(1).streaks.label) 1]);
X = X.';
X0 = 6*X;
X = 7*X;
Color = [];
day_7_angle = (Col_7(1).streaks.angle_start + Col_7(1).streaks.angle_stop)/2;

for i = 1:1:length(day_7_angle) 
    diff = abs(day_6_angle - day_7_angle(i)); 
    M = min(diff)
    idx = find ( diff == M); 
    if M < 0.05
        Col_7(1).streaks.label(i) = Col_6(1).streaks.label(idx);
    end 
end
Y = Col_7(1).streaks.label;
Y = Y.' ;
for i=1:1:length(Col_7(1).streaks.label) 
   if Col_7(1).streaks.color(i,:) == 'red ' 
       Color = [Color, 'r'];
   elseif Col_7(1).streaks.color(i,:) == 'blue' 
       Color = [Color, 'b'];
   end    
end
Color
for i= 1:1:length(X)
plot([X0(i) X(i)], [Y(i) Y(i)], Color(i), 'LineWidth', 2.0)
hold on
end


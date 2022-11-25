clc 
clear 
close all

[filename, directory] = uigetfile(['D:\Serhii\Projects\EarlyLate_experiments\day4\Segmentaion\*'], 'Select one segmented tiff file', 'MultiSelect','off');  %open the file to process by choosing it

A = imread(fullfile(directory, filename)); % read image that is segmented in Ilastic

numlabels = max(A(:)); % maximum number of labels 
if numlabels >= 7 
    disp("number of labels is larger then used color map");
end

%prefered colors to be used with ilastik: label 1 - YFP, label 2 - CFP, label 3 - RFP, label 4 - background, label 5 - edge
map = [1 1 0 %-yellow
    0 1 1 %-cyan
    1 0 0 %-red
    0.5 0.5 0 %-dark yelllow
    0 0 0 %-black
    0 0 1 %-blue
    0 1 0]; % creat a color map for nice segment coloring if needed

map1 = [0 0 0.1 %-yellow
    0 0.0 0.11 %-cyan
    0.1 0 0 %-red
    0.99 1 1 %-dark yelllow
    0 0 0 %-black
    0 0 1 %-blue
    0 1 0]; % creat a color map for nice segment coloring if needed
res = label2rgb(A, map); % change labels to colors specified in the color map
res2 = label2rgb(A, map1);
BW = im2bw(res2,0.05);
%figure 
%imshow(res)
[x_size, y_size] = size(A); 

%find coordinates of all different labels 
[col1, row1] = find(A==1);
[col2, row2] = find(A==2);
[col3, row3] = find(A==3);
[col4, row4] = find(A==4);
[col5, row5] = find(A==5);

%find the maximum right and minimum left points of the boundary (black
%label)
[max_x_black, index_max] = max(row5); 
y_pos_max = col5(index_max);

[min_x_black, index_min] = min(row5); 
y_pos_min = col5(index_min);

%find the center of the circle
center_pos_x = (max_x_black+min_x_black)/2;
center_pos_y = (y_pos_max+y_pos_min)/2;
Radius = sqrt( (max_x_black-center_pos_x)^2 + (y_pos_max-center_pos_y)^2);

%plot the circle 
theta = 0:pi/45:2*pi;
x_circle = center_pos_x + Radius*cos(theta);
y_circle = center_pos_y + Radius*sin(theta);

%find the circle by matlab default function, works a bit better because of
%the mushrooms 
%[imfcenter,imfradius] = imfindcircles(res,[600 1000],'ObjectPolarity','bright', ...
%    'Sensitivity',0.995)

%adjust Sensitivity to detect only one circle 

% fit the edge with circles using least squares
[xx0,yy0,RR] = circle_fit(row5,col5); 
c = [xx0,yy0];

%uncomment to visualise the fit 
%{
figure
scatter(row5,col5)
c = [xx0, yy0];
circ = viscircles(c, RR)
%}

%go trough the circle with small angles increments and count the sectors.
%for matlab fit circle use imfcenter and imfradius, for least square fit
%use c and RR
center = c; 
radius = RR;
radius = radius-50;

%
edgeImage = edge(BW);
figure 
imshow(BW)

biggestArea = bwareafilt(BW,1);
%binaryImage = imfill(edgeImage, 'holes');
compl = imcomplement(biggestArea);
outerPerimeter = bwperim(compl);
biggest = outerPerimeter; %bwareafilt(outerPerimeter,1);

[Y_edge X_edge] = find(biggest == 1); 
Y_edge = fix((Y_edge-center(2))*0.975+center(2));
X_edge = fix((X_edge-center(1))*0.975+center(1));

% radial coordinates
   rShape = sqrt( (X_edge-center(1)).^2 +(Y_edge-center(2)).^2 );
   cosAlpha = (X_edge-center(1))./rShape;
   sinAlpha = (Y_edge-center(2))./rShape;
   [cosAlpha, sortidx] = sort(cosAlpha);
   rShape = rShape(sortidx);
   sinAlpha = sinAlpha(sortidx);
  
 [theta, rho] = cart2pol(X_edge-center(1),Y_edge-center(2)); 
 [theta, thetaSortIdx] = sort(theta); 
 rho = rho(thetaSortIdx);
 
figure
imshowpair(BW,outerPerimeter,'montage')
figure
imshowpair(biggest,outerPerimeter,'montage')


figure
imshow(res)
h = viscircles(center,radius);
hold on 

scatter(X_edge, Y_edge, 1)
hold on


%define the starting point, check it to be yellow, to make counting easier
start_angle = theta(1);
stop_angle = theta(end); 
x0 = fix( center(1) + rho(1)*cos(start_angle)) ;
y0 =fix( center(2) + rho(1)*sin(start_angle)) ;

% some code to check if you start with yellow, might create infinite loops if there is no yellow on the circle at all;
while A(y0,x0) ~= 1
    theta = circshift(theta,1);
    rho = circshift(rho,1);
    start_angle = theta(1);
    stop_angle = theta(end);
    x0 = fix( center(1) + rho(1)*cos(start_angle)) ;
    y0 =fix( center(2) + rho(1)*sin(start_angle)) ;
end
label_old = 1; 
% go through whole colony boundary 
segment_label = [];
lbl = 0;
segment_start_alpha = [];
segment_stop_alpha = [];
label_count = 0;
count_red = 0;
count_blue = 0;
count_mixed = 0;
segment_color = [];
segment_size = [];
for i = 1:1:length(theta)
    %round position to the integer to access the value of matrix
    alpha = theta(i); 
    radius = rho(i);
    xx =fix( center(1) + radius*cos(alpha)) ;
    yy =fix( center(2) + radius*sin(alpha)) ;
    label_now = A(yy,xx);
    
    %actual sector counting. 
    if label_now ~= label_old 
        
        if label_now == 2 & (label_old == 1 | label_old == 5 | label_old == 4)  % yellow (or black or dark yellow) -> blue -- added black and dark yellow, for weirdly shaped collonies
                    is_not = is_not_a_sector(A,xx,yy,60);
                    if is_not == false
                    count_blue = count_blue+1;
                    segment_start_alpha = [segment_start_alpha; alpha];
                    segment_color = [segment_color;  ['blue']];
                    text(xx,yy,num2str(count_blue),'Color','b')
                    hold on
                    elseif is_not == true
                        label_now = label_old;
                    end
        elseif (label_now == 1 | label_now == 5 | label_now == 4) & label_old == 2 % blue -> yellow 
                    is_not = is_not_a_sector(A,xx,yy,20);
                    if is_not == false
                    segment_stop_alpha = [segment_stop_alpha; alpha];
                    lbl = lbl+1;
                    segment_label = [segment_label; lbl];
                    
                     elseif is_not == true
                        label_now = label_old;
                    end
        elseif label_now == 3 & (label_old == 1 | label_old == 5 | label_old == 4) % yellow -> red
                    is_not = is_not_a_sector(A,xx,yy,60);
                    if is_not == false
                    count_red = count_red+1;
                    segment_start_alpha = [segment_start_alpha; alpha];
                    segment_color = [segment_color; ['red ']];
                    text(xx,yy,num2str(count_red),'Color','k')
                    hold on
                     elseif is_not == true
                        label_now = label_old;
                    end
        elseif (label_now == 1 | label_now ==5 | label_now == 4) & label_old == 3 % red -> yellow 
                    is_not = is_not_a_sector(A,xx,yy,20);
                    if is_not == false
                    segment_stop_alpha = [segment_stop_alpha; alpha];
                    lbl = lbl+1;
                    segment_label = [segment_label; lbl];
                    
                     elseif is_not == true
                        label_now = label_old;
                    end
       
        else
        end
    end
    label_old=label_now;    
end
segment_size = segment_stop_alpha-segment_start_alpha;

Streaks_matrix = [segment_label segment_start_alpha segment_stop_alpha segment_size];

count_red;
count_blue;
count_mixed = 0;
count_total = count_red+count_blue; 

Colony = get_data(filename, RR, RR, center, Streaks_matrix, segment_color, count_red, count_blue, count_mixed, count_total, red_pixels, blue_pixels, total_pixels);

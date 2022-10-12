%This programm takes segmented images chosen by you manually and saves
%images with visualization which sectors are counted and the data as a
%structure mat file
clc 
clear 
close all

zooms_old = [8 6.3 4.5 4 3.5];
scaling_factors_old = [8.063 10.246 14.333 16.125 18.429];

%choose your segmented files, you can only choose files, no folders
[input_filename, input_directory] = uigetfile(['C:\Users\saif\Desktop\Serhii\Projects\Evolutionary_rescue\Jona_fit_tiffs\Combined\*.tif'], 'Select at least 2 segmented tif files', 'MultiSelect','off');  %open the file to process by choosing it

%choose your segmented files, you can only choose files, no folders. They
%should be segmented with ideally 5 labels 
filename=input_filename;  %open the file to process by choosing it
directory = input_directory;
%check how many files selected
size_of_filename = size(filename);
number_of_selected_files = size_of_filename(2);

%loop through all the files
Save_matrix = [];
%better have the directory images at the same directory where your matlab
%file is, to store the images with counting labels there 



file = char(filename);
dir = char(directory);

%read the file into a matrix
A = imread(fullfile(dir, file));

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
%label) - this was needed for manual circle determination, basically dont
%need that now 
[max_x_black, index_max] = max(row5); 
y_pos_max = col5(index_max);

[min_x_black, index_min] = min(row5); 
y_pos_min = col5(index_min);

%find the center of the circle
center_pos_x = (max_x_black+min_x_black)/2;
center_pos_y = (y_pos_max+y_pos_min)/2;
Radius = sqrt( (max_x_black-center_pos_x)^2 + (y_pos_max-center_pos_y)^2);

%circle data from manualy determined circle 
theta = 0:pi/45:2*pi;
x_circle = center_pos_x + Radius*cos(theta);
y_circle = center_pos_y + Radius*sin(theta);

%find the circle by matlab default function, works a bit better because of
%the mushrooms 
%[imfcenter,imfradius] = imfindcircles(res,[600 1000],'ObjectPolarity','bright', ...
%    'Sensitivity',0.995)

%adjust Sensitivity to detect only one circle 

% fit the edge with circle using least squares
[xx0,yy0,RR] = circle_fit(row5,col5); 
c = [xx0,yy0];

imshow(res)
hold on
 
center = c; 
radius = RR;

%hold on 

[x_s, y_s] = ginput(2); 
h = viscircles(center,radius);
d = sqrt((x_s-xx0).^2+(y_s-yy0).^2);

% find zoom 
 zoom_start = strfind(file, 'zoom');
 start = zoom_start+4;
 stop = zoom_start+6;
 zoom = file(start:stop);
 if zoom(2) == '_'
     zoom(2) = '.';
     zoom = str2num(zoom);
 elseif zoom(2) == ' '
     zoom = zoom(1); 
     zoom = str2num(zoom);
 end

 % rescale distance to microns 
 
 z = zoom; 
      [zm, zm_ind] = find(zooms_old == z);
      d_microns =scaling_factors_old(zm_ind)*d;

 d_microns_1 = d_microns
 %
%
%
%
% choose second image of later day; 
%choose your segmented files, you can only choose files, no folders

figure

[input_filename, input_directory] = uigetfile(['C:\Users\saif\Desktop\Serhii\Projects\Evolutionary_rescue\Jona_fit_tiffs\Combined\*.tif'], 'Select at least 2 segmented tif files', 'MultiSelect','off');  %open the file to process by choosing it

%choose your segmented files, you can only choose files, no folders. They
%should be segmented with ideally 5 labels 
filename=input_filename;  %open the file to process by choosing it
directory = input_directory;
%check how many files selected
size_of_filename = size(filename);
number_of_selected_files = size_of_filename(2);

%loop through all the files
Save_matrix = [];
%better have the directory images at the same directory where your matlab
%file is, to store the images with counting labels there 



file = char(filename);
dir = char(directory);

%read the file into a matrix
A = imread(fullfile(dir, file));

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
%label) - this was needed for manual circle determination, basically dont
%need that now 
[max_x_black, index_max] = max(row5); 
y_pos_max = col5(index_max);

[min_x_black, index_min] = min(row5); 
y_pos_min = col5(index_min);

%find the center of the circle
center_pos_x = (max_x_black+min_x_black)/2;
center_pos_y = (y_pos_max+y_pos_min)/2;
Radius = sqrt( (max_x_black-center_pos_x)^2 + (y_pos_max-center_pos_y)^2);

%circle data from manualy determined circle 
theta = 0:pi/45:2*pi;
x_circle = center_pos_x + Radius*cos(theta);
y_circle = center_pos_y + Radius*sin(theta);

%find the circle by matlab default function, works a bit better because of
%the mushrooms 
%[imfcenter,imfradius] = imfindcircles(res,[600 1000],'ObjectPolarity','bright', ...
%    'Sensitivity',0.995)

%adjust Sensitivity to detect only one circle 

% fit the edge with circle using least squares
[xx0,yy0,RR] = circle_fit(row5,col5); 
c = [xx0,yy0];

imshow(res)
hold on
 
center = c; 
radius = RR;

%hold on 

[x_s, y_s] = ginput(2); 
h = viscircles(center,radius);
d = sqrt((x_s-xx0).^2+(y_s-yy0).^2);



% find zoom 
 zoom_start = strfind(file, 'zoom');
 start = zoom_start+4;
 stop = zoom_start+6;
 zoom = file(start:stop);
 if zoom(2) == '_'
     zoom(2) = '.';
     zoom = str2num(zoom);
 elseif zoom(2) == ' '
     zoom = zoom(1); 
     zoom = str2num(zoom);
 end

 % rescale distance to microns 
 
 z = zoom; 
      [zm, zm_ind] = find(zooms_old == z);
      d_microns =scaling_factors_old(zm_ind)*d;

 d_microns_2 = d_microns 
 
growth = d_microns_2-d_microns_1;
s = (growth(1)/growth(2)-1)*100 
 
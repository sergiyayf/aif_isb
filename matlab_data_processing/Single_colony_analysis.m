%This programm takes segmented images chosen by you manually and saves
%images with visualization which sectors are counted and the data as a
%structure mat file
%Multifile_analysis_function(input_filename, input_directory, Colony_output_directory, Colony_output_name, Image_output_directory)
clc;
clear; 
close all; 

% zoom and scaling factors to get distances in microns instead of pixels 
zms = [20 16.1 12.5 10 8 6.3 5];
scaling_factors = [2.271 2.820 3.632 4.540 5.675 7.212 9.080];
% manually select files to process
[input_filename, input_directory] = uigetfile(['D:\Serhii\Projects\EarlyLate_experiments\day4\Segmentaion\*'], 'Select at least 2 segmented tif files', 'MultiSelect','on');  %open the file to process by choosing it

% store data here: 
Colony_output_directory = 'D:\Serhii\Projects\EarlyLate_experiments\matlab_processed_data\data'; 
Colony_output_name = 'data_day_1.mat'; 
Image_output_directory = 'D:\Serhii\Projects\EarlyLate_experiments\matlab_processed_data\images\day1'; 

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
%cd(Image_output_directory)
for i = 1:1:number_of_selected_files

file = char(filename(i));
dir = char(directory);

%read the image file into a matrix
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
%BW = A;
%BW(A>3) = 1;
%BW(A<4) = 0;
%BW = logical(BW);

BW=im2bw(res2,0.05);
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
radius = RR-15;

% compute radius in microns: 
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
elseif zoom(3) == '_'
    zoom = file(start:stop+1);
    zoom(3) = '.'; 
    zoom = str2num(zoom);
elseif zoom(3) == ' '
    zoom = file(start:stop-1); 
    zoom = str2num(zoom);
end
[zm, zm_ind] = find(zms == zoom);
rad_microns = radius*scaling_factors(zm_ind);

%convert to binary and get single pixeled edge by finding biggest connected
%component and finding its perimeter
edgeImage = edge(BW);
compl = imcomplement(BW);
biggestArea = bwareafilt(compl,1);
%binaryImage = imfill(edgeImage, 'holes');
%compl = imcomplement(biggestArea);
outerPerimeter = bwperim(biggestArea);
biggest = bwareafilt(outerPerimeter,1);

[Y_edge X_edge] = find(biggest == 1); 
Y_edge = fix((Y_edge-center(2))*0.975+center(2));
X_edge = fix((X_edge-center(1))*0.975+center(1));


% convert to radial coordinates 

 [theta, rho] = cart2pol(X_edge-center(1),Y_edge-center(2)); 
 [theta, thetaSortIdx] = sort(theta); 
 rho = rho(thetaSortIdx);
 X_edge = X_edge(thetaSortIdx);
 Y_edge = Y_edge(thetaSortIdx);

fig = figure ;
imshow(res)


%h = viscircles(center,radius);
hold on 
scatter(X_edge, Y_edge, 2);
hold on
%define the starting point, check it to be yellow, to make counting easier

start_angle = theta(1);
 
x0 = fix( center(1) + rho(1)*cos(start_angle)) ;
y0 =fix( center(2) + rho(1)*sin(start_angle)) ;

% some code to check if you start with yellow, might create infinite loops if there is no yellow on the circle at all;
% starting with yellow is needed to have aacurate width of sectors,
% otherwise would have end angle of one sector but start angle of the next
% one. Rotate starting point if starts at red or blue sector 
while A(y0,x0) ~= 1
    theta = circshift(theta,3);
    rho = circshift(rho,3);
    start_angle = theta(3);

    x0 = fix( center(1) + rho(1)*cos(start_angle)) ;
    y0 = fix( center(2) + rho(1)*sin(start_angle)) ;
end
label_old = 1; 
% go through whole colony boundary 
% initialize different arrays for counting and width detection
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

red_pixels = 0;
blue_pixels = 0; 
for b = 1:1:length(theta)
    %round position to the integer to access the value of matrix
    alpha = theta(b); 
    radius = rho(b);
    %round position to the integer to access the value of matrix
    xx = fix( center(1) + radius*cos(alpha)) ;
    yy = fix( center(2) + radius*sin(alpha)) ;
    label_now = A(yy,xx);
    
    %frequency counting 
    if label_now == 3
        red_pixels = red_pixels + 1;
    elseif label_now == 2
        blue_pixels = blue_pixels +1; 
    end
    %actual sector counting. 
    % considering the change from one label to another save starting angle
    % and
    if label_now ~= label_old 
        
        if label_now == 2 & label_old == 1  % yellow  -> blue
                    is_not = is_not_a_sector(A,xx,yy,60);
                    if is_not == false
                    
                    segment_start_alpha = [segment_start_alpha; alpha];
                    streak_color = ['b'];
                    %segment_color = [segment_color;  ['blue']];
                    %text(xx,yy,num2str(count_blue),'Color','b')
                    hold on
                    elseif is_not == true
                        label_now = label_old;
                    end
        elseif label_now == 1 & label_old == 2 % blue -> yellow 
                    is_not = is_not_a_sector(A,xx,yy,20);
                    if is_not == false
                    segment_stop_alpha = [segment_stop_alpha; alpha];
                    lbl = lbl+1;
                    count_blue = count_blue+1;
                    segment_label = [segment_label; lbl];
                    segment_color = [segment_color;  streak_color];
                    text(xx,yy,num2str(count_blue),'Color','b')
                    
                     elseif is_not == true
                        label_now = label_old;
                    end
        elseif label_now == 3 & label_old == 1 % yellow -> red
                    is_not = is_not_a_sector(A,xx,yy,60);
                    if is_not == false
                    
                    segment_start_alpha = [segment_start_alpha; alpha];
                    streak_color = ['r'];
                    %segment_color = [segment_color; ['red ']];
                    %text(xx,yy,num2str(count_red),'Color','k')
                    hold on
                     elseif is_not == true
                        label_now = label_old;
                    end
       
        elseif label_now == 1 & label_old == 3 % red -> yellow 
                    is_not = is_not_a_sector(A,xx,yy,20);
                    if is_not == false
                    segment_stop_alpha = [segment_stop_alpha; alpha];
                    lbl = lbl+1;
                    count_red = count_red+1;
                    segment_label = [segment_label; lbl];
                    segment_color = [segment_color;  streak_color];
                    text(xx,yy,num2str(count_red),'Color','k')
                     elseif is_not == true
                        label_now = label_old;
                    end
        elseif label_now == 3 & label_old == 2  % blue -> red
                    is_not = is_not_a_sector(A,xx,yy,60);
                    if is_not == false
                    count_mixed = count_mixed+1;
                    
                    streak_color = ['m'];
                    
                    hold on
                     elseif is_not == true
                        label_now = label_old;
                    end
        elseif label_now == 2 & label_old == 3 % red -> blue
                    is_not = is_not_a_sector(A,xx,yy,60);
                    if is_not == false
                    count_mixed = count_mixed+1;
                   
                    streak_color = ['m'];
                    hold on
                     elseif is_not == true
                        label_now = label_old;
                    end
        else
        end
    end
    label_old=label_now;    
end
% save the figures with countings 
 cd(Image_output_directory)
 saveas(fig, file);

% recount
[GC,GR] = groupcounts(segment_color); 
count_red = GC(GR=='r');
if isempty(count_red)
    count_red = 0;
end
count_blue = GC(GR=='b');
if isempty(count_blue)
    count_blue = 0;
end
count_mixed = GC(GR=='m');
if isempty(count_mixed) 
    count_mixed = 0; 
end 
count_total = count_red+count_blue+ count_mixed;
% if size sizes of stop and start are different program will display for
% which file this occured and will break
if size(segment_start_alpha) == size(segment_stop_alpha)
     segment_size = segment_stop_alpha-segment_start_alpha;
else
     disp(file)
     disp(['start_size=' num2str(length(segment_start_alpha))]);
     disp(['stop_size=' num2str(length(segment_stop_alpha))]);
     segment_start_alpha = zeros(length(segment_label));
     segment_stop_alpha = zeros(length(segment_label));
end
if count_total == 0
    segment_color = 0;
    segment_label = 0;
    segment_size = 0;
    segment_start_alpha = 0;
    segment_stop_alpha = 0; 
end
Streaks_matrix = [segment_label segment_start_alpha segment_stop_alpha segment_size];

%save all the data to the colony structure
total_pixels = length(theta);

colEdge = [X_edge, Y_edge]; 
Colony(i) = get_data(file, RR, rad_microns, center, colEdge, Streaks_matrix, segment_color, count_red, count_blue, count_mixed, count_total, red_pixels, blue_pixels, total_pixels);

close all
%Column = [filename(i); radius; count_red; count_blue; mixed; sum_sectors];
%Save_matrix = [Save_matrix Column];

end
%save the data structure to desired directory
cd(Colony_output_directory);
save(Colony_output_name, 'Colony');

cd('C:\Users\saif\Desktop\Serhii\Projects\Early_late_experiment\matlab')

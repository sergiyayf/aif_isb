%This programm takes segmented images chosen by you manually and saves
%images with visualization which sectors are counted and the data as a
%structure mat file
function Multifile_analysis_function_old(input_filename, input_directory, Colony_output_directory, Colony_output_name, Image_output_directory)
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
cd(Image_output_directory)
for i = 1:1:number_of_selected_files
clear A res;
file = char(filename(i));
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
res = label2rgb(A, map); % change labels to colors specified in the color map

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
radius = RR-50;

fig = figure ;
imshow(res)
h = viscircles(center,radius);
hold on 

%define the starting point, check it to be yellow, to make counting easier
start_angle = 0;
stop_angle = 2*pi; 
x0 = fix( center(1) + radius*cos(start_angle)) ;
y0 =fix( center(2) + radius*sin(start_angle)) ;

% some code to check if you start with yellow, might create infinite loops if there is no yellow on the circle at all;
while A(y0,x0) ~= 1
    start_angle = start_angle +1/pi;
    stop_angle = stop_angle +1/pi;
    x0 = fix( center(1) + radius*cos(start_angle)) ;
    y0 =fix( center(2) + radius*sin(start_angle)) ;
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
for alpha = start_angle:pi/720:stop_angle
    %round position to the integer to access the value of matrix
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
% save the figures with countings 
saveas(fig, file);

count_red;
count_blue;
count_mixed = 0;
count_total = count_red+count_blue+ count_mixed;
% if size sizes of stop and start are different program will display for
% which file this occured and will break
if size(segment_start_alpha) == size(segment_stop_alpha)
     segment_size = segment_stop_alpha-segment_start_alpha;
else
     disp(file)
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
Colony(i) = get_data(file, RR, radius, center, Streaks_matrix, segment_color, count_red, count_blue, count_mixed, count_total);

close all
%Column = [filename(i); radius; count_red; count_blue; mixed; sum_sectors];
%Save_matrix = [Save_matrix Column];

end
%save the data structure to desired directory
cd(Colony_output_directory);
save(Colony_output_name, 'Colony');

end

%save('Save_matrix_2.mat', 'Save_matrix');
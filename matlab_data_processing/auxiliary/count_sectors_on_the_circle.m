%
%
% Date of first version 10/11/2020
%
% Created by @saif
%
% Function to calculate number of red and blue segments from the ER segmented images 
%
% Input1 -> Segmented image with not more then 5 labels, 1,2,3 labels - YFP, CFP, RFP 
% Input2 -> Radius of the circle on which to count sectors
% Input3 -> center of the circle 
%
% Output1 -> number of red sectors 
% Output2 -> number of blue sectors 
% function also shows the figure and labels the counts

function [count_red, count_blue] = count_sectors_on_the_circle(Image, radius, center) 
A = Image;
count_red = 0;
count_blue = 0;
x0 =fix( center(1) + radius) ;
y0 =fix( center(2)) ;
label_old = A(y0,x0);
radius = radius;

figure;
imshow(res);
h = viscircles(center,radius);
hold on 
plot (x_circle, y_circle, 'LineWidth', 2)
hold on
plot (max_x_black, y_pos_max, '+b', 'MarkerSize', 8)
hold on 
plot (min_x_black, y_pos_min, '*b', 'MarkerSize', 8)
hold on
plot (center_pos_x, center_pos_y, '+r', 'MarkerSize', 8)
hold on 


for alpha = 0:pi/360:2*pi
    %round position to the integer to access the value of matrix
    xx =fix( center(1) + radius*cos(alpha)) ;
    yy =fix( center(2) + radius*sin(alpha)) ;
    label_now = A(yy,xx);
    if label_now ~= label_old 
        if label_now == 2
                    count_blue = count_blue+1;
                    text(xx,yy,num2str(count_blue),'Color','b')
                    hold on
        elseif label_now == 3
                    count_red = count_red+1;
                    text(xx,yy,num2str(count_red),'Color','k')
                    hold on
        else
        end
    end
    label_old=label_now;    
end

count_red;
count_blue;

end

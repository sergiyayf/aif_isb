%function to look if counted thing is a sector os not 
% intput - segmented image, x position of the point, y position of the
% point threshold of the object size that would be considered not a sector
%return a booling which is true if the object is small and false if it is
%large and so probably a sector 

function is_small = is_not_a_sector(Image, x_position, y_position, threshold_inp) 

    
if nargin<4
    threshold = 100;
else
    threshold=threshold_inp;
end

x_start = x_position-10; 
x_end = x_position+10;
y_start = y_position -10;
y_end = y_position+10; 

submatrix = Image( y_start:y_end,x_start:x_end);

center_label = submatrix(11,11);
%loop through submatrix
for i=1:1:21
    for j=1:1:21
        if submatrix(i,j) == center_label
            submatrxi(i,j) = 1;
        else
            submatrix(i,j) = 0;
        end
    end
end

L = bwlabel(submatrix,4); 

new_label = L(21,21);
k = find(L==new_label);
element_number = length(k); 

if element_number<threshold
    is_small = true;
    %disp(element_number)
elseif element_number>=threshold
    is_small = false;
    %disp(element_number)
end

end


    


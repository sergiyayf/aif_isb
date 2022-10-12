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

 figure
%Now process here: 
for j =1:1:length(Col_1) 
    
    if isempty(strfind(Col_1(j).name,'yJK26c')) == false
       Col_1(j).metadata.BED = 10;  
       Col_2(j).metadata.BED = 10;  
       Col_3(j).metadata.BED = 10;  
       Col_4(j).metadata.BED = 10;  
       Col_5(j).metadata.BED = 10;  
       Col_6(j).metadata.BED = 10;  
       
    end
    
    X = Col_1(j).metadata.day; 
    Y = Col_1(j).metadata.CHX+Col_1(j).metadata.BED; 
    Z = Col_1(j).count_total; 
    scatter3(X,Y,Z,'b','filled'); 
    hold on
    
      X = Col_2(j).metadata.day; 
    Y = Col_2(j).metadata.CHX+Col_2(j).metadata.BED; 
    Z = Col_2(j).count_total; 
    scatter3(X,Y,Z,'b','filled'); 
    hold on
    
    
      X = Col_3(j).metadata.day; 
    Y = Col_3(j).metadata.CHX+Col_3(j).metadata.BED; 
    Z = Col_3(j).count_total; 
    scatter3(X,Y,Z,'b','filled'); 
    hold on
    
      X = Col_4(j).metadata.day; 
    Y = Col_4(j).metadata.CHX+Col_4(j).metadata.BED; 
    Z = Col_4(j).count_total; 
    scatter3(X,Y,Z,'b','filled'); 
    hold on
    
      X = Col_5(j).metadata.day; 
    Y = Col_5(j).metadata.CHX+Col_5(j).metadata.BED; 
    Z = Col_5(j).count_total; 
    scatter3(X,Y,Z,'b','filled'); 
    hold on
    
      X = Col_6(j).metadata.day; 
    Y = Col_6(j).metadata.CHX+Col_6(j).metadata.BED; 
    Z = Col_6(j).count_total; 
    scatter3(X,Y,Z,'b','filled'); 
    hold on
    
end
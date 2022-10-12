clc 
clear
close all 

%rad, indx, condition, counts, blues ... 
[Cell_CHX, Cell_BED, Cell_CHX_JK, Cell_BED_JK] = restruct_conditions(6); 

CHX=[0 25 50 100 150];
BED=[0 0.5 1 1.5 2 4 10];
DAYS=[1:6];
sets=[1 2];
zooms_new = [8 6.3 4.5];
scaling_factors_new = [5.675 7.212 10.022];
zooms_old = [8 6.3 4.5 4 3.5];
scaling_factors_old = [8.063 10.246 14.333 16.125 18.429];

for chx_indx = 1:1:3
    
    figure(chx_indx);
    ax(chx_indx) = axes; 
    
    [num_bed,~,id_bed] = unique(Cell_CHX(chx_indx).BEDs);
    totals = zeros(6,length(num_bed));
    rad_matrix = zeros(6,length(num_bed));
    blues = zeros(6,length(num_bed));
    
    [num_bed_JK,~,id_bed_JK] = unique(Cell_CHX_JK(chx_indx).BEDs);
    totals_JK = zeros(6,length(num_bed_JK));
    rad_matrix_JK = zeros(6,length(num_bed_JK));
    blues_JK = zeros(6,length(num_bed_JK));
    
    for day = DAYS
    [Cell_CHX, Cell_BED, Cell_CHX_JK, Cell_BED_JK] = restruct_conditions(day); 
    chx = CHX(chx_indx);
    Radius = Cell_CHX(chx_indx).micron_radius;
    Radius_JK = Cell_CHX_JK(chx_indx).micron_radius;
    BEDs = Cell_CHX(chx_indx).BEDs;
    BEDs_JK = Cell_CHX_JK(chx_indx).BEDs;
    counts = Cell_CHX(chx_indx).total_counts;
    counts_JK = Cell_CHX_JK(chx_indx).total_counts;
    blue_counts = Cell_CHX(chx_indx).blue_counts;
    blue_counts_JK = Cell_CHX_JK(chx_indx).blue_counts;
    if isempty(BEDs) == false
        %find unique BEDs
    [ux_BED,~,id] = unique(BEDs);
    %find mean counts
    counts_mean = accumarray(id,counts,[],@mean);
    %find mean radius
    radius_mean = accumarray(id,Radius,[],@mean);
    blues_mean = accumarray(id,blue_counts,[],@mean);
    
    blues(day,:) = blues_mean.';
    totals(day,:) = counts_mean.';
    rad_matrix(day,:) = radius_mean.';
   
    end
    
    
    %JK data 
    if isempty(BEDs_JK) == false
        %find unique BEDs
    [ux_BED_JK,~,id_JK] = unique(BEDs_JK);
    %find mean counts
    counts_mean_JK = accumarray(id_JK,counts_JK,[],@mean);
    %find mean radius
    radius_mean_JK = accumarray(id_JK,Radius_JK,[],@mean);
    blues_mean_JK = accumarray(id_JK,blue_counts_JK,[],@mean);
    
    blues_JK(day,:) = blues_mean_JK.';
    totals_JK(day,:) = counts_mean_JK.';
    rad_matrix_JK(day,:) = radius_mean_JK.';
    
    end
    
    end
    
    colors=winter(length(BED));
    if BED(end)==10
        colors(end,:)=[1 0 0];
    end
    colors_JK=spring(length(BED));
    if BED(end)==10
        colors_JK(end,:)=[1 0 0];
    end
    if isempty(totals) == false 
        sz = size(totals);
       for i = 1:1:sz(2)
           plot(ux_BED(i), totals(5,i)/totals(1,i), '+', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
           plot(ux_BED(i), blues(5,i)/totals(5,i), ':o', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
           plot(ux_BED(i), totals(1,i)/totals(1,sz(2)), 'd', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
       end
    end
     if isempty(totals_JK) == false 
        sz2 = size(totals_JK); 
       for i = 1:1:sz2(2)
           plot(ux_BED_JK(i), totals_JK(5,i)/totals_JK(1,i),'+', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i)) '_ JK']);
           hold on
           plot(ux_BED_JK(i), blues_JK(5,i)/totals_JK(5,i),':o', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i)) '_ JK']);
           hold on
          
       end
     end
    figure(10+chx_indx)
    for i=1:1:sz(2)
    plot(1:5, totals(1:5,sz(2))/totals(1,sz(2)) - totals(1:5,i)/totals(1,i) , '+', 'LineWidth',2);
    hold on
    end
    selection_mat =  - totals(1:5,:)./totals(1,:) +totals(1:5,sz(2))/totals(1,sz(2));
     totals = totals.';
    blues = blues.';
    totals_JK = totals_JK.';
    blues_JK = blues_JK.';
    %{
      
    totals = totals.';
    blues = blues.';
    totals_JK = totals_JK.';
    blues_JK = blues_JK.';
    tot_array = totals(:);
    rd = rad_matrix(:,:) - rad_matrix(1,:);
    rad_array = rd(:);
    S_mat = [rad_array tot_array];
    tot_array_JK = totals_JK(:);
    rd_JK = rad_matrix_JK(:,:) - rad_matrix_JK(1,:);
    rad_array_JK = rd_JK(:); 
    J_mat = [rad_array_JK tot_array_JK];
    save(['S_mat_' num2str(chx_indx) '.mat'], 'S_mat');
    save(['J_mat_' num2str(chx_indx) '.mat'], 'J_mat');
    %}
    %legend
    title(['CHX=' num2str(CHX(chx_indx))]);
    xlabel('Estradiol concentration');
    ylabel('total number of sectors'); 
  
  
end
    


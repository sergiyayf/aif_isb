clc 
clear
close all 

%rad, indx, condition, counts, blues ... 
[Cell_CHX, Cell_BED, Cell_CHX_JK, Cell_BED_JK] = switch_conditions_separate(5); 

CHX=[0 25 50 100 150];
BED=[0 0.5 1 1.5 2 4 10];
DAYS=[1:5];

for chx_indx = 1:1:3
    
    figure(chx_indx);
    ax(chx_indx) = axes; 
    
    [num_bed,~,id_bed] = unique(Cell_CHX(chx_indx).BEDs);
    totals = zeros(length(DAYS),length(num_bed));
    rad_matrix = zeros(length(DAYS),length(num_bed));
    blues = zeros(length(DAYS),length(num_bed));
    red_freq_matrix = zeros(length(DAYS),length(num_bed));
    blue_freq_matrix = zeros(length(DAYS),length(num_bed));
    
    [num_bed_JK,~,id_bed_JK] = unique(Cell_CHX_JK(chx_indx).BEDs);
    totals_JK = zeros(length(DAYS),length(num_bed_JK));
    rad_matrix_JK = zeros(length(DAYS),length(num_bed_JK));
    blues_JK = zeros(length(DAYS),length(num_bed_JK));
    red_freq_matrix_JK = zeros(length(DAYS),length(num_bed_JK));
    blue_freq_matrix_JK = zeros(length(DAYS),length(num_bed_JK));
    
    for day = DAYS
    [Cell_CHX, Cell_BED, Cell_CHX_JK, Cell_BED_JK] = switch_conditions_separate(day); 
    chx = CHX(chx_indx);
    Radius = Cell_CHX(chx_indx).micron_radius;
    Radius_JK = Cell_CHX_JK(chx_indx).micron_radius;
    BEDs = Cell_CHX(chx_indx).BEDs;
    BEDs_JK = Cell_CHX_JK(chx_indx).BEDs;
    counts = Cell_CHX(chx_indx).total_counts;
    counts_JK = Cell_CHX_JK(chx_indx).total_counts;
    blue_counts = Cell_CHX(chx_indx).blue_counts;
    blue_counts_JK = Cell_CHX_JK(chx_indx).blue_counts;
    
    
    red_freq = Cell_CHX(chx_indx).red_freq; 
    red_freq_JK = Cell_CHX_JK(chx_indx).red_freq;
    blue_freq = Cell_CHX(chx_indx).blue_freq; 
    blue_freq_JK = Cell_CHX_JK(chx_indx).blue_freq; 
    
    if isempty(BEDs) == false
        %find unique BEDs
    [ux_BED,~,id] = unique(BEDs);
    %find mean counts
    counts_mean = accumarray(id,counts,[],@mean);
    %find mean radius
    radius_mean = accumarray(id,Radius,[],@mean);
    blues_mean = accumarray(id,blue_counts,[],@mean);
    
    red_freq_mean = accumarray(id,red_freq,[],@mean); 
    blue_freq_mean = accumarray(id,blue_freq,[],@mean); 
    
    blues(day,:) = blues_mean.';
    totals(day,:) = counts_mean.';
    rad_matrix(day,:) = radius_mean.';
    
    red_freq_matrix(day,:) = red_freq_mean.';
    blue_freq_matrix(day,:) = blue_freq_mean.'; 
    
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
    
    red_freq_mean_JK = accumarray(id_JK,red_freq_JK,[],@mean); 
    blue_freq_mean_JK = accumarray(id_JK,blue_freq_JK,[],@mean); 
    
    blues_JK(day,:) = blues_mean_JK.';
    totals_JK(day,:) = counts_mean_JK.';
    rad_matrix_JK(day,:) = radius_mean_JK.';
    
    red_freq_matrix_JK(day,:) = red_freq_mean_JK.';
    blue_freq_matrix_JK(day,:) = blue_freq_mean_JK.'; 
    
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
           P = diff(blue_freq_matrix(1:4,i))./(1-blue_freq_matrix(1:3,i))
           plot((rad_matrix(2:4,i))-rad_matrix(1,i), P, '-', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           %plot(rad_matrix(:,i)-rad_matrix(1,i), blues(:,i), ':o', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
           plot(rad_matrix(1:4,i)-rad_matrix(1,i), blue_freq_matrix(1:4,i), ':o', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
          
          
       end
    end
     if isempty(totals_JK) == false 
        sz2 = size(totals_JK); 
        
       for i = 1:1:sz2(2)
           P = diff(blue_freq_matrix_JK(1:4,i))./(1-blue_freq_matrix_JK(1:3,i))
           
           plot((rad_matrix_JK(2:4,i))-rad_matrix_JK(1,i), P, '-', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i))]);
           %plot(rad_matrix_JK(:,i)-rad_matrix_JK(1,i), blues_JK(:,i), ':o', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i)) '_ JK']);
           hold on
          plot(rad_matrix_JK(1:4,i)-rad_matrix_JK(1,i), blue_freq_matrix_JK(1:4,i), ':o', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i)) '_ JK']);
           
          
       end
     end
        
    legend
    title(['CHX=' num2str(CHX(chx_indx))]);
    xlabel('delta R');
    ylabel('frequency of blue'); 
  
  
end
    


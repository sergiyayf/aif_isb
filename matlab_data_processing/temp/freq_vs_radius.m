clc 
clear
close all 

%rad, indx, condition, counts, blues ... 
[Cell_CHX, Cell_BED, Cell_CHX_JK, Cell_BED_JK] = condition_separate_data_func(6); 

CHX=[0 25 50 100 150];
BED=[0 0.5 1 1.5 2 4 10];
DAYS=[1:6];
sets=[1 2];
zooms_new = [8 6.3 4.5];
scaling_factors_new = [5.675 7.212 10.022];
zooms_old = [8 6.3 4.5 4 3.5];
scaling_factors_old = [8.063 10.246 14.333 16.125 18.429];

for chx_indx = 1:1:length(CHX)
    figure(chx_indx);
    ax(chx_indx) = axes; 
    
    [num_bed,~,id_bed] = unique(Cell_CHX(chx_indx).BEDs);
    totals = zeros(6,length(num_bed));
    rad_matrix = zeros(6,length(num_bed));
    blues = zeros(6,length(num_bed));
    width_matrix = zeros(6,length(num_bed));
    red_freq_matrix = zeros(6,length(num_bed));
    blue_freq_matrix = zeros(6,length(num_bed));
    
    [num_bed_JK,~,id_bed_JK] = unique(Cell_CHX_JK(chx_indx).BEDs);
    totals_JK = zeros(6,length(num_bed_JK));
    rad_matrix_JK = zeros(6,length(num_bed_JK));
    blues_JK = zeros(6,length(num_bed_JK));
    width_matrix_JK = zeros(6,length(num_bed_JK));
    red_freq_matrix_JK = zeros(6,length(num_bed_JK));
    blue_freq_matrix_JK = zeros(6,length(num_bed_JK));
    
    for day = DAYS
    [Cell_CHX, Cell_BED, Cell_CHX_JK, Cell_BED_JK] = condition_separate_data_func(day); 
    chx = CHX(chx_indx);
    Radius = Cell_CHX(chx_indx).micron_radius;
    Radius_JK = Cell_CHX_JK(chx_indx).micron_radius;
    BEDs = Cell_CHX(chx_indx).BEDs;
    BEDs_JK = Cell_CHX_JK(chx_indx).BEDs;
    counts = Cell_CHX(chx_indx).total_counts;
    counts_JK = Cell_CHX_JK(chx_indx).total_counts;
    blue_counts = Cell_CHX(chx_indx).blue_counts;
    blue_counts_JK = Cell_CHX_JK(chx_indx).blue_counts;
    width = Cell_CHX(chx_indx).frequency; 
    width_JK = Cell_CHX_JK(chx_indx).frequency; 
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
    width_mean = accumarray(id,width,[],@mean);
    red_freq_mean = accumarray(id,red_freq,[],@mean); 
    blue_freq_mean = accumarray(id,blue_freq,[],@mean); 
    
    blues(day,:) = blues_mean.';
    totals(day,:) = counts_mean.';
    rad_matrix(day,:) = radius_mean.';
    width_matrix(day,:) = width_mean.'; 
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
    width_mean_JK = accumarray(id_JK,width_JK,[],@mean);
    red_freq_mean_JK = accumarray(id_JK,red_freq_JK,[],@mean); 
    blue_freq_mean_JK = accumarray(id_JK,blue_freq_JK,[],@mean); 
    
    blues_JK(day,:) = blues_mean_JK.';
    totals_JK(day,:) = counts_mean_JK.';
    rad_matrix_JK(day,:) = radius_mean_JK.';
    width_matrix_JK(day,:) = width_mean_JK.';
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
           subplot(1,3,1);
           plot(rad_matrix(:,i)-rad_matrix(1,i), red_freq_matrix(:,i), '-o', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
           plot(rad_matrix(:,i)-rad_matrix(1,i), blue_freq_matrix(:,i), ':o', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
           subplot(1,3,2); 
           plot(rad_matrix(:,i)-rad_matrix(1,i), width_matrix(:,i), ':o', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
           subplot(1,3,3);
            plot(rad_matrix(:,i)-rad_matrix(1,i), totals(:,i)/totals(1,i), '-o', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
           plot(rad_matrix(:,i)-rad_matrix(1,i), blues(:,i)./totals(:,i), ':o', 'color', colors(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED(i))]);
           hold on
       end
    end
     if isempty(totals_JK) == false 
        sz2 = size(totals_JK);
       for i = 1:1:sz2(2)
           subplot(1,3,1);
           plot(rad_matrix_JK(:,i)-rad_matrix_JK(1,i), red_freq_matrix_JK(:,i),'-o', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i)) '_ JK']);
           hold on
           plot(rad_matrix_JK(:,i)-rad_matrix_JK(1,i), blue_freq_matrix_JK(:,i),':o', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i)) '_ JK']);
           hold on 
           subplot(1,3,2); 
           plot(rad_matrix_JK(:,i)-rad_matrix_JK(1,i), width_matrix_JK(:,i), ':o', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i))]);
           hold on
           subplot(1,3,3);
           plot(rad_matrix_JK(:,i)-rad_matrix_JK(1,i), totals_JK(:,i)/totals_JK(1,i),'-o', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i)) '_ JK']);
           hold on
           plot(rad_matrix_JK(:,i)-rad_matrix_JK(1,i), blues_JK(:,i)./totals_JK(:,i),':o', 'color', colors_JK(i,:),'LineWidth',2, 'DisplayName', ['BED=' num2str(ux_BED_JK(i)) '_ JK']);
           hold on
       end
     end
     subplot(1,3,1);
    legend
    title(['CHX=' num2str(CHX(chx_indx))]);
    xlabel('Radius {\mu}m');
    ylabel('frequencies'); 
    set(gca, 'YScale', 'log')
    axis([-10 6500 0 1])
    
    subplot(1,3,2); 
     legend
    title(['CHX=' num2str(CHX(chx_indx))]);
    xlabel('Radius {\mu}m');
    ylabel('total frequency'); 
    set(gca, 'YScale', 'log')
    axis([-10 6500 0 1])
    
     subplot(1,3,3); 
     legend
    title(['CHX=' num2str(CHX(chx_indx))]);
    xlabel('Radius {\mu}m');
    ylabel('total number, normalized to day1'); 
    axis([-10 6500 0 1])
end
    


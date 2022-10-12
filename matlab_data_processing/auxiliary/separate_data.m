function [Cell_CHX, Cell_BED, Cell_CHX_JK, Cell_BED_JK] = separate_data(look_at_day); 
CHX=[0 25 50 100 150];
BED=[0 0.5 1 1.5 2 4 10];
DAYS=[1:6];
sets=[1 2]; % 1 is new, 2 is old 

zooms_new = [8 6.3 4.5];
scaling_factors_new = [5.675 7.212 10.022];
zooms_old = [8 6.3 4.5 4 3.5];
scaling_factors_old = [8.063 10.246 14.333 16.125 18.429];

day_to_look = look_at_day; 
% load data from raw
%new
dataCol = [];
for day=DAYS
        load(['data_day_' num2str(day) '.mat'],'Colony');
        dataCol = [dataCol; Colony];
end
%old
dataCol_JK = [];
for day=DAYS
        load(['JK_data_day_' num2str(day) '.mat'],'Colony');
        dataCol_JK = [dataCol_JK; Colony];
end

Sn = size(dataCol);
SJK = size(dataCol_JK);
 
%set BED to 10 if infinity and also translate the radius to microns 
rad_microns = [];
for j = 1:1:Sn(2)
      if isempty(strfind(dataCol(day_to_look,j).name,'yJK26c')) == false
            dataCol(day_to_look,j).metadata.BED = 10;  
      end
      z = dataCol(day_to_look,j).metadata.zoom; 
      [zm, zm_ind] = find(zooms_new == z);
      rad_microns = [rad_microns scaling_factors_new(zm_ind)*dataCol(day_to_look,j).radius];
end

%loop through all the colonies and create vectors with conditions
BED_vector = [];
CHX_vector = []; 
for j = 1:1:Sn(2)
        BED_vector = [BED_vector; dataCol(day_to_look,j).metadata.BED];
        CHX_vector = [CHX_vector; dataCol(day_to_look,j).metadata.CHX]; 
end

% loop through all CHX 
for chx_indx =1:1:length(CHX)
    inds{chx_indx} = find(CHX_vector == CHX(chx_indx));
end

% initialize 

Cell_CHX = [];

for i = 1:1:length(inds)
    index = inds{1,i};
    BEDs = [];
    Rad = [];
    BED_counts = [];
    BED_blues = [];
    Micron_radius = [];
    for j = 1:1:length(index)
       k = index(j);
       BEDs = [BEDs; dataCol(day_to_look,k).metadata.BED];
       BED_counts = [BED_counts; dataCol(day_to_look,k).count_total];
       BEDs_index = index;
       Rad = [Rad; dataCol(day_to_look,k).radius];
       Micron_radius = [Micron_radius rad_microns(k)];
       BED_blues = [BED_blues; dataCol(day_to_look,k).count_blue];
    end
   Cell_CHX{5*i-4} = Micron_radius;
   Cell_CHX{5*i-3} = BEDs_index;
   Cell_CHX{5*i-2} = BEDs;
   Cell_CHX{5*i-1} = BED_counts;
   Cell_CHX{5*i} = BED_blues;
   
end

% loop through all BED
for bed_indx =1:1:length(BED)
    b_inds{bed_indx} = find(BED_vector == BED(bed_indx));
end

% initialize 

Cell_BED = [];

for i = 1:1:length(b_inds)
    index = b_inds{1,i};
    CHXs = [];
    CHX_counts = [];
    Rad = [];
    Micron_radius = [];
    CHX_blues = [];
    for j = 1:1:length(index)
       k = index(j);
       CHXs = [CHXs; dataCol(day_to_look,k).metadata.CHX];
       CHX_counts = [CHX_counts; dataCol(day_to_look,k).count_total];
       CHXs_index = index;
       Rad = [Rad; dataCol(day_to_look,k).radius];
       Micron_radius = [Micron_radius rad_microns(k)];
       CHX_blues = [CHX_blues; dataCol(day_to_look,k).count_blue];
    end
   Cell_BED{5*i-4} = Micron_radius;
   Cell_BED{i*5 -3} = CHXs_index; 
   Cell_BED{5*i-2} = CHXs;
   Cell_BED{5*i-1} = CHX_counts;
   Cell_BED{5*i} = CHX_blues;
end
%-----------------------------------------

%Berkley data 

%set BED to 10 if infinity 
rad_microns = [];
for j = 1:1:SJK(2)
      if isempty(strfind(dataCol_JK(day_to_look,j).name,'yJK26c')) == false
            dataCol_JK(day_to_look,j).metadata.BED = 10;  
      end
      z = dataCol_JK(day_to_look,j).metadata.zoom; 
      [zm, zm_ind] = find(zooms_old == z);
      rad_microns = [rad_microns scaling_factors_old(zm_ind)*dataCol_JK(day_to_look,j).radius];
end

%loop through all the colonies and create vectors with conditions
BED_vector = [];
CHX_vector = []; 
for j = 1:1:SJK(2)
        BED_vector = [BED_vector; dataCol_JK(day_to_look,j).metadata.BED];
        CHX_vector = [CHX_vector; dataCol_JK(day_to_look,j).metadata.CHX]; 
end

% loop through all CHX 
for chx_indx =1:1:length(CHX)
    inds{chx_indx} = find(CHX_vector == CHX(chx_indx));
end

% initialize 

Cell_CHX_JK = [];
for i = 1:1:length(inds)
    index = inds{1,i};
    BEDs = [];
    BED_counts = [];
    Rad = [];
    Micron_radius = [];
    BED_blues = [];
    for j = 1:1:length(index)
       k = index(j);
       BEDs = [BEDs; dataCol_JK(day_to_look,k).metadata.BED];
       BED_counts = [BED_counts; dataCol_JK(day_to_look,k).count_total];
       BEDs_index = index; 
       Rad = [Rad; dataCol_JK(day_to_look,k).radius];
       Micron_radius = [Micron_radius rad_microns(k)];
       BED_blues = [BED_blues; dataCol_JK(day_to_look,k).count_blue];
    end
    Cell_CHX_JK{5*i-4} = Micron_radius;
   Cell_CHX_JK{5*i-3} = BEDs_index;
   Cell_CHX_JK{5*i-2} = BEDs;
   Cell_CHX_JK{5*i-1} = BED_counts;
   Cell_CHX_JK{5*i} = BED_blues;
end

% loop through all BED
for bed_indx =1:1:length(BED)
    b_inds{bed_indx} = find(BED_vector == BED(bed_indx));
end

% initialize 

Cell_BED_JK = [];
for i = 1:1:length(b_inds)
    index = b_inds{1,i};
    CHXs = [];
    CHX_counts = [];
    Rad = [];
    Micron_radius = [];
    CHX_blues = [];
    for j = 1:1:length(index)
       k = index(j);
       CHXs = [CHXs; dataCol_JK(day_to_look,k).metadata.CHX];
       CHX_counts = [CHX_counts; dataCol_JK(day_to_look,k).count_total];
       CHXs_index = index;
       Rad = [Rad; dataCol_JK(day_to_look,k).radius];
       Micron_radius = [Micron_radius rad_microns(k)];
       CHX_blues = [CHX_blues; dataCol_JK(day_to_look,k).count_blue];
    end
    Cell_BED_JK{5*i-4} = Micron_radius;
    Cell_BED_JK{5*i-3} = CHXs_index; 
   Cell_BED_JK{5*i-2} = CHXs;
   Cell_BED_JK{5*i-1} = CHX_counts;
   Cell_BED_JK{5*i} = CHX_blues;
end

end
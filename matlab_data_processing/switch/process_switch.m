%
%
% load images, specify directories and filenames, where to store the
% results 
%
% use Multifile_analysis_function that processes all the data and saves
% important information and images that visualize how did the counting go 
%
%
clc 
clear 
close all

%choose your segmented files, you can only choose files, no folders
[input_filename, input_directory] = uigetfile([pwd 'D:\Serhii\Projects\Switch_experiment(for-paper)\*.tif'], 'Select at least 2 segmented tif files', 'MultiSelect','on');  %open the file to process by choosing it

Colony_output_directory = 'C:\Users\saif\Desktop\Serhii\Projects\selection-escape\matlab_data_processing\switch\paper_data'; 
Colony_output_name = 'switch_7.mat'; 

Image_output_directory = 'D:\Serhii\Projects\Switch_experiment(for-paper)\matlab_images'; 

% 7 (8) day check if scene is larger than 2 (4)

flag = 1;

if flag == 6
number_of_selected_files = length(input_filename); 

for j = 1:1:number_of_selected_files
    FileName = char(input_filename(j));
    export = strfind(FileName, 'Export');
    scene = FileName(export+11);
    scene = str2num(scene);
    
    if scene < 3 
        input_filename{j} = []; 
    end
end

input_filename = input_filename(~cellfun('isempty',input_filename));

elseif flag == 7
    number_of_selected_files = length(input_filename); 

for j = 1:1:number_of_selected_files
        FileName = char(input_filename(j));
        export = strfind(FileName, 'Export');
        scene = FileName(export+11);
        scene = str2num(scene);
    
        if scene < 5 
           input_filename{j} = []; 
        end
end

input_filename = input_filename(~cellfun('isempty',input_filename));
end

switch_analyze(input_filename, input_directory, Colony_output_directory, Colony_output_name, Image_output_directory); 

cd 'C:\Users\saif\Desktop\Serhii\Projects\selection-escape\matlab_data_processing\switch'
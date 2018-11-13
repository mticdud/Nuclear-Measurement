function [num_frame] = size_check(Frame_num)
%Function within Nuclear_Measure_GUI for determining number of frames
frame_check = Frame_num;
[folder,~,~] = fileparts(frame_check); %get folder name from input
a=dir([folder '/*.tif']); %check folder directory for all other .tif files
num_frame = size(a,1); %number of frames in folder
end


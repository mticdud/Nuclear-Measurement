function [vid_Outlines,Areas_true] = Cell_Area_Func_vid(Frame_num,pixscale,handles)
%Cell Area Function for use in Nuclear_Measure_GUI
%get folder and all .tif files from folder and check size of folder
frame_check = Frame_num;
[folder,~,~] = fileparts(frame_check);
a=dir([folder '/*.tif']);
out=size(a,1);

axes(handles.plot_outline) %plot in bottom axes on GUI
disp('Displaying Outline Frames...')
vid_Outlines(out) = struct('cdata',[],'colormap',[]); %store data in structure
areas = zeros(out);
for i=1:out
    first = {a(i).folder}; %cycle through each file in the folder
    second = {a(i).name};
    full = fullfile(first,second);
    strang = convertStringsToChars(string(full)); %convert to character
    I = imread(strang);
    R = imtranslate(I,[1, 0]);
    L = imtranslate(I,[-1,0]);
    U = imtranslate(I,[0,1]);
    D = imtranslate(I,[0,-1]);
    %translate one pixel up, down, left, right
    RB = I & ~L; %one pixel on right boundary
    LB = I & ~R;
    UB = I & ~U;
    LowB = I & ~D;
    fullB = LB | RB | UB | LowB;
    %find outline by taking only overlapped frames
    dilatedImage = imdilate(fullB,strel('disk',10));
    thinnedImage = bwmorph(dilatedImage,'thin',inf); %dilate and thin image
    BWfill = imfill(thinnedImage,'holes'); %fill outline
    areas(i) = nnz(BWfill);
    imshow(BWfill)
    vid_Outlines(i) = getframe;  
end

comps = linspace(1,out,out);
Areas_int = areas(:,1);
Areas_true = Areas_int*(10^-6)*pixscale; %convert from pixels to um^2

axes(handles.plot_multi) %plot in bottom axes of GUI
plot(comps,Areas_true);
title('Nuclear Area')
xlabel('Frame Number')
ylabel('um^2')

disp('Saving outline video to current Matlab directory path')
y = VideoWriter('Area_Outs_Video.avi', 'Uncompressed AVI');
y.FrameRate = 20; %default framerate for all saved videos
open(y)
writeVideo(y,vid_Outlines)
close(y)
end



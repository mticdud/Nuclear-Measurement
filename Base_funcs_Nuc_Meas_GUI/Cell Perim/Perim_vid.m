function [vid_Outlines,Perimeters] = Perim_vid(Frame_num,pixscale,handles)
%Nuclear Perimeter Function with save video checked
%get folder and all .tif files from folder and check size of folder
frame_check = Frame_num;
[folder,~,~] = fileparts(frame_check);
a=dir([folder '/*.tif']);
out=size(a,1);

disp('Displaying Outline Frames...')
axes(handles.plot_outline) %plot to bottom axes on GUI
vid_Outlines(out) = struct('cdata',[],'colormap',[]); %saving outlines in data structure
perimeters = zeros(out);
for i=1:out
    first = {a(i).folder}; %take each found file in folder and convert to character
    second = {a(i).name};
    full = fullfile(first,second);
    strang = convertStringsToChars(string(full));
    I = imread(strang);
    R = imtranslate(I,[1, 0]);
    L = imtranslate(I,[-1,0]);
    U = imtranslate(I,[0,1]);
    D = imtranslate(I,[0,-1]);  %read in each file and translate one pixel up, 
    %down, left, right
    RB = I & ~L;
    LB = I & ~R;
    UB = I & ~U;
    LowB = I & ~D;
    fullB = LB | RB | UB | LowB;
    %Find outline by taking overlap of all
    dilatedImage = imdilate(fullB,strel('disk',10));
    thinnedImage = bwmorph(dilatedImage,'thin',inf); %dilate and thin outlines
    pers = regionprops(thinnedImage,'Perimeter'); %get perimeter statistics
    perimeters(i) = pers.Perimeter;
    imshow(thinnedImage)
    vid_Outlines(i) = getframe;
end

comps = linspace(1,out,out);
Perimeters = (perimeters(:,1)*(10^-6)*pixscale); %convert perimeters from pixels to um
axes(handles.plot_multi) %plot in upper axes of GUI
plot(comps,(Perimeters))
title('Perimeter Per Frame')
xlabel('Frame Number')
ylabel('um')

%create movie from saved outline frames. Default saves to Matlab directory
%path. Change directory path to save to different location
disp('Saving outline video to current Matlab directory path')
y = VideoWriter('Perim_Outs_Video.avi', 'Uncompressed AVI');
y.FrameRate = 20; %default framerate for all saved videos in GUI
open(y)
writeVideo(y,vid_Outlines)
close(y)
end


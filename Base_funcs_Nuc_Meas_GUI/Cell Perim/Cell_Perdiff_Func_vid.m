function [vid_Outlines,Perdiffs] = Cell_Perdiff_Func_vid(Frame_num,pixscale,handles)
%Nuclear Perimeter Function for Nuclear_Measure_GUI package with the save
%video option checked selected by the user
%get folder and all .tif files from folder and check size of folder
frame_check = Frame_num;
[folder,~,~] = fileparts(frame_check);
a=dir([folder '/*.tif']);
out=size(a,1);

disp('Perimeter Analysis Selected...')
disp('Displaying Outline Frames...')
axes(handles.plot_outline) %plot to bottom axes on GUI
vid_Outlines(out) = struct('cdata',[],'colormap',[]); %saving outlines in data structure
perimeters = zeros(out);
for i=1:out
    first1 = {a(1).folder}; %take first file in folder and convert to character
    second1 = {a(1).name};
    frm1 = fullfile(first1,second1);
    st1 = imread(frm1{1,1});
    st2 = imtranslate(st1,[1, 0]);
    st3 = imtranslate(st2,[-1,0]);
    st4 = imtranslate(st3,[0,1]);
    st5 = imtranslate(st4,[0,-1]);  %read in each file and translate one pixel up, 
    %down, left, right
    RB1 = st1 & ~st2;
    LB1 = st1 & ~st3;
    UB1 = st1 & ~st4;
    LowB1 = st1 & ~st5;
    fullB1 = LB1 | RB1 | UB1 | LowB1;
    %Find outline by taking overlap of all
    dilatedImage1 = imdilate(fullB1,strel('disk',10));
    thinnedImage1 = bwmorph(dilatedImage1,'thin',inf); %dilate and thin outlines

    first = {a(i).folder}; %take each found file in folder and convert to character
    second = {a(i).name};
    full = fullfile(first,second);
    strang = convertStringsToChars(string(full));
    I = imread(strang);
    R = imtranslate(I,[1, 0]);
    L = imtranslate(I,[-1,0]);
    U = imtranslate(I,[0,1]);
    D = imtranslate(I,[0,-1]);  
    RB = I & ~L;
    LB = I & ~R;
    UB = I & ~U;
    LowB = I & ~D;
    fullB = LB | RB | UB | LowB;
    dilatedImage = imdilate(fullB,strel('disk',10));
    thinnedImage = bwmorph(dilatedImage,'thin',inf);
    pers = regionprops(thinnedImage,'Perimeter'); %get perimeter statistics
    perimeters(i) = pers.Perimeter;
    imshowpair(thinnedImage1,thinnedImage) %display first outline with 
    %subsequent outlines overlaid.
    vid_Outlines(i) = getframe;
end

Per1 = perimeters(1,1)*(10^-6)*pixscale*10; %convert first perimeter from pixels to um
comps = linspace(1,out,out);
Perimeters = (perimeters(:,1)*(10^-6)*pixscale*10); %convert perimeters from pixels to um
Perdiffs = (Per1-Perimeters)*-1;
Perdiffperc = Per1/Perdiffs;
axes(handles.plot_multi) %plot in upper axes of GUI
plot(comps,(Perdiffs))
title('Perimeter Difference Per Subsequent Frame')
xlabel('Frame Number')
ylabel('um')

%create movie from saved outline frames. Default saves to Matlab directory
%path. Change directory path to save to different location
disp('Saving outline video to current Matlab directory path')
y = VideoWriter('Perimdiffs_Outs_Video.avi', 'Uncompressed AVI');
y.FrameRate = 20; %default framerate for all saved videos in GUI
open(y)
writeVideo(y,vid_Outlines)
close(y)
end


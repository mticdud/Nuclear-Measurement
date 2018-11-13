function [vid_Stacked,Percents] = Cell_Area_Diff_Func(Frame_num,pixscale,handles)
%Function for determining Nuclear Area Differences between original and
%subsequent frames
%get folder and all .tif files from folder and check size of folder
frame_check = Frame_num;
[folder,~,~] = fileparts(frame_check);
a=dir([folder '/*.tif']);
out=size(a,1);

disp('Cell Area Difference Selected...')
ws = warning('off','all');
%warning(ws)  % Turn it back on.

%figure('Name','Cell Outlines');
f = figure('visible', 'off'); %don't display figure for first cycle through masks
disp('Performing Initial Calculations...')
disp('.')
disp('.')
disp('.')
disp('Please wait...')
vid_Outlines(out) = struct('cdata',[],'colormap',[]); %store data in getframe structure
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
    RB = I & ~L; %one pixel line on right boundary
    LB = I & ~R;
    UB = I & ~U;
    LowB = I & ~D;
    fullB = LB | RB | UB | LowB;
    %find outline by taking only overlapped frames
    dilatedImage = imdilate(fullB,strel('disk',10));
    thinnedImage = bwmorph(dilatedImage,'thin',inf); %dilate and thin image
    imshow(thinnedImage)
    vid_Outlines(i) = getframe(gca); 
end
close

axes(handles.plot_outline) %plot on bottom axes of GUI
diffs = zeros(out);
ar1comp = zeros(out);
ar2comp = zeros(out);
disp('Displaying Stacked Areas...')
vid_Stacked(out) = struct('cdata',[],'colormap',[]); %store data in getframe structure
for i=1:out
    first = vid_Outlines(1).cdata; %pull data from first frame
    firstBW = rgb2gray(first);
    BW1 = imfill(firstBW,'holes'); %fill outline
    BW1comp = imcomplement(BW1); %take inverse of image
    next = vid_Outlines(i).cdata; %take subsequent frames
    nextBW = rgb2gray(next);
    BWnext = imfill(nextBW,'holes');
    BWnextcomp = imcomplement(BWnext);
    imshowpair(BW1comp,BWnextcomp); %show first and subsequent as overlays
    %Purple represents the first frame. Black is the subsequent. Green is
    %the overlap (i.e. where the subsequent frame extends beyond the first)
    area1 = nnz(BW1)*pixscale*10^-6; %convert nonzero elements to um^2
    ar1comp(i) = area1;
    areanext = nnz(BWnext)*pixscale*10^-6;
    ar2comp(i) = areanext;
    diffs(i) = area1-areanext; %area difference
    vid_Stacked(i) = getframe;
end

comps = linspace(1,out,out);
Areas_true = diffs(:,1);

axes(handles.plot_multi) %plot on upper axes of GUI
Percents = ((Areas_true/ar1comp(1,1))*100)*-1; %convert to percents and take
%inverse (cell getting smaller corresponds to a negative percentage)
plot(comps,Percents);
title('Area Difference Between First and Subsequent Frames')
xlabel('Frame Number')
ylabel('% Area Difference')
end
function [vid_Outlines,Areas_true] = Cell_Area_Func(Frame_num,pixscale,handles)
%Cell Area Function
%get folder and all .tif files from folder and check size of folder
frame_check = Frame_num;
[folder,~,~] = fileparts(frame_check);
a=dir([folder '/*.tif']);
out=size(a,1);

disp('Displaying Area Frames...')
axes(handles.plot_outline) %plot in bottom axes on GUI
areas = zeros(out);
vid_Outlines(out) = struct('cdata',[],'colormap',[]); %store data in structure
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
    BW1 = imfill(thinnedImage,'holes'); %fill outline
    imshow(BW1)
    areas(i) = nnz(BW1);
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
end


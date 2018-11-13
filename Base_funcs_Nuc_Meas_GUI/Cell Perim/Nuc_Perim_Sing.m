function [Perimeter] = Nuc_Perim_Sing(Sing_frame,pixscale,handles)
%Function for analyzing a single frame in the Nuclear_Measure_GUI
disp('Displaying Outline Frame...')
strang = convertStringsToChars(string(Sing_frame));

axes(handles.plot_outline) %plot to bottom axes on GUI
vid_Outlines(1) = struct('cdata',[],'colormap',[]); %saving outlines in data structure
perimeters = zeros(1);
for i=1:1
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
    perimeters(1) = pers.Perimeter;
    imshow(thinnedImage)
    vid_Outlines(1) = getframe;
end

Perimeter = ((perimeters(:,1)*(10^-6)*pixscale));
disp('Perimeter (um):')
disp(Perimeter)
%display Perimeter in edit box on GUI (sicne there was only one frame input)
end


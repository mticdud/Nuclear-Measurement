function [area] = Cell_Area_Sing(Frame_num,pixscale,handles)
%Cell Area Function for use in Nuclear_Measure_GUI
strang = convertStringsToChars(string(Frame_num));
disp('Displaying Outline Frame...')
axes(handles.plot_outline) %plot in bottom axes of GUI
I = imread(strang);
R = imtranslate(I,[1, 0]);
L = imtranslate(I,[-1,0]);
U = imtranslate(I,[0,1]);
D = imtranslate(I,[0,-1]);  
%read in file and translate one pixel up, down, left, right
RB = I & ~L;
LB = I & ~R;
UB = I & ~U;
LowB = I & ~D;
fullB = LB | RB | UB | LowB;
%Find outline by taking overlap of all
dilatedImage = imdilate(fullB,strel('disk',10));
thinnedImage = bwmorph(dilatedImage,'thin',inf); %dilate and thin outlines
imshow(thinnedImage)
BW1 = imfill(thinnedImage,'holes'); %fill outline
area = nnz(BW1)*(10^-6)*pixscale; %convert from pixels to um^2
disp('Area (um^2):')
disp(area)
end


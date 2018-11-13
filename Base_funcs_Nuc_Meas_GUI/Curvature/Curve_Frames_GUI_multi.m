function [Curve_Video] = Curve_Frames_GUI_multi(Frames_mask,Cell_Frames)
frame_check = Frames_mask;
[folder,~,~] = fileparts(frame_check);
Frames=dir([folder '/*.tif']);
out=size(Frames,1);

frame_check2 = Cell_Frames;
[folder2,~,~] = fileparts(frame_check2);
Frames2=dir([folder2 '/*.tif']);

ws = warning('off','all');
%warning(ws)  % Turn it back on.

Curve_Video(out) = struct('cdata',[],'colormap',[]);
for i=1:out
    first = {Frames(i).folder};
    second = {Frames(i).name};
    full = fullfile(first,second);
    strang = convertStringsToChars(string(full));
    
    first2 = {Frames2(i).folder};
    second2 = {Frames2(i).name};
    full2 = fullfile(first2,second2);
    strang2 = convertStringsToChars(string(full2));
    Curve_Frames_GUI_noax(strang,strang2)
    Curve_Video(i) = getframe;
end
end


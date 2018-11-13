function varargout = Nuclear_Measure_GUI(varargin)
% NUCLEAR_MEASURE_GUI MATLAB code for Nuclear_Measure_GUI.fig
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Nuclear_Measure_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Nuclear_Measure_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function Nuclear_Measure_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = Nuclear_Measure_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%Miscellaneous
%--------------------------------------------------------------------------
% UIWAIT makes Nuclear_Measure_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
axis off

%Listboxes:
%--------------------------------------------------------------------------
function lb_single_Callback(hObject, eventdata, handles)

function lb_single_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lb_stack_Callback(hObject, eventdata, handles)

function lb_stack_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lb_video_Callback(hObject, eventdata, handles)

function lb_video_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function lb_cell_Callback(hObject, eventdata, handles)

function lb_cell_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Pushbuttons:
%--------------------------------------------------------------------------
function pb_perim_Callback(hObject, eventdata, handles)
a = 1; %for use in slider
Sing_frame = get(handles.lb_single, 'String');
Stack_single = get(handles.lb_stack, 'String');
Cell = get(handles.lb_cell,'String');
cbvid = get(handles.cb_save_video, 'Value'); 
pixscale = str2double(get(handles.Pix_scale, 'String')); %check which inputs/selections
[Sing,Stack,Cellfrm] = Analysis_Choice(Sing_frame,Stack_single,Cell); %checks listboxes
if Stack == 1
    if cbvid == 1 %if input is a stack and save video is selected
        [vid_Outlines,Perimeters] = Perim_vid(Stack_single,pixscale,handles);
        dataa = struct('perim_frms',vid_Outlines,'Perimeters',Perimetersm,'a',a);
        hObject.UserData = dataa;
        %pass data into object handle for access in slider
    else %save video not selected
        [vid_Outlines,Perimeters] = Nuc_Perim_Func(Stack_single,pixscale,handles);
        dataa = struct('perim_frms',vid_Outlines,'Perimeters',Perimeters,'a',a);
        hObject.UserData = dataa;
        %pass data into object handle for access in slider
    end
end
if Sing == 1 %if input is single frame
    [Perimeter] = Nuc_Perim_Sing(Sing_frame,pixscale,handles);
    set(handles.Per_result,'String',Perimeter)
    %updates edit text box with result
end
    
function pb_perim_diff_Callback(hObject, eventdata, handles)
b = 1; %for use in slider
Sing_frame = get(handles.lb_single, 'String');
Stack_single = get(handles.lb_stack, 'String');
Cell = get(handles.lb_cell,'String');
cbvid = get(handles.cb_save_video, 'Value');
pixscale = str2double(get(handles.Pix_scale, 'String')); %check which inputs/selections
[Sing,Stack,Cellfrm] = Analysis_Choice(Sing_frame,Stack_single,Cell); %checks listboxes
if Sing == 1 %if input is single frame
    f = warndlg('Cannot select perimeter differences with a single frame input','Incompatible Selection Warning');
    disp(f)
    error('Cannot select perimeter differences with a single frame input')
end
if Stack == 1
    if cbvid == 1 %if input is a stack and save video is selected
        [vid_Outlines,Perdiffs] = Cell_Perdiff_Func_vid(Stack_single,pixscale,handles);
        data = struct('perimdiff_frms',vid_Outlines,'PerimDiffs',Perdiffs,'b',b);
        hObject.UserData = data;     
        %pass data into object handle for access in slider
    else %save video not selected
        [vid_Outlines,Perdiffs] = Cell_Perdiff_Func(Stack_single,pixscale,handles);
        data = struct('perimdiff_frms',vid_Outlines,'PerimDiffs',Perdiffs,'b',b);
        hObject.UserData = data;
        %pass data into object handle for access in slider
    end
end
    
function pb_area_reg_Callback(hObject, eventdata, handles)
c = 1; %for use in slider
Sing_frame = get(handles.lb_single, 'String');
Stack_single = get(handles.lb_stack, 'String');
Cell = get(handles.lb_cell,'String');
cbvid = get(handles.cb_save_video, 'Value');
pixscale = str2double(get(handles.Pix_scale, 'String')); %check which inputs/selections
[Sing,Stack,Cellfrm] = Analysis_Choice(Sing_frame,Stack_single,Cell); %checks listboxes
if Sing == 1 %if input is single frame
    [Areas_true] = Cell_Area_Sing(Sing_frame,pixscale,handles);
    set(handles.Area_result,'String',Areas_true)
    %updates edit text box with result
end
if Stack == 1
    if cbvid == 1 %if input is a stack and save video is selected
        [vid_Outlines,Areas_true] = Cell_Area_Func_vid(Stack_single,pixscale,handles);
        datac = struct('area_frms',vid_Outlines,'Areas',Areas_true,'c',c);
        hObject.UserData = datac;
        %pass data into object handle for access in slider
    else %save video not selected
        [vid_Outlines,Areas_true] = Cell_Area_Func(Stack_single,pixscale,handles);
        datac = struct('area_frms',vid_Outlines,'Areas',Areas_true,'c',c);
        hObject.UserData = datac;
        %pass data into object handle for access in slider
    end
end

function pb_area_diffs_Callback(hObject, eventdata, handles)
d = 1; %for use in slider
Sing_frame = get(handles.lb_single, 'String');
Stack_single = get(handles.lb_stack, 'String');
Cell = get(handles.lb_cell,'String');
cbvid = get(handles.cb_save_video, 'Value');
pixscale = str2double(get(handles.Pix_scale, 'String')); %check which inputs/selections
[Sing,Stack,Cellfrm] = Analysis_Choice(Sing_frame,Stack_single,Cell); %checks listboxes
if Sing == 1 %if input is single frame
    f = warndlg('Cannot select area differences with a single frame input','Incompatible Selection Warning');
    disp(f)
    error('Cannot select area differences with a single frame input')
end
if Stack == 1
    if cbvid == 1 %if input is a stack and save video is selected
        [area_frms,Percents] = Area_Diff_Vid(Stack_single,pixscale,handles);
        datad = struct('area_frms',area_frms,'Percents',Percents,'d',d);
        hObject.UserData = datad;
        %pass data into object handle for access in slider
    else %save video not selected
        [area_frms,Percents] = Cell_Area_Diff_Func(Stack_single,pixscale,handles);
        datad = struct('area_frms',area_frms,'Percents',Percents,'d',d);
        hObject.UserData = datad;
        %pass data into object handle for access in slider
    end
end


function pb_vol_reg_Callback(hObject, eventdata, handles)


function pb_vol_diffs_Callback(hObject, eventdata, handles)


function pb_strain_Callback(hObject, eventdata, handles)

function pb_curv_Callback(hObject, eventdata, handles)
h = 1; %for use in slider
Sing_frame = get(handles.lb_single, 'String');
Stack_single = get(handles.lb_stack, 'String');
Cell = get(handles.lb_cell,'String');
cbvid = get(handles.cb_save_video, 'Value'); %check which inputs/selections
[Sing,Stack,Cellfrm] = Analysis_Choice(Sing_frame,Stack_single,Cell); %checks listboxes
if Sing == 1 %if input is single frame
    Curve_Frames_GUI_sing(Sing_frame,Cell,handles)
end
if Stack == 1 %if input is a stack and save video is not selected
    [Curve_Video] = Curve_Frames_GUI_multi(Stack_single,Cell);
    datah = struct('Curve_frms',Curve_Video,'h',h);
    hObject.UserData = datah;
    %pass data into object handle for access in slider
if Stack && cbvid == 1 %if input is a stack and save video is selected
    [Curve_Video] = Curve_Frames_GUI_multi_vid(Stack_single,Cell);
    datah = struct('Curve_frms',Curve_Video,'h',h);
    hObject.UserData = datah;
    %pass data into object handle for access in slider
end
end

function pb_help_Callback(hObject, eventdata, handles)
f = msgbox({'-Use the input pushbuttons for single frames, single frame of separated stack, or video (.avi preferred)';...
             '-Enter your camera pixelscale in um/pix in the text box.';...
             '-Use the checkbox to save potential video results as a .avi file.';...
             '-Video results only available for stacks or video inputs and usually refer to the derived outlines or strain maps';...
             '-Single frame results will display in the edit textboxes towards the center of the GUI';...
             '-The inputs currently only take mask frames. Best compatability from Tsygankov software';...
             '-Use the reset button to reset selections in the listboxes'},'HELP');

function pb_reset_Callback(hObject, eventdata, handles)
%resets all listboxes and the save video checkbox
handles.lb_single.String = [];
handles.lb_stack.String = [];
handles.lb_cell.String = [];
set(handles.cb_save_video,'Value',0)
         
function pb_sing_frame_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.tif'); %brings up directory for file selection
if isequal(file,0)
   disp('User selected Cancel'); 
else
   disp(['User selected ', fullfile(path,file)]);
end
set(handles.lb_single,'Max',1,'Min',0); %only allow for one file selection
sing_frame = fullfile(path,file);
set(handles.lb_single, 'String', sing_frame);

function pb_inp_stack_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.tif'); %brings up directory for file selection
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
set(handles.lb_stack,'Max',1,'Min',0); %only allow for one file selection
stack_frame = fullfile(path,file);
set(handles.lb_stack, 'String', stack_frame);

function pb_cell_Callback(hObject, eventdata, handles)
[file,path] = uigetfile('*.tif'); %brings up directory for file selection
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
set(handles.lb_cell,'Max',1,'Min',0); %only allow for one file selection
stack_cell = fullfile(path,file);
set(handles.lb_cell, 'String', stack_cell);

%Edit Textboxes:
%--------------------------------------------------------------------------
function Per_result_Callback(hObject, eventdata, handles)

function Per_result_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Area_result_Callback(hObject, eventdata, handles)

function Area_result_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Volume_result_Callback(hObject, eventdata, handles)

function Volume_result_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Pix_scale_Callback(hObject, eventdata, handles)

function Pix_scale_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Checkbox
%--------------------------------------------------------------------------
function cb_save_video_Callback(hObject, eventdata, handles)
if (get(hObject,'Value') == get(hObject,'Max'))
	disp('Save Video as .avi Selected');
end


function slide_frames_Callback(hObject, eventdata, handles)
%loops through every time the slider is updated
Sing_frame = get(handles.lb_single, 'String');
Stack_single = get(handles.lb_stack, 'String');
Cell = get(handles.lb_cell,'String'); %get file names from listboxes
[A,B,C] = Handles_for_Plotting(Sing_frame,Stack_single,Cell); %values of 1 mean they have inputs
if A == 1
    [num_frame] = size_check(Sing_frame); %check folder for number of frames
end
if B == 1
    [num_frame] = size_check(Stack_single);
end
if C == 1
    [num_frame] = size_check(Video);
end
if B && C == 1
    [num_frame] = size_check(Stack_single);
end

maxNumberOfImages = num_frame;
set(handles.slide_frames, 'Min', 0, 'Max', maxNumberOfImages);
set(handles.slide_frames, 'SliderStep', [1/maxNumberOfImages,10/maxNumberOfImages]);
imageNumberSelected = int32(get(handles.slide_frames, 'Value'));
set(handles.stat_Frame_num, 'String', num2str(imageNumberSelected));
axes(handles.plot_outline)
%sets max numer of slider steps to be max number of images
%ensures proper slide steps and gets the frame number the slider is on
%also updates static text showing frame number while changing plotting to
%bottom axes on the GUI

%{
d = findobj('Tag','pb_area_diffs');
datad = d.UserData;
area_frames = datad.area_frms;
Percents = datad.Percents;
single_area_frames = area_frames(imageNumberSelected).cdata;
single_Perc_frames = Percents(imageNumberSelected);
imshow(single_area_frames)
axes(handles.plot_multi)
hold(handles.plot_multi,'on');
p = plot(imageNumberSelected,single_Perc_frames,'ro','MarkerSize',5);
drawnow
pause(.75);
hold(handles.plot_multi,'off');
delete(p)
%}

a = findobj('Tag','pb_perim');
b = findobj('Tag','pb_perim_diff');
c = findobj('Tag','pb_area_reg');
d = findobj('Tag','pb_area_diffs');
%e = findobj('Tag','pb_vol_reg');
%f = findobj('Tag','pb_vol_diffs');
%g = findobj('Tag','pb_strain');
h = findobj('Tag','pb_curv');
%identifying different GUI objects to get their handles

if isempty(a.UserData) == 0 %i.e. if Perimeter Analysis has been pressed
    dataa = a.UserData; %grab data from handles object
    picka = dataa.a; 
    if picka == 1 %if Perimeter Analysis has been pressed
        perim_frames = dataa.perim_frms; %grab video frames
        Pers = dataa.Perimeters; %grab data
        single_area_frames = perim_frames(imageNumberSelected).cdata; %video frame slider is on
        Pers_true = Pers(imageNumberSelected); %data number slider is on
        imshow(single_area_frames)
        axes(handles.plot_multi) %plot on upper axes of GUI
        hold(handles.plot_multi,'on'); %put plot hold on
        p = plot(imageNumberSelected,Pers_true,'ro','MarkerSize',5); %plot small marker where slide is
        drawnow
        pause(.75); %hold for .75 seconds then dissapear
        hold(handles.plot_multi,'off');
        delete(p)
    end
end

if isempty(b.UserData) == 0 %i.e. if Perimeter Difference Analysis has been pressed
    datab = b.UserData; %grab data from handles object
    pickb = datab.b;
    if pickb == 1 %i.e. if Perimeter Difference Analysis has been pressed
        perim_frames = datab.vid_Outlines; %grab video frames
        Pers = datab.Perdiffs; %grab data
        single_area_frames = perim_frames(imageNumberSelected).cdata; %video frame slider is on
        Pers_true = Pers(imageNumberSelected); %data number slider is on
        imshow(single_area_frames)
        axes(handles.plot_multi) %plot on upper axes of GUI
        hold(handles.plot_multi,'on'); %put plot hold on
        p = plot(imageNumberSelected,Pers_true,'ro','MarkerSize',5); %plot small marker where slide is
        drawnow
        pause(.75); %hold for .75 seconds then dissapear
        hold(handles.plot_multi,'off');
        delete(p)
    end
end

if isempty(c.UserData) == 0 %i.e. if Area Analysis has been pressed
    datac = c.UserData; %grab data from handles object
    pickc = datac.c;
    if pickc == 1 %i.e. if Area Analysis has been pressed
        area_frames = datac.area_frms; %grab video frames
        Areas_true = datac.Areas; %grab data
        single_area_frames = area_frames(imageNumberSelected).cdata; %video frame slider is on
        Ars = Areas_true(imageNumberSelected); %data number slider is on
        imshow(single_area_frames)
        axes(handles.plot_multi) %plot on upper axes of GUI
        hold(handles.plot_multi,'on'); %put plot hold on
        p = plot(imageNumberSelected,Ars,'ro','MarkerSize',5); %plot small marker where slide is
        drawnow
        pause(.75); %hold for .75 seconds then dissapear
        hold(handles.plot_multi,'off');
        delete(p)
    end
end
        
if isempty(d.UserData) == 0 %i.e. if Area Difference Analysis has been pressed
    datad = d.UserData; %grab data from handles object
    pickd = datad.d;
    if pickd == 1 %i.e. if Area Difference Analysis has been pressed
        area_frames = datad.area_frms; %grab video frames
        Percents = datad.Percents; %grab data
        single_area_frames = area_frames(imageNumberSelected).cdata; %video frame slider is on
        single_Perc_frames = Percents(imageNumberSelected); %data number slider is on
        imshow(single_area_frames)
        axes(handles.plot_multi) %plot on upper axes of GUI
        hold(handles.plot_multi,'on'); %put plot hold on
        p = plot(imageNumberSelected,single_Perc_frames,'ro','MarkerSize',5); %plot small marker where slide is
        drawnow
        pause(.75); %hold for .75 seconds then dissapear
        hold(handles.plot_multi,'off');
        delete(p)
    end
end

if isempty(h.UserData) == 0 %i.e. if Curvature Analysis has been pressed
    datah = h.UserData; %grab data from handles object
    pickh = datah.h;
    if pickh == 1 %i.e. if Curvature Analysis has been pressed
        axes(handles.plot_outline)
        Curved_frames = datah.Curve_frms; %grab video frames
        single_area_frames = Curved_frames(imageNumberSelected).cdata; %video frame slider is on
        imshow(single_area_frames) %display on bottom axes of GUI
    end
end


function slide_frames_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider_triangles_Callback(hObject, eventdata, handles)
%need to somehow get the number of boundary points in each frame
%maybe have an upper bound a few from the true max for leeway purposes?
Stack_single = get(handles.lb_stack, 'String');

new3 = imread('D:\Mitch_temp\curvebest.png');
BW = imbinarize(new3);
BWnew = mat2gray(BW);
I = rgb2gray(BWnew);
IBW = imbinarize(I);
invIBW = ~IBW;
BW2 = imfill(invIBW,'holes');
boundaries = bwboundaries(BW2);
boundsize = size(boundaries{1,1},1);
assignin('base','boundsize',boundsize)

maxNumberOfImages = boundsize-10;
set(handles.slider_triangles, 'Min', 0, 'Max', maxNumberOfImages);
set(handles.slider_triangles, 'SliderStep', [1/maxNumberOfImages,10/maxNumberOfImages]);
imageNumberSelected = int32(get(handles.slider_triangles, 'Value'));
assignin('base','imgnum',imageNumberSelected)
set(handles.stattxt_triang, 'String', num2str(imageNumberSelected));
axes(handles.plot_multi)
[curvatures] = Triangle_Slider(Stack_single,imageNumberSelected);

function slider_triangles_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

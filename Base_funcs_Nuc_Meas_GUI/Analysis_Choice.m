function [A,B,C] = Analysis_Choice(Sing_frame,Stack_single,Cell)
%Function for determining selection in Nuclear_Measure_GUI
[A,B,C] = deal(0,0,0); %initialize A,B and C
%Check if input listboxes on GUI are empty or filled
if isempty(Sing_frame) == 0
    A = 1;
end
if isempty(Stack_single) == 0
    B = 1;
end
if isempty(Cell) == 0
    C = 1;
end
%Raise warnings if multiple boxes are filled other than image stack and
%cell images
if A && B && C == 1
    f = warndlg('Only able to select one option for analysis','Incompatible Selection Warning');
    disp(f)
    error('Only able to select one input option for analysis')
end
if A && B == 1
    f = warndlg('Only able to select one option for analysis','Incompatible Selection Warning');
    disp(f)
    error('Only able to select one input option for analysis')
end
if A && C == 1
    f = warndlg('Only able to select one option for analysis','Incompatible Selection Warning');
    disp(f)
    error('Only able to select one input option for analysis')
end
end


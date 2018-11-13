function [A,B,C] = Handles_for_Plotting(Sing_frame,Stack_single,Cell)
%Function used in Nuclear_Measure_GUI to get handles from textboxes to
%enable appropriate dynamic plotting of track points on the plot
[A,B,C] = deal(0,0,0);
if isempty(Sing_frame) == 0
    A = 1;
end
if isempty(Stack_single) == 0
    B = 1;
end
if isempty(Cell) == 0
    C = 1;
end
end


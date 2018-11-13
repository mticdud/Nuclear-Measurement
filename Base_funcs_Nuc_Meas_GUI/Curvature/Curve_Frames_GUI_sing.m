function Curve_Frames_GUI_sing(Frames,Cell_Frames,handles)
%Function used for analyzing curvature in Nuclear_Measure_GUI
%inputs are 
strangmask = convertStringsToChars(string(Frames)); %convert to character
strangcell = convertStringsToChars(string(Cell_Frames));
GrayImg = imread(strangmask); %read in files
Cell = imread(strangcell);
BWimg = imbinarize(GrayImg); %binarize mask image
boundaries = bwboundaries(BWimg); %find boundaries of mask image
boundsize = size(boundaries,1); %find size of boundary data

x = cell(boundsize);
y = cell(boundsize);
for i=1:boundsize
    x{i} = boundaries{1}(:, 2); %2 true
    y{i} = boundaries{1}(:, 1); %1 true
end

start1 = 5; %first starting x point
end1 = 14; %first ending x point
n = 128; %half of 256 to define custom colormap
%colormap set up so white = 0, further red is further positive and further 
%blue is further negative
myColorMap = [linspace(0,1,n)' linspace(0,1,n)', ones(n,1); ones(n,1) linspace(1,0,n)' linspace(1,0,n)'];
Colorsize = size(myColorMap,1);

rounded = round((length(x{1})-19)/5)*5; %round length of boundaries to the closest
%multiple of 5 (best solution I have right now for varying amounts of boundary points)
jumps = (rounded-start1)/10; %number of jumps depends on start
starts = round(linspace(start1,rounded,jumps+1)); %list of starts based on
%number of jumps and size of boundaries (included within jumps)
ends = round(linspace(end1,rounded+9,jumps+1)); %list of ends based on
%number of jumps and size of boundaries (included within jumps)

startnew = starts;
endnew = ends;
curvint = zeros(length(x{1})); %initialize
xint = x{1};
yint = y{1};
%cycles through selections of point series and fits a second degree
%polynomial to the points. The coefficients can then be pulled as curvature
%values. Needs to be i-4 because the start is 5 (would be array error if bigger)
for k=1:jumps+1
    for i=startnew(k):endnew(k)
        coefficients = polyfit(xint((i-4):(i+4)), yint((i-4):(i+4)), 2);
        curvint(i) = coefficients(1);
    end
end

curvatures = curvint(:,1);
curvatures(abs(curvatures) > 10) = .01;
curvatures(curvatures < -.1) = -.1;
curvatures(curvatures > .1) = .1;
curvatures(219:end) = curvatures(219:end)*-1;

axes(handles.plot_outline)
imshow(Cell); %or BWimg
hold on;
drawnow;
numcurv = length(curvatures);
minC = min(curvatures);
maxC = max(curvatures);
range = maxC-minC;

Indtest = zeros(numcurv);
for i=1:numcurv
    Indtest(i) = round(Colorsize*(curvatures(i)-minC)/range);
end

Indtestsint = Indtest(:,1);
Indtests = Indtestsint;

for j=1:numcurv
    if Indtests(j) == 0
        Indtests(j) = 1;
    end
    if isnan(Indtests(j))
        Indtests(j) = 1;
    end
    Color = myColorMap(Indtests(j),:);
    plot(xint(j), yint(j), '.', 'MarkerSize', 7, 'Color', Color);
end

end



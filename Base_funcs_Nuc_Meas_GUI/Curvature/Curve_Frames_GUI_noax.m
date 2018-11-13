function Curve_Frames_GUI_noax(Frames_mask,Cell_Frames)
%Function used for analyzing curvature in Nuclear_Measure_GUI

strangmask = convertStringsToChars(string(Frames_mask));
strangcell = convertStringsToChars(string(Cell_Frames));
GrayImg = imread(strangmask);
Cell = imread(strangcell);
BWimg = imbinarize(GrayImg);
boundaries = bwboundaries(BWimg);
boundsize = size(boundaries,1);

x = cell(boundsize);
y = cell(boundsize);
for i=1:boundsize
    x{i} = boundaries{1}(:, 2);
    y{i} = boundaries{1}(:, 1);
end

start1 = 5;
end1 = 14;
n = 128;
myColorMap = [linspace(0,1,n)' linspace(0,1,n)', ones(n,1); ones(n,1) linspace(1,0,n)' linspace(1,0,n)'];
Colorsize = size(myColorMap,1);

rounded = round((length(x{1})-19)/5)*5;
jumps = (rounded-5)/10;
starts = round(linspace(start1,rounded,jumps+1));
ends = round(linspace(end1,rounded+9,jumps+1));

startnew = starts;
endnew = ends;
curvint = zeros(length(x{1}));
xint = x{1};
yint = y{1};
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



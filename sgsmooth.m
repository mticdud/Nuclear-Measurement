function [smoothedsg] = sgsmooth(par)
%Smoothing with Savitzky-Golay filter for use in other scripts
[row,col] = size(par);
smoothysg = smooth(par(:),'sgolay');
smoothedsg = reshape(smoothysg,row,col);
end


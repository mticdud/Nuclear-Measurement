function [smoothed] = gensmooth(par)
%function for smoothing data without reshaping in normal scripts
[row,col] = size(par);
smoothint = smooth(par(:),3);
smoothed = reshape(smoothint,row,col);
end


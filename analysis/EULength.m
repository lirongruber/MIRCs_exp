% Euclidean arc length of a curve:
% output:
% len = total arc length
% ds = vector of distances
% cumlen  = cummulative arc length along the curve

function [len,ds,cumlen] = EULength(m)
ds = EUDist(m(2:end,:),m(1:end-1,:));
len = sum(abs(ds));
cumlen = cumsum(abs(ds));
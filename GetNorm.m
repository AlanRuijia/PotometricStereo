function [ res ] = GetNorm( x,y )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    line = zeros(2,1);
    midx = (x(1) + x(2))/2;
    midy = (y(1) + y(2))/2;
    L  = polyfit(x,y,1);
    line(1) = 1/L(1);
    line(2) = midy - line(1) * midx;
    res = line;
end


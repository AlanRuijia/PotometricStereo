function [ center, radius ] = GetCircle( pic )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    NewPic(pic,'circle');
    [x,y] = ginput(3);
    [center,radius] = calcCircle([x(1),y(1)],[x(2),y(2)],[x(3),y(3)]);
    
end


function [ res] = AllDepx( T1,resx,resy )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
depth = zeros(size(T1));
[i,j] = size(T1)
init = 0;
for x = 1:i/2
    for y = 1:j
        depth(2*x-1,y) = resx(2*x-1,y) + init;
        init = depth(2*x-1,y);
    end
    depth(2*x,j) = resy(2*x,j) + init;
    init = depth(2*x,j);
    for y = j:-1:1
        depth(2*x,y) = -1*resx(2*x,y) + init;
        init = depth(2*x,y);
    end
    if (2*x+1 < i)
        depth(2*x+1,1) = resy(2*x+1,1) + init;
        init = depth(2*x+1,1);  
    end
end
res = depth;
end


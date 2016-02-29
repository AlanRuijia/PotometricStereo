function [ res ] = GetE( I1,I2 )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[i,j] = size(I1);
E = zeros(i,j);
for x = 1:i
    for y = 1:j
        if (I1(x,y)~=0 && I2(x,y)~=0 )
            E(x,y) = double(I2(x,y))/double(I1(x,y));
        end
    end
end
res = E;

end


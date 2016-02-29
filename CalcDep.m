function res = CalcDep( col )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
L = length(col);
add = 0;
D = zeros(size(col));
for i = 1: L
    D(i) = col(i) + add;
    add = add + col(i);
end
res = D;


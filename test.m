close all
scale = 1/200;
min_value = 5/255;
max_value = 255/10;
range_least = round(min_value/scale);
range_large = round(max_value/scale);
center = [319,295.6306];
r = 138.2955;

a = imread('./PI/sphere-lamp1.tif');
b = imread('./PI/sphere-lamp2.tif');
c = imread('./PI/sphere-lamp3.tif');

img1 = double(rgb2gray(a))/255;
img2 = double(rgb2gray(b))/255;
img3 = double(rgb2gray(c))/255;
pos = zeros(468,367);


for i = 1:468
    for j = 1:637
        if ((j-center(1))^2+(i-center(2))^2 < r^2)
            pos(i,j) = 1;
        else
            pos(i,j) = 0;
        end
    end
end

[y_graph,x_graph] = find(pos == 1);

z_graph = -sqrt(r^2-(x_graph-center(1)).^2-(y_graph-center(2)).^2);

P = zeros(range_large,range_large,2);
Q = zeros(range_large,range_large,2);

P2 = ((x_graph-center(1))./(r-z_graph)); 
Q2 = ((y_graph-center(2))./(r-z_graph));

index = sub2ind(size(img1), y_graph, x_graph);
dataImg1 = min(max(min_value,img1(index)),max_value);
dataImg2 = min(max(min_value,img2(index)),max_value);
dataImg3 = min(max(min_value,img3(index)),max_value);

E1_E2 = round(dataImg1./dataImg2/scale);
E2_E3 = round(dataImg2./dataImg3/scale);
index3_ones = ones(size(E1_E2));
index3_twos = ones(size(E1_E2))*2;

index_one = sub2ind(size(P), E1_E2, E2_E3,index3_ones);
index_two = sub2ind(size(P), E1_E2, E2_E3,index3_twos);

for i = 1:size(index_one)
     if(P(index_one(i)) == 0)
        P(index_one(i)) = P2(i);
     elseif (P(index_two(i)) == 0)
         tempCrti = (P(index_one(i))-P2(i))/P(index_one(i));
             if(abs(tempCrti) > 0.5)
                P(index_two(i)) = P2(i);
             end
     else
%          tempCrti1 = (P(index_one(i))-P2(i))/P(index_one(i));
%          tempCrti2 = (P(index_two(i))-P2(i))/P(index_two(i));
%          if(tempCrti1 > 0.5 && tempCrti2 > 0.5)
%              disp('Error!');
%              disp(P(index_one(i)));
%              disp(P(index_two(i)));
%              disp(P2(i));
%          end
     end
end

for i = 1:size(index_one)
    if(Q(index_one(i)) == 0)
        Q(index_one(i)) = Q2(i);
    elseif (Q(index_two(i)) == 0)
        tempCrti = (Q(index_one(i))-Q2(i))/Q(index_one(i));
        if(abs(tempCrti) > 0.5)
           Q(index_two(i)) = Q2(i);
        end
    else
%          tempCrti1 = (Q(index_one(i))-Q2(i))/Q(index_one(i));
%          tempCrti2 = (Q(index_two(i))-Q2(i))/Q(index_two(i));
%          if(tempCrti1 > 0.5 && tempCrti2 > 0.5)
%              disp('Error!');
%              disp(Q(index_one(i)));
%              disp(Q(index_two(i)));
%              disp(Q2(i));
%          end
    end
end
[xi,yi] = find(P(:,:,1)>0);
s = size(P);
index1 = sub2ind(s(1:2), xi, yi);
vx = P(index1);
F = scatteredInterpolant(xi,yi,vx);
vy = Q(index1);
F1 = scatteredInterpolant(xi,yi,vy);


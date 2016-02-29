close all
%[center,radius] = GetCircle('PI/sphere-lamp1.tif')
center = [326,299];
radius = 143;
flag = 3;

image1 = imread('PI/sphere-lamp1.tif');
I1 = rgb2gray(image1);
image2 = imread('PI/sphere-lamp2.tif');
I2 = rgb2gray(image2);
image3 = imread('PI/sphere-lamp3.tif');
I3 = rgb2gray(image3);

E12 = GetE(I1,I2);
E23 = GetE(I2,I3);

E12 = round(255*E12);
E23 = round(255*E23);
size(I1);
[i,j] = size(I1);
TMax = 6502;
TX = zeros(TMax,TMax);
TY = TX;
TX1 = TX;
TY1 = TX;
for x = 1:i
    for y = 1:j
        xx = 0;
        yy = 0;
        
        if (((x - center(1))^2+(y-center(2))^2 )<=radius^2)
            z = sqrt(radius^2 - ((x - center(1))^2+(y-center(2))^2));
            if (E12(x,y)>6502)
                xx = 6502;
            end
            if (E23(x,y)>6502)
                yy = 6502;
            end

            if (xx == 0)
                xx = E12(x,y);
            end
            if (yy == 0)
                yy = E23(x,y);
            end
            Xres = (double(x - center(1))/radius)/(1-(z/radius));
            Yres = (double(y - center(2))/radius)/(1-(z/radius));
            if (xx~=0 && yy ~=0) 
                %TX(xx,yy) = x/(radius-z);
                %TY(xx,yy) = y/(radius-z);
                if(TX(xx,yy) ~= 0)
                    if ((abs(TX(xx,yy)-Xres)/abs(TX(xx,yy)))>0.1)
                        TX1(xx,yy) = Xres;
                        TY1(xx,yy) = Yres;
                    end
                end
                if (TX(xx,yy) == 0)
                    TX(xx,yy) = Xres;
                    TY(xx,yy) = Yres;
                end
            end
        end
    end
end

[xi,yi] = find(TX>0);
index1 = sub2ind(size(TX), xi, yi);
vx = TX(index1);
F = scatteredInterpolant(xi,yi,vx);
vy = TY(index1);
F1 = scatteredInterpolant(xi,yi,vy);

lb = 10;
if (flag == 1)
    image4 = imread('PI/ellipsoid-lamp1.tif');
    image5 = imread('PI/ellipsoid-lamp2.tif');
    image6 = imread('PI/ellipsoid-lamp3.tif');
elseif (flag == 2)
    image4 = imread('PI/cone2-lamp1.tif');
    image5 = imread('PI/cone2-lamp2.tif');
    image6 = imread('PI/cone2-lamp3.tif');
elseif (flag == 3)
    image4 = imread('PI/cone-lamp1.tif');
    image5 = imread('PI/cone-lamp2.tif');
    image6 = imread('PI/cone-lamp3.tif');
elseif (flag == 4)
    image4 = imread('PI/cylinder-lamp1.tif');
    image5 = imread('PI/cylinder-lamp2.tif');
    image6 = imread('PI/cylinder-lamp3.tif');
elseif (flag == 5)
    image4 = imread('PI/hex1-lamp1.tif');
    image5 = imread('PI/hex1-lamp2.tif');
    image6 = imread('PI/hex1-lamp3.tif');
elseif (flag == 6)
    image4 = imread('PI/hex2-lamp1.tif');
    image5 = imread('PI/hex2-lamp2.tif');
    image6 = imread('PI/hex2-lamp3.tif');
elseif (flag == 0)
    image4 = imread('PI/sphere-lamp1.tif');
    image5 = imread('PI/sphere-lamp2.tif');
    image6 = imread('PI/sphere-lamp3.tif');
end
T1 = rgb2gray(image4);
T2 = rgb2gray(image5);
T3 = rgb2gray(image6);

TE12 = GetE(T1,T2);
TE23 = GetE(T2,T3);
TE12 = min(round(255*TE12),6502);
TE23 = min(round(255*TE23),6502);

resx = zeros(size(T1));
resy = zeros(size(T1));
resxq = resx;
resyq = resx;
resz = resx;
[i,j] = size(T1);
p = resx;
q = resy;
for x = 1:i
    for y = 1:j
        if (T1(x,y)>lb && T2(x,y)>lb && T3(x,y)>lb)
            BX = F(TE12(x,y),TE23(x,y));
            BY = F1(TE12(x,y),TE23(x,y));
            if (TX1(TE12(x,y),TE23(x,y))~=0)
                if (y > 1)
                if (abs(BX -  resx(x,y-1))/abs(resx(x,y-1)) > 0.1)
                    BX = TX1(TE12(x,y),TE23(x,y));
                    BY = TY1(TE12(x,y),TE23(x,y));
                end
                end
            end
            %BX = TX(TE12(x,y),TE23(x,y));
            %BY = TY(TE12(x,y),TE23(x,y));
            sum = 1+ BX^2 + BY^2;
            sz = (-1 + BX^2 + BY^2)/sum;
            resxq(x,y) = 2 * BX/(sum);
            resyq(x,y) = 2 * BY/(sum);
            resx(x,y) = -resxq(x,y);
            resy(x,y) = -resyq(x,y);
            resz(x,y) = sz;
        end
    end
end
resx = flipud(resx);
resy = flipud(resy);
figure
quiver(flipud(resyq),flipud(resxq))
%resx(:,1:100) = 0;
%resy(:,1:100) = 0;
temp = resx;
resx = resy;
resy = temp;

[i,j] = size(T1);
dx = zeros(size(T1));
dy = dx;
init = 0;
depth = AllDepx( T1,resx,resy );
deptht = AllDepxit( T1,resx,resy );
for x = 1:i
    dx(x,:) = CalcDep(resx(x,:));
end 
figure
surf(depth + deptht)
figure
surf(dx)


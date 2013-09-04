function [ width,vh,vv ] = getBlurWidth( im,r,c,nvh,nvv )
%GETBLURWIDTH Summary of this function goes here
%   Detailed explanation goes here
%   width: return the blur width at the edge
%   im:    the image
%   r,c:   locate the center pixel
%   nvh,nvv: 2 components of the normal vector at the objective pixel

%todo: 1.prepair data needed later
%todo: 2.deal with the condition that the nvh == 0,then return
%todo: 3.divide it into 2 directions
%todo: 4.get the correct and rational element value
%todo: 5.stop exploring at some conditions.

[m,n] = size(im);
widthPosOrt = 1;  % set a default minimum width at the positive orientation,supposing zero at the left-up corner
widthNegOrt = 1;  % set a default minimum width at teh negative orientation....
maxWidth = 30; % Temporarily,we set the possible maximum width to 30

vh = nvh;vv = nvv;
if nvh == 0
    for i = 1:maxWidth
        if r+i > m
            break;
        end
        if i == 1 && im(r+i,c)>im(r,c) %do the calibration of 1 pixel, if there exists some error
            continue;
        end
        if im(r+i,c) >= im(r+i-1,c)
            break;
        end
        if im(r+i,c)<0.04  % 0.04 is the minimum gray level we can catch
            break;
        end
        widthPosOrt = widthPosOrt + 1;
    end
    for i = -1:-1:-maxWidth
        if r+i < 0
            break;
        end
        if i == -1 && im(r+i,c) > im(r,c)
            continue;
        end
        if im(r+i,c) >= im(r+i+1,c)
            break;
        end
        if im(r+i,c) < 0.04
            break;
        end
        widthNegOrt = widthNegOrt + 1;
    end
else    
    if nvh<0
        nvh = 1;nvv = nvv/nvh;
    end
    value1 = im(r,c);
    for i = 1:maxWidth
        if c+i > n
            break;
        end
        floor_value = im(r+floor(i*nvv),c+i);
        ceil_value = im(r+floor(i*nvv)+1,c+i);
        weight_floor_value = (r+floor(i*nvv)+1) - (r+i*nvv);
        weight_ceil_value = (r+i*nvv) - (r+floor(i*nvv));
        value2 = floor_value*weight_floor_value + ceil_value*weight_ceil_value;
        if i == 1 && value2 > value1  %do the calibration of 1 pixel, in case of error
            value1 = value2;
            continue;
        end
        if value2 >= value1
            break;
        end
        if value2 < 0.04
            break;
        end
        value1 = value2;
        widthPosOrt = widthPosOrt + 1;
    end
    
    value1 = im(r,c);
    for i = -1:-1:-maxWidth
        if c+i < 0
            break;
        end
        floor_value = im(r+floor(i*nvv),c+i);
        ceil_value = im(r+floor(i*nvv)+1,c+i);
        weight_floor_value = (r+floor(i*nvv)+1) - (r+i*nvv);
        weight_ceil_value = (r+i*nvv) - (r+floor(i*nvv));
        value2 = floor_value*weight_floor_value + ceil_value*weight_ceil_value;
        if i == -1 && value2 > value1  %do the calibration of 1 pixel, in case of error
            value1 = value2;
            continue;
        end
        if value2 >= value1
            break;
        end
        if value2 < 0.04
            break;
        end
        value1 = value2;
        widthNegOrt = widthNegOrt + 1;
    end
end
width = max(widthPosOrt,widthNegOrt);
figure(1),hold on,quiver(c,r,vh,vv,width);
if widthPosOrt < widthNegOrt
    vh = -vh;
    vv = -vv;
end
figure(1),hold on,quiver(c,r,vh,vv,width);
end


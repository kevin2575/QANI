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
widthPosOrt = 1;  % set a default minimum width at the positive orientation(the right half plane and suppose zero at the left-up corner)
widthNegOrt = 1;  % set a default minimum width at teh negative orientation....
maxWidth = 30; % Temporarily,we set the possible maximum width to 30

vh = nvh;vv = nvv;
if abs(nvh) < 1e-3
    nvh = 0;
    for i = 1:maxWidth
        if r+i > m
            break;
        end
        if (i <= 3) && im(r+i,c)>im(r+i-1,c) %do the calibration of 1 or 2 pixels, if there exists some error
            r = r+1;
            continue;
        end
        if im(r+i,c) > im(r+i-1,c)
            break;
        end
        if im(r+i,c)<0.04  % 0.04 is the minimum gray level we can catch
            break;
        end
        widthPosOrt = widthPosOrt + 1;
    end
    for i = -1:-1:-maxWidth
        if r+i < 1
            break;
        end
        if i >= -3 && im(r+i,c) > im(r,c)
            continue;
        end
        if im(r+i,c) > im(r+i+1,c)
            break;
        end
        if im(r+i,c) < 0.04
            break;
        end
        widthNegOrt = widthNegOrt + 1;
    end
else
    nvv = nvv/nvh;
    nvh = 1;
    
    value1 = im(r,c);
    t = norm([1,nvv]);
    for i = 1:maxWidth
        dh = i/t;dv=i*nvv/t;
        ind_lu_ver = r + floor(dv);  ind_lu_hor = c + floor(dh);
        ind_ru_ver = r + floor(dv);  ind_ru_hor = c + floor(dh) + 1;
        ind_ld_ver = r + floor(dv)+1;ind_ld_hor = c + floor(dh);
        ind_rd_ver = r + floor(dv)+1;ind_rd_hor = c + floor(dh) + 1;
        if ind_lu_ver < 1 || ind_lu_hor < 1 || ind_rd_ver > m || ind_rd_hor > n
            break;%exceed boundary!!!!!!!!!!!
        end
        lu = im(ind_lu_ver,ind_lu_hor);
        ru = im(ind_ru_ver,ind_ru_hor);
        ld = im(ind_ld_ver,ind_ld_hor);
        rd = im(ind_rd_ver,ind_rd_hor);
        value2 = (lu+ru+ld+rd)/4;
        
        if i <= 3 && value2 > value1  %do the calibration of 1~3 pixels, in case of error
            value1 = value2;
            continue;
        end
        if value2 > value1
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
        dh = i/t;dv=i*nvv/t;
        ind_lu_ver = r + floor(dv);  ind_lu_hor = c + floor(dh);
        ind_ru_ver = r + floor(dv);  ind_ru_hor = c + floor(dh) + 1;
        ind_ld_ver = r + floor(dv)+1;ind_ld_hor = c + floor(dh);
        ind_rd_ver = r + floor(dv)+1;ind_rd_hor = c + floor(dh) + 1;
        if ind_lu_ver < 1 || ind_lu_hor < 1 || ind_rd_ver > m || ind_rd_hor > n
            break;%exceed boundary!!!!!!!!!!!
        end
        lu = im(ind_lu_ver,ind_lu_hor);
        ru = im(ind_ru_ver,ind_ru_hor);
        ld = im(ind_ld_ver,ind_ld_hor);
        rd = im(ind_rd_ver,ind_rd_hor);
        value2 = (lu+ru+ld+rd)/4;
        
        if i >= -3 && value2 > value1  %do the calibration of 1 pixel, in case of error
            value1 = value2;
            continue;
        end
        if value2 > value1
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
%figure(1),hold on,quiver(c,r,vh,vv,width);
if widthPosOrt > widthNegOrt && vh < 0
    vh = -vh;
    vv = -vv;
end
if widthPosOrt < widthNegOrt && vh > 0
    vh = -vh;
    vv = -vv;
end
if abs(nvh) < 1e-3
    if widthPosOrt > widthNegOrt
        vv = abs(vv);
    else
        vv = -abs(vv);
    end
end
%figure(1),hold on,quiver(c,r,vh,vv,width);
end


clear,clc
%todo:1. prepair the data to be used later
%todo:2. compute the orientation of gradient
%todo:3. compute the gradient

pth = 'D:/Backup/我的文档/MATLAB/images/gblur';d = dir([pth '/*.bmp']);
pth_gPb = 'D:/Backup/我的文档/MATLAB/images/gblur_gPb';d_gPb = dir([pth_gPb '/*.bmp']);
pth_ucm = 'D:/Backup/我的文档/MATLAB/images/gblur_gPb_ucm';d_ucm = dir([pth_ucm '/*.bmp']);
len = length(d_gPb);
k = 4;%局部邻域边长
if len~=length(d_ucm)
    error('size not matched!');%!!!!!!!!!!!!!
end

for i = 1:len
    imName = [pth '/img' num2str(i) '.bmp'];
    im = double(rgb2gray(imread(imName)))/255;
    im_gPb = double(imread([pth_gPb '/img' num2str(i) '.bmp']))/255;    
    im_ucm = double(imread([pth_ucm '/img' num2str(i) '.bmp']))/255;
    [m,n] = size(im_ucm);
    if (size(im,3)~=1 || min(im(:))<0 || max(im(:))>1 ||...
        size(im_gPb,3)~=1 || min(im_gPb(:))<0 || max(im_gPb(:))>1 || ...
        size(im_ucm,3)~=1 || min(im_ucm(:))<0 || max(im_ucm(:))>1)
        error('data type not appropriate!');%!!!!!!!!!!!!!!!!!
    end
    if ~strcmp([pth '/img' num2str(i) '.bmp'] , imName)
        error('file sequence error');%!!!!!!!!!!!!!!
    end
    
    s = 0;
    num = 0;
    for r = k+1:m-k
        for c = k+1:n-k
            if im_ucm(r,c)<0.7
                continue;
            end
            num=num+1;
            rec = im_ucm(r-k:r+k,c-k:c+k);
            %show rec!!!
            thresh = (max(rec(:))-min(rec(:)))/2;
            [rs,cs] = find(rec>thresh);
            fitresult = createLinearFit(rs,cs);
            if fitresult.p1 == 0
                error('ratio not appliable');%!!!!!!!!
            end
            slope_ratio = -1/double(fitresult.p1);
            for x = r+1:r+30
                y = slope_ratio*x - slope_ratio*r+c;
                y = floor(y);
                value(x-r+1) = im_gPb(x,y);
                if value(x-r+1)>value(x-r)
                    break;
                end
            end
            if im_gPb(r,c)-im_gPb(x,y)<0
                %error('slope top must be bigger than bottom');%!!!!!!!!
            end
            s = s+(im_gPb(r,c)-im_gPb(x,y))/(sqrt(1+slope_ratio^2)*(x-r));
        end
    end
    if num==0
        error('divided by zero');%!!!!!!!!
    end
    score(i) = s/num;
end
load dmos145.mat
plot(score,dmos145,'*')
%score = 50 - score;
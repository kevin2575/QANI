%todo: 1.prepair data needed later
%todo: 2.read the image,and .mat, get the levels,compute the correlation
%        in rectangles
%todo: 3.plot the result

clear,clc;
pth = 'F:/zzr/images/gblur';
d = dir([pth '/*.bmp']);
pth_seg = 'F:\zzr\images\gblur_seg';
d_seg = dir([pth_seg '/*.mat']);
len = length(d);
if len~=length(d_seg)
    error('size not matched!');%!!!!!!!!!!!!!
end

h = fspecial('gaussian',6,4);
for i = 1:len
    imName = [pth '/img' num2str(i) '.bmp'];
    im = imread(imName);
    im = double(rgb2gray(im))/255;
    im_blur = imfilter(im,h);
    im_seg_name = [pth_seg '/img' num2str(i) '.mat'];
    load(im_seg_name);
    im_seg = labels;
    if ~size(im,3)==1 || max(im(:))>1 || min(im(:))<0
        error('not appropriate data type');%!!!!!!!!!!!!
    end
    if ~strcmp([pth '/img' num2str(i) '.bmp'],imName) || ...
            ~strcmp([pth_seg '/img' num2str(i) '.mat'],im_seg_name)
        error('file not matched');%!!!!!!!!!!!!!!!!!
    end
    if min(im_seg(:)) == 0
        nSegs = length(unique(im_seg))-1;
    else
        nSegs = length(unique(im_seg));
    end
    s = 0;
    num = 0;
    for j = 1:nSegs
        [rows,cols] = find(im_seg==j);
        minrow = min(rows);mincol = min(cols);
        maxrow = max(rows);maxcol = max(cols);
        %imshow(selected),pause(1);
        if length(rows)<600
            continue;
        end
        ori = im(minrow:maxrow,mincol:maxcol);
        res = im_blur(minrow:maxrow,mincol:maxcol);
        s = s + blurPerception(ori);
        num = num+1;
    end
    score(i) = s/num;
    if isnan(score(i))
        error('nan');%!!!!!!!!!!!
    end
    sc(i) = corr2(im,im_blur);
    sprintf('%s,%d pieces,corr:%f' ,imName,nSegs,score(i))
end
score = 100 - score;
load dmos145;
figure(1),plot(score,dmos145,'*');
figure(2),plot(sc,dmos145,'*');
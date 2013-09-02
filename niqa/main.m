%todo: 1.prepair data needed later
%todo: 2.read the image,and .mat, get the levels,compute the correlation
%        in rectangles
%todo: 3.plot the result

clear,clc;
pth = 'F:/zzr/images/gblur';
d = dir([pth '/*.bmp']);
pth_ucm = 'F:\zzr\images\gblur_gPb_ucm';
d_seg = dir([pth_ucm '/*.bmp']);
len = length(d);
if len~=length(d_seg)
    error('size not matched!');%!!!!!!!!!!!!!
end
k = 5;

h = fspecial('gaussian',6,4);
for i = 1:len
    imName = [pth '/img' num2str(i) '.bmp'];
    im = imread(imName);
    im = double(rgb2gray(im))/255;
    im_blur = imfilter(im,h);
    im_ucm_name = [pth_ucm '/img' num2str(i) '.bmp'];
    im_ucm = imread(im_ucm_name);
    im_ucm = double(im_ucm)/255;
    [m,n] = size(im_ucm);
    s = 0;w = 0;
    for r = k+1:m-k
        for c = k+1:n-k
            if im_ucm(r,c)<0.6
                continue;
            end
            rec_im = im(r-k:r+k,c-k:c+k);
            rec_im_blur = im_blur(r-k:r+k,c-k:c+k);
            s = s + corr2(rec_im,rec_im_blur)*im_ucm(r,c);
            w = w+im_ucm(r,c);
        end
    end
    score(i) = s/w;

    if isnan(score(i))
        score(i) = corr2(im,im_blur);
        sprintf('%d : nan',i)
        %error('nan');%!!!!!!!!!!!
    end
    %sc(i) = corr2(im,im_blur);
    sprintf('%s,corr:%f' ,imName,score(i))
end
load dmos145;
figure(1),plot(score,dmos145,'*');
k = createExpFit(score,dmos145);
y = k.a*exp(k.b*score)+k.c*exp(k.d*score);
corr2(y,dmos145)
%figure(2),plot(sc,dmos145,'*');
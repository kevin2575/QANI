clear,clc
pth = 'D:/Backup/我的文档/MATLAB/images/gblur';
d = dir([pth '/*.bmp']);
pth_gPb = 'D:/Backup/我的文档/MATLAB/images/gblur_gPb';
d_gPb = dir([pth_gPb '/*.bmp']);
pth_ucm = 'D:/Backup/我的文档/MATLAB/images/gblur_gPb_ucm';
d_ucm = dir([pth_ucm '/*.bmp']);
n = length(d_gPb);
%check point
if n~=length(d_ucm)
    error('size not matched!');
end

k=8;
h = fspecial('gaussian',6,4);
for i = 1:n
    %im = imread([pth '/img' num2str(i) '.bmp']);
    im_gPb = double(imread([pth_gPb '/img' num2str(i) '.bmp']))/255;
    im = double(rgb2gray(imread([pth '/img' num2str(i) '.bmp'])))/255;
    if size(im,3)~=1 || min(im(:))<0 || max(im(:))>1
        error('im data type not appropriate!');
    end
    im_ucm = double(imread([pth_ucm '/img' num2str(i) '.bmp']))/255;
    im_gPb_blur = imfilter(im_gPb,h);
    
    tmp = im_gPb;
    tmp(1:k,:) = 0;tmp(end-k:end,:) = 0;
    tmp(:,1:k) = 0;tmp(:,end-k:end) = 0;
    p = max(tmp(:));
    jp = tmp>=p-0.2;
    %figure,imshow(jp)
   [m,n] = find(jp);

    s = 0;
    for j = 1:length(m)
        rec = im_gPb((m(j)-k):(m(j)+k),(n(j)-k):(n(j)+k));
        sel = (rec<max(rec(:))-0.3); %or rec<0.9;
        s = s+sum(rec(sel));
    end
    score(i) = s/length(m);
end
load dmos145.mat
plot(score,dmos145,'*')
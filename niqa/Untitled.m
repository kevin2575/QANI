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

    for m = k+1:size(im_gPb,1)-k
        for n = k+1:size(im_gPb,2)-k
            if im_ucm(m,n)<0.4
                continue;
            end
            rec_im = im_gPb(m-k:m+k,n-k:n+k);
            rec_im_blur = im_gPb_blur(m-k:m+k,n-k:n+k);
            s = s+corr2(rec_im,rec_im_blur);
        end
    end
    score(i) = s/(m*n);
end
load dmos145.mat
plot(score,dmos145,'*')
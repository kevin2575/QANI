pth = 'F:\zzr\images\gblur';
d = dir([pth '\*.bmp']);
%d = d(3:end);
n = length(d);
score = zeros(1,n);

gsize = 6;
gsigma = 3;
k = 5;
step = 1;
h = fspecial('gaussian',gsize,gsigma);

for i = 1:n
    im = imread([pth '\img' num2str(i) '.bmp']);
    im1 = im2double(rgb2gray(im));
    im2 = downSample(im1,2);
    im3 = downSample(im1,3);
    s1 = iqa(im1,h,k,step);
    s2 = iqa(im2,h,k,step);
    s3 = iqa(im3,h,k,step);
    score(i) = mean([s1 s2 s3]);
    i,score(i)
end

a = 10;
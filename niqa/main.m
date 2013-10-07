%todo: 1.prepair the data needed later
%todo: 2.get the blur version of the original image
%todo: 3.compute the similarity score

close all;clear,clc;
pth = 'F:/zzr/images/gblur';d = dir([pth '/*.bmp']);
n = length(d);
score = zeros(1,n);
h = fspecial('gaussian',10,4);

for j = 1:n
    im = im2double(rgb2gray(imread([pth '/img' num2str(j) '.bmp'])));
    im_blur = imfilter(im,h);
    im_blur = imfilter(im_blur,h);
    subplot(121),imshow(im),subplot(122),imshow(im_blur);
    
    s(j) = FeatureSIM(im,im_blur);
    j
end
load dmos145; 
plot(s,dmos145,'*');
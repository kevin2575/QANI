%todo: 1.prepair the data needed later
%todo: 2.read one image,im_ucm,ensure the datatype
%todo: 3.compute the gradient for the whole image,eliminate the short arrow
%todo: 4.show the image

clear,clc;
pth = 'F:/zzr/images/gblur';d = dir([pth '/*.bmp']);
pth_gPb = 'F:/zzr/images/gblur_gPb';d_gPb = dir([pth_gPb '/*.bmp']);
pth_ucm = 'F:/zzr/images/gblur_gPb_ucm';d_ucm = dir([pth_ucm '/*.bmp']);

i = 1;
im_ucm_name = [pth_ucm '/img' num2str(i) '.bmp'];
%im_ucm_name = sprintf('%s/img%d.bmp',pth_ucm,i);
im_ucm = double(imread(im_ucm_name))/255;
if size(im_ucm,3)~=1 || max(im_ucm(:))>1 || min(im_ucm(:))<0
    error('iamge data type not appropriate');%!!!!!!!!!!!!!!!
end

[gx,gy] = gradient(im_ucm);
[m,n] = size(im_ucm);
x = 1:n;   y = m:-1:1;
[x,y] = meshgrid(x,y);
g = sqrt(gx.^2+gy.^2);
selected = (g<0.4);
x(selected) = [];
y(selected) = [];
gx(selected) = [];
gy(selected) = [];

quiver(x,y,gx,gy,0.5);

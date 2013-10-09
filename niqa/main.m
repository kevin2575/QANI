%todo: 1.prepair the data needed later
%todo: 2.read one image,im_ucm,ensure the datatype
%todo: 3.compute and show the normal vector for some eminent edges,then
%        show
%todo: 4.compute the real length for the normal vector,then show it

close all;clear,clc;
pth = 'F:/zzr/images/gblur';d = dir([pth '/*.bmp']);
pth_ref = 'F:/zzr/images/gblur_ref';d_ref = dir([pth_ref '/*.bmp']);
load gblur_rel;


for j = 1:29
    refimg = imread([pth_ref '/' num2str(j) '.bmp']);
    %refimg = rgb2gray(refimg);
    for i = 1:5
        img = imread([pth '/img' num2str(rel(i,j)) '.bmp']);
        %img = rgb2gray(img);
        s(rel(i,j)) = FeatureSIM(refimg,img);
    end
    j
end
load dmos145;
plot(1-s,dmos145,'*');
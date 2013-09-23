%todo: 1.prepair the data needed later
%todo: 2.read one image,im_ucm,ensure the datatype
%todo: 3.compute and show the normal vector for some eminent edges,then
%        show
%todo: 4.compute the real length for the normal vector,then show it
function main
close all;clear,clc;
pth = 'F:/zzr/images/gblur';d = dir([pth '/*.bmp']);
pth_gPb = 'F:/zzr/images/gblur_gPb';d_gPb = dir([pth_gPb '/*.bmp']);
pth_ucm = 'F:/zzr/images/gblur_gPb_ucm';d_ucm = dir([pth_ucm '/*.bmp']);
pth_seg = 'F:/zzr/images/gblur_seg';d_seg = dir([pth_seg '/*.mat']);

for j = 1:length(d)
    im_ucm_name = [pth_ucm '/img' num2str(j) '.bmp'];
    im_ucm1 = double(imread(im_ucm_name))/255;
    im_gPb_name = [pth_gPb '/img' num2str(j) '.bmp'];
    im_gPb1 = double(imread(im_gPb_name))/255;
    %im_seg_name = [pth_seg '/img' num2str(j) '.mat'];
    %load(im_seg_name);
    %im_seg = labels;
    im_ucm2 = downSample(im_ucm1);
    im_gPb2 = downSample(im_gPb1);
    im_ucm3 = downSample(im_ucm2);
    im_gPb3 = downSample(im_gPb2);
    
    [width1] = getWidth(im_ucm1,im_gPb1);
    [width2] = getWidth(im_ucm2,im_gPb2);
    [width3] = getWidth(im_ucm3,im_gPb3);
    
    
%     bwidth1 = sort(width1,'descend');
%     f = floor(length(bwidth1)/2);
%     hbwidth1 = bwidth1(1:f);
%     w1(j) = mean(hbwidth1);
%     
%     bwidth2 = sort(width2,'descend');
%     f2 = floor(length(bwidth2)/2);
%     hbwidth2 = bwidth1(1:f2);
%     w2(j) = mean(hbwidth2);
%     
%     bwidth3 = sort(width3,'descend');
%     f3 = floor(length(bwidth3)/2);
%     hbwidth3 = bwidth1(1:f3);
%     w3(j) = mean(hbwidth3);
    w1(j) = mean(width1);
    w2(j) = mean(width2);
    w3(j) = mean(width3);
    j
end
load dmos145;
w = w1/max(w1)+w2/max(w2)+w3/max(w3);
figure,plot(w1,dmos145,'*');
figure,plot(w2,dmos145,'*');
figure,plot(w3,dmos145,'*');
figure,plot(w,dmos145,'*');

function [width] = getWidth(im_ucm1,im_gPb1)
if size(im_ucm1,3)~=1 || max(im_ucm1(:))>1 || min(im_ucm1(:))<0 ||...
        size(im_gPb1,3)~=1 || max(im_gPb1(:))>1 || min(im_ucm1(:))<0
    error('iamge data type not appropriate');%!!!!!!!!!!!!!!!
end
[m,n] = size(im_ucm1);
%figure(1),clf,imshow(im_gPb1);


k = 11;% edge length of neighborhood
rk = floor(k/2);
temp_ucm = im_ucm1;
temp_ucm([1:rk,end-rk+1:end],:) = 0;
temp_ucm(:,[1:rk,end-rk+1:end]) = 0;
maxValue = max(temp_ucm(:));
selected = (temp_ucm == maxValue);
while sum(selected(:))<50
    maxValue = maxValue - 0.1;
    selected = (temp_ucm >= maxValue);
end
im_ucm_new = (temp_ucm >= maxValue);
%figure(2),clf,imshow(im_ucm_new)%show the im_ucm_new !!!!!!!!!!!!!!!
%figure(3),imshow(im_seg,[]),gcf,colormap jet;
[rows,cols] = find(im_ucm_new == 1);
len = length(rows);
num = 1;
width = 0;
for i=1:10:len
    if rows(i)-rk<0 || cols(i)-rk<0 || rows(i)+rk>m || cols(i)+rk>n
        error('index exceed boundary');%!!!!!!!!!!!!!!!!
    end
    rec = im_ucm_new(rows(i)-rk:rows(i)+rk,cols(i)-rk:cols(i)+rk);
    [rs,cs] = find(rec == 1);
    if size(rs)< 2
        continue;
    end
    k1 = createLinearFit(cs,rs);
    tvh = 1;tvv = k1.p1;% get the 2 components of tanget vector
    tvh = tvh/norm([tvh,tvv]);tvv = tvv/norm([tvh,tvv]);
    if isnan(tvv)
        tvv = 1;
    end
    nvh = tvv;nvv = -tvh;
    %figure(1),hold on,quiver(cols(i),rows(i),nvh,nvv,40);
    
    
    [width(num),nvh,nvv] = getBlurWidth(im_gPb1,rows(i),cols(i),nvh,nvv);
    
    %figure(1),hold on,
    %text(cols(i),rows(i),num2str(width(num))),
    %quiver(cols(i),rows(i),nvh,nvv,width(num));
    num = num+1;
end

function res = downSample(im)

[r,c] = size(im);
res = im(1:2:r,1:2:c);
%todo: 1.prepair the data needed later
%todo: 2.read one image,im_ucm,ensure the datatype
%todo: 3.compute and show the normal vector for some eminent edges,then
%        show
%todo: 4.compute the real length for the normal vector,then show it

close all;clear,clc;
pth = 'F:/zzr/images/gblur';d = dir([pth '/*.bmp']);
pth_gPb = 'F:/zzr/images/gblur_gPb';d_gPb = dir([pth_gPb '/*.bmp']);
pth_ucm = 'F:/zzr/images/gblur_gPb_ucm';d_ucm = dir([pth_ucm '/*.bmp']);



for j = 1:length(d)
    im_ucm_name = [pth_ucm '/img' num2str(j) '.bmp'];
    im_ucm = double(imread(im_ucm_name))/255;
    im_gPb_name = [pth_gPb '/img' num2str(j) '.bmp'];
    im_gPb = double(imread(im_gPb_name))/255;
    if size(im_ucm,3)~=1 || max(im_ucm(:))>1 || min(im_ucm(:))<0 ||...
            size(im_gPb,3)~=1 || max(im_gPb(:))>1 || min(im_ucm(:))<0
        error('iamge data type not appropriate');%!!!!!!!!!!!!!!!
    end
    [m,n] = size(im_ucm);
    figure,imshow(im_gPb);
    
    
    k = 11;% edge length of neighborhood
    rk = floor(k/2);
    temp_ucm = im_ucm;
    %temp_ucm([1:rk,end-rk+1:end],[1:rk,end-rk+1:end]) = 0;
    temp_ucm([1:rk,end-rk+1:end],:) = 0;
    temp_ucm(:,[1:rk,end-rk+1:end]) = 0;
    maxValue = max(temp_ucm(:));
    selected = (temp_ucm == maxValue);
    while sum(selected(:))<50
        maxValue = maxValue - 0.1;
        selected = (temp_ucm >= maxValue);
    end
    im_ucm_new = (temp_ucm >= maxValue);
    %figure(2),imshow(im_ucm_new)%show the im_ucm_new !!!!!!!!!!!!!!!
    [rows,cols] = find(im_ucm_new == 1);
    len = length(rows);
    num = 1;
    for i=1:10:len
        if rows(i)-rk<0 || cols(i)-rk<0 || rows(i)+rk>m || cols(i)+rk>n
            error('index exceed boundary');%!!!!!!!!!!!!!!!!
        end
        rec = im_ucm_new(rows(i)-rk:rows(i)+rk,cols(i)-rk:cols(i)+rk);
        [rs,cs] = find(rec == 1);
        k1 = createLinearFit(cs,rs);
        tvh = 1;tvv = k1.p1;% get the 2 components of tanget vector
        tvh = tvh/norm([tvh,tvv]);tvv = tvv/norm([tvh,tvv]);
        if isnan(tvv)
            tvv = 1;
        end
        nvh = tvv;nvv = -tvh;
        %figure(1),hold on,quiver(cols(i),rows(i),nvh,nvv,40);
        
        
        [width(num),nvh,nvv] = getBlurWidth(im_gPb,rows(i),cols(i),nvh,nvv);
       
        hold on,
        text(cols(i),rows(i),num2str(i)),
        quiver(cols(i),rows(i),nvh,nvv,width(num));
        num = num+1;
    end
    w(j) = sum(width)/num;
    j 
end
load dmos145;
plot(w,dmos145,'*');
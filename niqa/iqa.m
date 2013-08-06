function score = iqa(im,h,k,step)
%mqa Summary of this function goes here
%   Detailed explanation goes here
%     score: quantification of image quality(0~1)

    im = im2double(im);
    imblurred = imfilter(im,h);
    bw = edge(im,'canny');
    [m,n] = size(im);
    s = 0;
    hsize = floor(k/2);
    for i = ceil(k/2):step:m-hsize
        for j = ceil(k/2):step:n-hsize
            if bw(i,j) == 1
                matIm = im(i-hsize:i+hsize,j-hsize:j+hsize);
                matImblurred = imblurred(i-hsize:i+hsize,j-hsize:j+hsize);
                similarity = corr2(matIm,matImblurred);
                s = s + similarity;
            end
        end
    end
    score = s/(sum(bw(:))+0.0001);


%score = 1 - score;
%score = (score - 0.02) / (0.08-0.02);
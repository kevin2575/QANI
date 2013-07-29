function score = iqa(im,h)
%mqa Summary of this function goes here
%   Detailed explanation goes here
%     score: quantification of image quality(0~1)

    im = im2double(im);
    imblurred = imfilter(im,h);
    bw = edge(im,'canny');
    [m,n] = size(im);
    
    s = 0;
    k = 5; %set size of patch to 5*5
    for i = ceil(k/2):m-floor(k/2)
        for j = ceil(k/2):n-floor(k/2)
            if bw(i,j) == 1
                step = floor(k/2);
                matIm = im(i-step:i+step,j-step:j+step);
                matImblurred = imblurred(i-step:i+step,j-step:j+step);
                similarity = corr2(matIm,matImblurred);
                s = s + similarity;
            end
        end
    end
    score = s/(sum(bw(:))+0.0001);


%score = 1 - score;
%score = (score - 0.02) / (0.08-0.02);
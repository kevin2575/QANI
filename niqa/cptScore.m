function [ score ] = cptScore( im )
%CPTSCORE Summary of this function goes here
%   Detailed explanation goes here
%todo: 1.get the phase congrueny map,get the blur version of im
%todo: 2.partion into patches,compute the weight of each patch,get the
%        ratio of variation,get the score
%todo: 3.get the normalization score

pc = phasecongmono(im);
h = fspecial('gaussian');
bim = imfilter(im,h);

[m n] = size(pc);
%w = zeros(m,n);

k = 5; %set size of patch to 5*5 
t = 0.3; %threshold to take into consideration
num = 0; %number of valide patches
for i = 1:k:(m-k+1)
    for j = 1:k:(n-k+1)
        patchPC = pc(i:i+4,j:j+4);
        w = getWeight(patchPC);
        if w<t
            continue;
        end
        patchIM = im(i:i+4,j:j+4);
        patchBIM = bim(i:i+4,j:j+4);
        v = getVariationRatio(patchIM,patchBIM);
        num = num+1;
        score(num) = v*exp(w);        
    end
end
score = sum(score)/num;

function w = getWeight(im)
%
t = mean2(im);
t1 = mean(im(im>=t));
t2 = mean(im(im<t));
t12 = (t1+t2)/2;
w = mean(im(im>t12));


function v = getVariationRatio(im1,im2)
%
[m n] = size(im1);
s1 = 0;
s2 = 0;
for i = 1:m
    for j = 1:n-1
        s1 = s1 + abs(im1(i,j) - im1(i,j+1));
        s2 = s2 + abs(im2(i,j) - im2(i,j+1));
    end
end
v = (s1 - s2)/s1;

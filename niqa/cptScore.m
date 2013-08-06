function [ score ] = cptScore( im,h )
%CPTSCORE Summary of this function goes here
%   Detailed explanation goes here
%todo: 1.get the phase congrueny map,get the blur version of im
%todo: 2.partion into patches,compute the weight of each patch,get the
%        ratio of variation,get the score
%todo: 3.get the normalization score

pc = phasecongmono(im);
bim = imfilter(im,h);

[m n] = size(pc);
%w = zeros(m,n);

k = 11; %set size of patch to 5*5 
t = 0.1; %threshold to take into consideration
num = 0; %number of valide patches
score = 0;
for i = 1:k:(m-k+1)
    for j = 1:k:(n-k+1)
        patchPC = pc(i:i+k-1,j:j+k-1);
        w = getWeight(patchPC);
        if w<t
            continue;
        end
        patchIM = im(i:i+k-1,j:j+k-1);
        patchBIM = bim(i:i+k-1,j:j+k-1);
        v = getVarRatio(patchIM,patchBIM)
        %v = mean2(abs(patchIM - patchBIM));
        num = num+1;
        score(num) = v*exp(w); 
        %score(num) = v; 
    end
end
if num==0
    score = 0;
    return;
end
score = sum(score)/num;

function w = getWeight(im)
%
t = mean2(im);
t1 = mean(im(im>=t));
t2 = mean(im(im<=t));
t12 = (t1+t2)/2;
w = mean(im(im>=t12));

function r = getVarRatio(im1,im2)
%get the ratio of variance between im1 and im2
%todo: 1.get some data ready
%todo: 2.get the variance of im1 and im2,respectively
%todo: 3.compute the ratio

[m n] = size(im1);
Sh1 = 0;Sh2 = 0;
Sv1 = 0;Sv2 = 0;

for i = 1:m
    for j = 1:n-1
        Sh1 = Sh1 + abs(im1(i,j) - im1(i,j+1));
        Sh2 = Sh2 + abs(im2(i,j) - im2(i,j+1));
    end
end
for i = 1:m-1
    for j = 1:n
        Sv1 = Sv1 + abs(im1(i,j) - im1(i+1,j));
        Sv2 = Sv2 + abs(im2(i,j) - im2(i+1,j));
    end
end
S1 = Sh1 + Sv1;
S2 = Sh2 + Sv2;

r = (S1-S2)/S1;

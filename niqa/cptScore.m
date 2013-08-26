function [ score ] = cptScore( img )
%CPTSCORE Summary of this function goes here
%   Detailed explanation goes here

im = rgb2gray(img);
pc = phasecongmono(im);
%figure,subplot(2,2,1),imshow(img),subplot(2,2,2),imshow(pc),subplot(2,2,3:4),imhist(pc),xlim([0 0.6]);
score = sum(pc(:));
[m,n] = size(im);
score = score/(m*n);
% pcr = roundn(pc,-2);
% r = sort(pcr(:));
% r = unique(r);
% tt = pcr;
% n = length(r);
% for i = 1:n
%     tt(tt==r(i)) = i/n;
% end
% b = pc.*tt;
% score = sum(b(:));


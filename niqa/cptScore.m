function [ score ] = cptScore( im )
%CPTSCORE Summary of this function goes here
%   Detailed explanation goes here

pc = phasecongmono(im);
pcr = roundn(pc,-2);
r = sort(pcr(:));
r = unique(r);
tt = pcr;
n = length(r);
for i = 1:n
    tt(tt==r(i)) = i/n;
end
b = pc.*tt;
score = sum(b(:));


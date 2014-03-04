function [ score ] = cptScore( img )
%CPTSCORE Summary of this function goes here
%   Detailed explanation goes here

im = rgb2gray(img);
pc = phasecongmono(im);
score = sum(pc(:));
[m,n] = size(im);
score = score/(m*n);

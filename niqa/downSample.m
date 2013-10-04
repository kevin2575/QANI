function [ retIm ] = downSample( im,level )
%DOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here

[m,n] = size(im);
cs = 1:m;
rs = 1:n;
retIm = [];
if level == 2
    cs = cs(logical(mod(cs,3))); 
    rs = rs(logical(mod(rs,3)));
    retIm = im(cs,rs);
elseif level == 3
    retIm = im(1:3:end,1:3:end);
end
end


pth = 'D:\Backup\ÎÒµÄÎÄµµ\MATLAB\niqa\gblur';
d = dir(pth);
d = d(3:end);
n = length(d);
score = zeros(1,n);

h = fspecial('gaussian',5,4);
for i = 1:n
    im = imread([pth '\img' num2str(i) '.bmp']);
    im = im2double(rgb2gray(im));
    score(i) = iqa(im,h);
    i,score(i)
end
save('subScores.mat','score');
load dmos145;
cftool(score,dmos145);
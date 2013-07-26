pth = 'D:\Backup\ÎÒµÄÎÄµµ\MATLAB\niqa\gblur';
d = dir(pth);
d = d(3:end);
n = length(d);
score = zeros(1,n);

for i = 1:n
    im = imread([pth '\img' num2str(i) '.bmp']);
    im = rgb2gray(im);
    score(i) = cptScore(im);
    i
end
save('subScores.mat','score');
load dmos145;
cftool(dmos145,score);
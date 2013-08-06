pth = 'F:\zzr\images\gblur';
d = dir(pth);
d = d(3:end);
n = length(d);
score = zeros(1,n);
h = fspecial('gaussian',6,3);

tic
for i = 1:n
    im = imread([pth '\img' num2str(i) '.bmp']);
    im = im2double(rgb2gray(im));
    score(i) = cptScore(im,h);
    i,score(i)
end
toc
save('subScores.mat','score');
load dmos145;
cftool(score,100 - dmos145);
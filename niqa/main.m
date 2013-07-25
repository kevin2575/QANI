pth = 'D:\Backup\�ҵ��ĵ�\MATLAB\niqa\gblur';
d = dir(pth);
d = d(3:end);
n = length(d);
score = zeros(1,n);

for i = 1:n
    im = imread([pth '\img' num2str(i) '.bmp']);
    im = im2double(rgb2gray(im));
    score(i) = blurPerception(im);
end
save('subScores.mat','score');
load dmos145;
cftool(dmos145,score);
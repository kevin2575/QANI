pth = 'D:\ms\gblur';
d = dir(pth);
d = d(3:end);
n = length(d);
score = zeros(1,n);

CoreNum=4; %设定机器CPU核心数量，我的机器是双核，所以
if matlabpool('size')<=0 %判断并行计算环境是否已然启动
    matlabpool('open','local',CoreNum); %若尚未启动，则启动并行环境
else
    disp('Already initialized'); %说明并行环境已经启动。
end

for gsize = 3:8
    for gsigma = 3:10
        for k = 3:2:9
            for step = 1:k
                h = fspecial('gaussian',gsize,gsigma);
                tic
                parfor i = 1:n
                    im = imread([pth '\img' num2str(i) '.bmp']);
                    im = im2double(rgb2gray(im));
                    score(i) = iqa(im,h,k,step);
                    %i,score(i)
                end
                save([num2str(gsize) '.' num2str(gsigma) '.' num2str(k) '.' num2str(step) '.mat'],'score');
                toc
            end
        end
    end
end
matlabpool close;
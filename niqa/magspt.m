function magspt(im)
im = im2double(rgb2gray(im));
fim = log(abs(fftshift(fft2(im))));
fim = (fim - min(fim(:)))/(max(fim(:)-min(fim(:))));
figure,imshow(im);
figure;imshow(fim);
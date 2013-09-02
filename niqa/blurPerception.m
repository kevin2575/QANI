function [ blur_F ] = blurPerception( F )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%F = imread('1125.jpg');
%F = imread(pa);
%F = double(rgb2gray(F));
%F = double(F);
hv = fspecial('motion',10,90);
hh = fspecial('motion',10,0);
Bver = imfilter(F,hv);
Bhor = imfilter(F,hh);
%figure,subplot(1,2,1),imshow(F,[]),subplot(1,2,2),imshow(Bhor,[]);
[m,n] = size(F);
D_Fver = zeros(m,n);
D_Bver = zeros(m,n);
D_Vver = zeros(m,n);
for i = 2:m
    for j = 1:n
        D_Fver(i,j) = abs(F(i,j)-F(i-1,j));
        D_Bver(i,j) = abs(Bver(i,j)-Bver(i-1,j));
        D_Vver(i,j) = max(0,D_Fver(i,j)-D_Bver(i,j));
    end
end
D_Fhor = zeros(m,n);
D_Bhor = zeros(m,n);
D_Vhor = zeros(m,n);
for i = 1:m
    for j = 2:n
        D_Fhor(i,j) = abs(F(i,j)-F(i,j-1));
        D_Bhor(i,j) = abs(Bhor(i,j)-Bhor(i,j-1));
        D_Vhor(i,j) = max(0,D_Fhor(i,j)-D_Bhor(i,j));
    end
end

s_Fver = sum(D_Fver(:));
s_Fhor = sum(D_Fhor(:));
s_Vver = sum(D_Vver(:));
s_Vhor = sum(D_Vhor(:));

b_Fver = s_Vver/s_Fver;
b_Fhor = s_Vhor/s_Fhor;

blur_F = max(b_Fver,b_Fhor);

end


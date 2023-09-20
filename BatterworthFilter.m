clc
clear 
close all
i = im2double(imread('v2_1.bmp'));
%=================������� ����� ������=====================================
[ymax,xmax] = size(i(:,:,1));
x = 0:1:xmax;
y = 0:1:ymax;

nux = 1:length(x);
nuy = 1:length(y);

dnux = 1/(xmax);
dnuy = 1/(ymax);

nux =-0.5:dnux:(0.5*xmax-1)/xmax;
nuy =-0.5:dnuy:(0.5*ymax-1)/ymax;
%========������� ��� ������ �������=======
imagef = (fft2(i));
imagefshift(:,:,1) = fftshift(imagef(:,:,1));
imagefshift(:,:,2) = fftshift(imagef(:,:,2));
imagefshift(:,:,3) = fftshift(imagef(:,:,3));
%=======��������� ��������� ��� imshow
imagef1 = mat2gray(log(abs(imagefshift)));
i1 = mat2gray(i);

figure(1)
subplot(1,2,1);
imagesc(x,y,i1)
xlabel('x, �������');
ylabel('y, �������');
title('��������');

subplot(1,2,2);
imagesc(nux,nuy,abs(imagef1))
title('�������� �������');
xlabel('\nu_x, �������^{-1}');
ylabel('\nu_y, �������^{-1}');
%============������� ������� ������=============
[c,r] = meshgrid (nux, nuy);
d = sqrt((r).^2+(c).^2);
nu_cutoff = 0.1;
gauss = exp (-d.^2/(0.5*nu_cutoff^2));
% h_h = 1-gauss;

figure(2)
subplot(1,2,1); 
imagesc(nux,nuy,gauss)
colormap gray
title('������� ������');
xlabel('\nu_x, �������^{-1}');
ylabel('\nu_y, �������^{-1}');
colorbar
subplot(1,2,2); 
plot(nux(270:540),gauss(360,270:540))
title('������� ������ ��� \nu_y = 0');
xlabel('\nu_x, �������^{-1}');
ylabel('���������');
%=========���������� ������� � ��������, ������ ����������, ������������===
imagefgaussed = imagefshift.*gauss;
imagegaussed = ifft2(imagefgaussed);

imagegaussed1 = mat2gray(abs(imagegaussed));
figure(3)
subplot (1,2,1);
imagesc(nux,nuy,abs(imagefgaussed))
title('������ ����� ������������')
xlabel('\nu_x, �������^{-1}');
ylabel('\nu_y, �������^{-1}');
subplot (1,2,2);
imshow(imagegaussed1)
title('������������ �����������')
xlabel('x, �������');
ylabel('y, �������');
% 
%==================�������� ��� �� �������, ��������� ����. �����==========
gauss_=ifft2(gauss);
gauss_mask = gauss((356:366),(266:276));
gauss_mask = gauss_mask/sum(sum(gauss_mask));
gauss_ = mat2gray(abs(gauss_));
figure(4)
subplot(1,2,1);
imagesc(x,y,gauss)
colormap gray
title('��������� ��������� �����')
xlabel('x, �������');
ylabel('y, �������');
subplot(1,2,2);
imshow(gauss_mask,[])
title('���������� ����� 11x11')
xlabel('x, �������');
ylabel('y, �������');

%=================������ ����������� � ����-������� � ������. ������======
image_filtered = imfilter(i,gauss_mask);
image_filtered = mat2gray(image_filtered);
result = image_filtered-imagegaussed1;
result = mat2gray(result);
figure(5)
subplot(1,3,1);
imshow (image_filtered)
title('��������� ���������� ������� � ������������')
xlabel('x, �������');
ylabel('y, �������');
subplot(1,3,2);
imshow(imagegaussed1)
title('��������� ���������� ������� � ��������')
xlabel('x, �������');
ylabel('y, �������');
subplot(1,3,3);
imshow(abs((result)),[]);
title('�������� ���� �����������')
xlabel('x, �������');
ylabel('y, �������');


figure(6)
imshow(image_filtered)

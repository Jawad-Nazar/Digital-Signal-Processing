
%% LAB 3: Frequency Domain Filtering
close all;
clear;
clc;

%% Load image
if exist('peppers.png','file')
    I0 = imread('peppers.png');
else
    I0 = imread('cameraman.tif');
end

if size(I0,3) == 3
    I = im2double(rgb2gray(I0));
else
    I = im2double(I0);
end

[M,N] = size(I);

%% 1. Fourier transform and magnitude spectrum
F = fft2(I);
Fshift = fftshift(F);

S = log(1+abs(Fshift));

figure;
subplot(1,2,1);
imshow(I,[]);
title('Original Image');

subplot(1,2,2);
imshow(S,[]);
title('Log Magnitude Spectrum');

%% 2. Create frequency filters
[u,v] = meshgrid( ...
    -floor(N/2):ceil(N/2)-1, ...
    -floor(M/2):ceil(M/2)-1);

D = sqrt(u.^2+v.^2);

D0 = 40;

H_ideal_LP = double(D<=D0);

sigma = 20;
H_gauss_LP = exp(-(D.^2)/(2*sigma^2));

figure;
subplot(1,2,1);
imshow(H_ideal_LP,[]);
title('Ideal Low Pass');

subplot(1,2,2);
imshow(H_gauss_LP,[]);
title('Gaussian Low Pass');

%% 3. Apply low-pass filters
G_ideal = ifft2(ifftshift(H_ideal_LP.*Fshift));
G_gauss = ifft2(ifftshift(H_gauss_LP.*Fshift));

figure;
montage({I,real(G_ideal),real(G_gauss)},'Size',[1 3]);
title('Original | Ideal LP | Gaussian LP');

%% 4. Gaussian high-pass filtering
H_gauss_HP = 1-H_gauss_LP;

G_hp = ifft2(ifftshift(H_gauss_HP.*Fshift));
G_hp = mat2gray(real(G_hp));

figure;
montage({I,G_hp},'Size',[1 2]);
title('Original | Gaussian High Pass');

%% 5. Spatial vs frequency Gaussian filtering
g1d = fspecial('gaussian',[1 7],1.2);
h_gauss = g1d'*g1d;

I_spatial = imfilter(I,h_gauss,'replicate');

% Frequency-domain filtering using same-size circular padding
pad = 3;
Ip = padarray(I,[pad pad],'replicate','both');

[Mp,Np] = size(Ip);

Fpad = fft2(Ip);

[up,vp] = meshgrid( ...
    -floor(Np/2):ceil(Np/2)-1, ...
    -floor(Mp/2):ceil(Mp/2)-1);

Dp = sqrt(up.^2+vp.^2);

% Approximate frequency response of the Gaussian kernel
Hpad = fftshift(fft2(h_gauss,Mp,Np));

Gpad = ifft2(ifftshift( ...
    fftshift(Fpad).*Hpad));

Gpad = real(Gpad);
G_frequency = Gpad(pad+1:pad+M,pad+1:pad+N);

figure;
montage({I_spatial,G_frequency},'Size',[1 2]);
title('Spatial Gaussian | Frequency Gaussian');

%% 6. Completion
disp('LAB 3 completed successfully.');


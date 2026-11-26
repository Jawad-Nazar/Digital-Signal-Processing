
%% LAB 6: Mini Project - Image Processing Pipeline
close all;
clear;
clc;

%% 1. Load your own image
if ~exist('my_image.jpg','file')
    error('Place my_image.jpg in the current folder.');
end

I0 = imread('my_image.jpg');

if size(I0,3) == 3
    I = im2double(rgb2gray(I0));
else
    I = im2double(I0);
end

%% 2. Noise removal using median filter
I_filt = medfilt2(I,[3 3]);

%% 3. Contrast enhancement
I_enh = imadjust(I_filt,[0.2 0.8],[0 1]);

%% 4. Edge detection using Canny
edges = edge(I_enh,'Canny',[0.1 0.25]);

%% 5. Frequency-domain low-pass filtering
[M,N] = size(I_enh);

F = fftshift(fft2(I_enh));

[u,v] = meshgrid( ...
    -floor(N/2):ceil(N/2)-1, ...
    -floor(M/2):ceil(M/2)-1);

D = sqrt(u.^2+v.^2);

H = double(D<60);

I_lp = real(ifft2(ifftshift(F.*H)));

%% 6. Visualization
figure;
montage({I,I_filt,I_enh,edges,mat2gray(I_lp)}, ...
    'Size',[1 5]);

title('Original | Denoised | Enhanced | Edges | Low Pass');

%% 7. Save results
imwrite(I_filt,'lab6_denoised.png');
imwrite(I_enh,'lab6_enhanced.png');
imwrite(edges,'lab6_edges.png');
imwrite(mat2gray(I_lp),'lab6_lowpass.png');

disp('LAB 6 completed successfully.');


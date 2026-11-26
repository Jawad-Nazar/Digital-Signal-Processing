
%% LAB 7: Traditional vs AI Image Denoising
close all;
clear;
clc;

%% 1. Load original image
originalImage = im2double(imread('cameraman.tif'));

noiseSigma = 0.04;

%% Add Gaussian noise
noisyImage = imnoise(originalImage, ...
    'gaussian',0,noiseSigma^2);

figure('Name','Image Denoising Comparison');

subplot(1,4,1);
imshow(originalImage);
title('Original');

subplot(1,4,2);
imshow(noisyImage);
title('Noisy Image');

%% 2. Traditional filtering: Wiener
traditionalFiltered = wiener2( ...
    noisyImage,[5 5],noiseSigma^2);

subplot(1,4,3);
imshow(traditionalFiltered);
title('Wiener Filter');

%% 3. AI filtering: DnCNN
disp('Loading DnCNN network...');

net = denoisingNetwork('DnCNN');

disp('Network loaded successfully.');

aiFiltered = denoiseImage(noisyImage,net);

subplot(1,4,4);
imshow(aiFiltered,[]);
title('AI DnCNN Filter');

%% 4. Calculate PSNR
psnrNoisy = psnr(noisyImage,originalImage);

psnrTraditional = psnr( ...
    traditionalFiltered,originalImage);

psnrAI = psnr(aiFiltered,originalImage);

%% 5. Calculate SSIM
ssimNoisy = ssim(noisyImage,originalImage);

ssimTraditional = ssim( ...
    traditionalFiltered,originalImage);

ssimAI = ssim(aiFiltered,originalImage);

%% 6. Display quality measurements
fprintf('\nIMAGE QUALITY COMPARISON\n');

fprintf('\nMethod              PSNR (dB)       SSIM\n');

fprintf('Noisy Image         %.4f          %.4f\n', ...
    psnrNoisy,ssimNoisy);

fprintf('Wiener Filter       %.4f          %.4f\n', ...
    psnrTraditional,ssimTraditional);

fprintf('AI DnCNN            %.4f          %.4f\n', ...
    psnrAI,ssimAI);

%% 7. Save results
imwrite(noisyImage,'lab7_noisy.png');
imwrite(traditionalFiltered,'lab7_wiener.png');
imwrite(aiFiltered,'lab7_dncnn.png');

disp('LAB 7 completed successfully.');


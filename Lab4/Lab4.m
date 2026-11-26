
%% LAB 4: Noise and Filtering
close all;
clear;
clc;

%% Load image
I0 = imread('peppers.png');

if size(I0,3) == 3
    I = im2double(rgb2gray(I0));
else
    I = im2double(I0);
end

%% 1. Add different types of noise
I_gauss = imnoise(I,'gaussian',0,0.01);
I_sp = imnoise(I,'salt & pepper',0.05);

figure;
montage({I,I_gauss,I_sp},'Size',[1 3]);
title('Original | Gaussian Noise | Salt and Pepper Noise');

%% 2. Calculate MSE before filtering
MSE_gauss = immse(I_gauss,I);
MSE_sp = immse(I_sp,I);

fprintf('\nMSE BEFORE FILTERING\n');
fprintf('Gaussian noise: %.4f\n',MSE_gauss);
fprintf('Salt and pepper: %.4f\n',MSE_sp);

%% 3. Linear filtering
h_avg = fspecial('average',3);
h_gauss = fspecial('gaussian',[3 3],0.7);

I_avg_gauss = imfilter(I_gauss,h_avg,'replicate');
I_avg_sp = imfilter(I_sp,h_avg,'replicate');

I_gauss_gauss = imfilter(I_gauss,h_gauss,'replicate');
I_gauss_sp = imfilter(I_sp,h_gauss,'replicate');

%% 4. Nonlinear filtering: Median
I_med_gauss = medfilt2(I_gauss,[3 3]);
I_med_sp = medfilt2(I_sp,[3 3]);

figure;
montage({I_avg_sp,I_med_sp, ...
    I_avg_gauss,I_med_gauss},'Size',[2 2]);

title('Average vs Median Filtering');

%% 5. Compare filtering results
fprintf('\nMSE AFTER FILTERING\n');

fprintf('Salt and pepper - Average: %.4f\n', ...
    immse(I_avg_sp,I));

fprintf('Salt and pepper - Median: %.4f\n', ...
    immse(I_med_sp,I));

fprintf('Gaussian - Average: %.4f\n', ...
    immse(I_avg_gauss,I));

fprintf('Gaussian - Gaussian filter: %.4f\n', ...
    immse(I_gauss_gauss,I));

fprintf('Gaussian - Median: %.4f\n', ...
    immse(I_med_gauss,I));

%% 6. Display additional results
figure;
montage({I_gauss,I_avg_gauss,I_gauss_gauss, ...
    I_med_gauss},'Size',[1 4]);

title('Gaussian Noise Filtering Comparison');

figure;
montage({I_sp,I_avg_sp,I_med_sp},'Size',[1 3]);

title('Salt and Pepper Filtering Comparison');

disp('LAB 4 completed successfully.');


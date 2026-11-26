
%% LAB 1: Image as a 2D Signal
% Sampling, Quantization, Histograms and Enhancement
% Name: [Your Name]
% Course: [Course Name]

close all;
clear;
clc;

%% 0. Load and inspect an image

if exist('peppers.png','file')
    I_rgb = imread('peppers.png');
elseif exist('cameraman.tif','file')
    I_rgb = repmat(imread('cameraman.tif'),1,1,3);
else
    [filename, pathname] = uigetfile( ...
        {'*.png;*.jpg;*.jpeg;*.tif','Image files'}, ...
        'Select an image');

    if isequal(filename,0)
        error('No image selected.');
    end

    I_rgb = imread(fullfile(pathname,filename));
end

% Convert to RGB if necessary
if ndims(I_rgb) == 2
    I_rgb = repmat(I_rgb,1,1,3);
end

figure;
imshow(I_rgb);
title('Original RGB Image');

% Convert RGB image to grayscale
I = rgb2gray(I_rgb);

figure;
imshow(I);
title('Grayscale Image');

% Display basic image information
fprintf('Image class: %s\n', class(I));
fprintf('Minimum intensity: %g\n', double(min(I(:))));
fprintf('Maximum intensity: %g\n', double(max(I(:))));
fprintf('Image dimensions: %d x %d\n', size(I,1), size(I,2));

%% 1. Quantization and Dynamic Range

I8 = I;  % Original 8-bit image

% Approximately 6-bit quantization
I6 = uint8(floor(double(I)/4)*4);

% Approximately 4-bit quantization
I4 = uint8(floor(double(I)/16)*16);

figure;
montage({I8,I6,I4},'Size',[1 3]);
title('Quantization: 8-bit | 6-bit | 4-bit');

%% 2. Histogram and Contrast Stretching

figure;

subplot(1,2,1);
imhist(I);
title('Original Image Histogram');

% Normalize image intensity to [0,1]
I_norm = mat2gray(I);

% Stretch contrast using linear intensity remapping
I_stretch = imadjust(I,[0.2 0.8],[0 1]);

subplot(1,2,2);
imhist(I_stretch);
title('Contrast-Stretched Histogram');

figure;
montage({I,im2uint8(I_norm),I_stretch},'Size',[1 3]);
title('Original | Normalized | Contrast-Stretched');

%% 3. Gamma Correction

% Gamma less than 1 brightens the image
I_gamma_low = imadjust(I,[],[],0.6);

% Gamma greater than 1 darkens the image
I_gamma_high = imadjust(I,[],[],1.6);

figure;
montage({I,I_gamma_low,I_gamma_high},'Size',[1 3]);
title('Gamma Correction: Original | Gamma 0.6 | Gamma 1.6');

%% 4. Sampling and Aliasing

% Reduce image dimensions to 10%
scale = 0.1;

% Downsample using nearest-neighbor interpolation
I_small = imresize(I,scale,'nearest');

% Resize the small image back to original dimensions
I_back = imresize(I_small,size(I),'nearest');

figure;
montage({I,I_small,I_back},'Size',[1 3]);
title('Original | Downsampled | Upscaled');

%% 5. Optional Moire Demonstration

% If a striped or high-frequency texture image is available,
% repeat Section 4 using that image.
% Observe the interference patterns called Moire patterns.

%% 6. Display Completion Message

disp('Lab 1 completed successfully!');



%% LAB 5: Edge Detection and Segmentation
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

%% 1. Sobel and Prewitt edge detection
edges_sobel = edge(I,'Sobel');
edges_prewitt = edge(I,'Prewitt');

figure;
montage({edges_sobel,edges_prewitt},'Size',[1 2]);
title('Sobel | Prewitt Edge Detection');

%% 2. Canny edge detection
edges_canny = edge(I,'Canny',[0.05 0.2]);

figure;
imshow(edges_canny);
title('Canny Edge Detection');

%% 3. Laplacian of Gaussian
edges_log = edge(I,'log');

figure;
imshow(edges_log);
title('Laplacian of Gaussian Edges');

%% 4. Otsu thresholding
level = graythresh(I);

BW = imbinarize(I,level);

figure;
montage({I,BW},'Size',[1 2]);
title('Original Image | Otsu Binary Segmentation');

fprintf('Otsu threshold level: %.4f\n',level);

%% 5. Connected component labeling
[L,num] = bwlabel(BW);

RGB = label2rgb(L,'jet','k','shuffle');

figure;
imshow(RGB);
title(['Labeled Regions: ',num2str(num)]);

%% 6. Region properties
stats = regionprops(L,'Area','Centroid');

fprintf('\nNumber of connected regions: %d\n',num);

for k = 1:numel(stats)
    fprintf('Region %d: Area = %.2f pixels\n', ...
        k,stats(k).Area);
end

%% 7. Display completion
disp('LAB 5 completed successfully.');


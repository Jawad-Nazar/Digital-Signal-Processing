
%% LAB 8: Hybrid Traditional + AI Pipeline
close all;
clear;
clc;

%% 1. Load image
targetImage = imread('peppers.png');

% Ensure RGB image
if size(targetImage,3) ~= 3
    targetImage = repmat(targetImage,1,1,3);
end

figure('Name','Hybrid Traditional and AI Pipeline');

subplot(2,2,1);
imshow(targetImage);
title('Original Image');

%% 2. Traditional segmentation using K-means
disp('Applying K-means segmentation...');

imgLab = rgb2lab(targetImage);

ab = imgLab(:,:,2:3);
ab = im2single(ab);

% Divide image into two color clusters
pixelLabels = imsegkmeans(ab,2);

% Select cluster 2 as the initial object mask
mask = pixelLabels == 2;

% Clean segmentation mask
mask = imfill(mask,'holes');
mask = bwareaopen(mask,100);

subplot(2,2,2);
imshow(mask);
title('K-means Segmentation Mask');

%% 3. Isolate object
isolatedObject = targetImage;

isolatedObject(repmat(~mask,1,1,3)) = 0;

subplot(2,2,3);
imshow(isolatedObject);
title('Isolated Object');

%% 4. Load AI classification network
disp('Loading SqueezeNet...');

net = squeezenet;

disp('SqueezeNet loaded.');

%% 5. Prepare image for AI
inputSize = net.Layers(1).InputSize;

resizedObject = imresize( ...
    isolatedObject, ...
    [inputSize(1),inputSize(2)]);

%% 6. Classify image
disp('Running AI classification...');

[YPred,probs] = classify(net,resizedObject);

%% 7. Display AI input
subplot(2,2,4);
imshow(resizedObject);
title('Resized AI Input');

%% 8. Display classification result
[confidence,index] = max(probs);

fprintf('\nHYBRID PIPELINE RESULTS\n');

fprintf('Predicted class: %s\n',string(YPred));

fprintf('Confidence: %.2f%%\n',confidence*100);

fprintf('Class index: %d\n',index);

%% 9. Save results
imwrite(mask,'lab8_mask.png');
imwrite(isolatedObject,'lab8_isolated.png');
imwrite(resizedObject,'lab8_ai_input.png');

disp('LAB 8 completed successfully.');


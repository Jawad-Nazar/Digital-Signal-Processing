
%% LAB 9: Metal Stud Detection on Tires
close all;
clear;
clc;

%% Image filenames
imageFiles = {'studded_tire.jpg','summer_tire.jpg'};

%% Detection parameters
minA = 4;
maxA = 120;

minCirc = 0.6;
maxEcc = 0.85;

% Number of detected studs required for classification
studThreshold = 10;

%% Process both tire images
for i = 1:numel(imageFiles)

    fprintf('\nProcessing: %s\n',imageFiles{i});

    %% 1. Read and resize image
    if ~exist(imageFiles{i},'file')
        warning('Image not found: %s',imageFiles{i});
        continue;
    end

    I = imread(imageFiles{i});
    I = imresize(I,0.5);

    %% 2. Convert to grayscale
    if size(I,3) == 3
        Igray = im2double(rgb2gray(I));
    else
        Igray = im2double(I);
    end

    %% 3. Create tire mask
    % Tire is assumed darker than background

    level = graythresh(Igray);

    tireMask = Igray < level;

    % Remove small unwanted regions
    tireMask = bwareaopen(tireMask,500);

    % Connect small gaps
    tireMask = imclose(tireMask,strel('disk',7));

    % Fill holes
    tireMask = imfill(tireMask,'holes');

    % Keep largest connected region
    CC_tire = bwconncomp(tireMask);

    if CC_tire.NumObjects == 0
        warning('No tire region detected in %s',imageFiles{i});
        continue;
    end

    tireAreas = cellfun(@numel,CC_tire.PixelIdxList);

    [~,largestIndex] = max(tireAreas);

    tireMask = false(size(Igray));
    tireMask(CC_tire.PixelIdxList{largestIndex}) = true;

    %% 4. Find bright candidate studs

    % Smooth small variations
    I_smooth = imgaussfilt(Igray,0.8);

    % Estimate threshold from tire pixel intensities
    tirePixels = I_smooth(tireMask);

    brightThreshold = max( ...
        prctile(tirePixels,92),0.35);

    % Erode mask to avoid detecting bright background edges
    innerMask = imerode(tireMask,strel('disk',3));

    % Bright spots inside tire
    cand = (I_smooth > brightThreshold) & innerMask;

    %% 5. Morphological cleaning

    cand = bwareaopen(cand,3);

    % Remove tiny isolated noise
    cand = imopen(cand,strel('disk',1));

    % Fill small holes
    cand = imfill(cand,'holes');

    %% 6. Connected component analysis

    CC = bwconncomp(cand);

    stats = regionprops(CC, ...
        'Area','Perimeter','Eccentricity','Centroid');

    studMask = false(size(cand));
    studCount = 0;

    %% 7. Filter candidates using properties

    for k = 1:numel(stats)

        A = stats(k).Area;
        P = stats(k).Perimeter;
        E = stats(k).Eccentricity;

        if P > 0
            circularity = 4*pi*A/(P^2);
        else
            circularity = 0;
        end

        % Check area, circularity and eccentricity
        if A >= minA && A <= maxA && ...
           circularity >= minCirc && E <= maxEcc

            studMask(CC.PixelIdxList{k}) = true;

            studCount = studCount+1;

        end
    end

    %% 8. Classification

    tireArea = nnz(tireMask);

    if tireArea > 0
        density = studCount/tireArea;
    else
        density = 0;
    end

    isStudded = studCount > studThreshold;

    if isStudded
        result = 'STUDDED TIRE';
    else
        result = 'NON-STUDDED TIRE';
    end

    %% 9. Display results

    figure('Name',imageFiles{i});

    subplot(1,3,1);
    imshow(I);
    title(sprintf('Input: %s',imageFiles{i}), ...
        'Interpreter','none');

    subplot(1,3,2);
    imshow(cand);
    title('Candidate Bright Spots');

    subplot(1,3,3);
    imshow(I);
    hold on;

    visboundaries(studMask,'Color','g','LineWidth',0.7);

    if isStudded
        title(sprintf('STUDDED TIRE (studs: %d)',studCount));
    else
        title(sprintf('NON-STUDDED TIRE (studs: %d)',studCount));
    end

    hold off;

    %% 10. Print results

    fprintf('Tire threshold: %.4f\n',level);
    fprintf('Bright threshold: %.4f\n',brightThreshold);
    fprintf('Detected studs: %d\n',studCount);
    fprintf('Stud density: %.6f\n',density);
    fprintf('Classification: %s\n',result);

    %% 11. Save detection image

    saveas(gcf,sprintf('tire_result_%d.png',i));

end

disp('LAB 9 completed successfully.');


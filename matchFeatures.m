function [corr, corrPoints] = matchFeatures(image1, corners1, image2, corners2, windowSize)
image1 = im2double(image1);
image2 = im2double(image2);
corrThreshold = 0.8;
proWindowSize = 100;
disThreshold = 1.1;
cornerNum1 = size(corners1, 1);
cornerNum2 = size(corners2, 1);
corr = zeros(cornerNum1, 1);
corrPoints = zeros(cornerNum1, 2);
step = floor(windowSize/2);
for i = 1:cornerNum1
    % define patch in image1
    corner1 = corners1(i, :);
    centerx1 = floor(corner1(1));
    centery1 = floor(corner1(2));
    patch1 = image1(centerx1-step:centerx1+step, centery1-step:centery1+step);
    maxcorrelation = -1;
    nextmaxcorrelation = -1;
    nextBestCorner = zeros(1, 2);
    mean1 = mean(patch1(:));
    sigma1 = sqrt(sum(sum((patch1 - mean1).^2))/(windowSize^2));
    patch1 = patch1 - mean1;
    for j = 1:cornerNum2
        % define patch in image2
        corner2 = corners2(j, :);
        if pdist([corner1;corner2]) > proWindowSize
            continue;
        end
        centerx2 = floor(corner2(1));
        centery2 = floor(corner2(2));
        patch2 = image2(centerx2-step:centerx2+step, centery2-step:centery2+step);
        mean2 = mean(patch2(:));
        sigma2 = sqrt(sum(sum((patch2 - mean2).^2))/(windowSize^2));
        patch2 = patch2 - mean2;
        correlation = sum(sum(patch1.*patch2))/(windowSize^2);
        correlation = correlation/(sigma1*sigma2);
        
        
        if correlation > maxcorrelation
            nextmaxcorrelation = maxcorrelation;
            nextBestCorner(:) = corrPoints(i, :);
            corrPoints(i, 1) = corner2(1);
            corrPoints(i, 2) = corner2(2);
            maxcorrelation = correlation;
        elseif correlation > nextmaxcorrelation
            nextmaxcorrelation = correlation;
            nextBestCorner(1) = corner2(1);
            nextBestCorner(2) = corner2(2);
        end
    end
    pdist([corner1; nextBestCorner])/pdist([corner1; corrPoints(i, :)])
    %pdist([corner1; nextBestCorner])
     if ((pdist([corner1; corrPoints(i, :)]) <= proWindowSize)&& ...  % within a distance
      (pdist([corner1; nextBestCorner])/pdist([corner1; corrPoints(i, :)])<= disThreshold) && ... % within a ratio to next best matching
       (maxcorrelation > corrThreshold)) % correlation above a threshold
        corr(i) = maxcorrelation;
    end
end
end
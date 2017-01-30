clc, clear, close all;
% load images
image1 = imread('price_center20.JPG');
image2 = imread('price_center21.JPG');
image1_gray = rgb2gray(image1);
image2_gray = rgb2gray(image2);
% parameters
threshold = 18;
windowSize = 7;
subwindowSize = 9;

% corner detection
[subImage1, corners1] = calcMinorEigenImageAndCorner(image1_gray, windowSize,subwindowSize, threshold);
[subImage2, corners2] = calcMinorEigenImageAndCorner(image2_gray, windowSize, subwindowSize, threshold);

% feature matching 
[corr1, corrPoints1] = matchFeatures(image1_gray, corners1, image2_gray, corners2, windowSize);
sum(corr1>0)
[corr2, corrPoints2] = matchFeatures(image2_gray, corners2, image1_gray, corners1, windowSize);
 sum(corr2>0)

figure;
imshow(image1);
hold on;
% plot(corners1(:,2),corners1(:,1),'s','MarkerSize',8,'Color','r');
for i = 1:size(corr1)
   if corr1(i)>0
         plot([corners1(i,2), corrPoints1(i,2)],[corners1(i,1), corrPoints1(i,1)]);
         plot(corrPoints1(i,2),corrPoints1(i,1),'s','MarkerSize',10,'Color','b');
   end
end


figure;
imshow(image2);
hold on;
% plot(corners2(:,2),corners2(:,1),'s','MarkerSize',8,'Color','r');
for i = 1:size(corr2)
   if corr2(i)>0
         plot([corners2(i,2), corrPoints2(i,2)],[corners2(i,1), corrPoints2(i,1)]);
         plot(corrPoints2(i,2),corrPoints2(i,1),'s','MarkerSize',10,'Color','b');
   end
end


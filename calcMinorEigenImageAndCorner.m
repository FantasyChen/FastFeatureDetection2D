function [subImage, corners] = calcMinorEigenImageAndCorner(image, windowSize,subwindowSize, threshold)
filter = 1/12*[-1,8,0,-8,1];
I_X = conv2(image, filter, 'same');
% I_X(I_X <= threshold) = 0;
I_Y = conv2(image, filter', 'same');
% I_Y(I_Y <= threshold) = 0;
subImage = zeros(size(image));
step = floor(windowSize/2);
% calc minor eigenvalue image
for i = 1+step:size(image, 1)-step
    for j = 1+step:size(image, 2)-step
        N = zeros(2,2);
        sumXX = 0;
        sumYY = 0;
        sumXY = 0;
        for t = i-step : i+step
            for k = j-step : j+step
                sumXY = sumXY + I_X(t, k)*I_Y(t, k);
                sumXX = sumXX + I_X(t, k)^2;
                sumYY = sumYY + I_Y(t, k)^2;
            end
        end
        N(1,1) = sumXX;
        N(1,2) = sumXY;
        N(2,1) = sumXY;
        N(2,2) = sumYY;
        N = N/(windowSize^2);
        values = eig(N);
        value = min(values);
        if value >= threshold
            subImage(i, j) = value;
        end
    end
end

subStep = floor(subwindowSize/2);
maskMax = zeros(size(image));
% suppression
for i = 1+subStep:size(image, 1)-subStep
    for j = 1+subStep:size(image, 2)-subStep
        cur = subImage(i-subStep:i+subStep, j-subStep:j+subStep);
        curMax = max(max(cur));
        if curMax == 0
            continue;
        end
        if subImage(i, j) == curMax
            maskMax(i, j) = 1;
        end
        % scatter(i, j, subwindowSize, 's')
%         plot(i, j, 's','MarkerSize',subwindowSize,'Color','b');
%         cur(cur<max(max(cur))) = 0;
%         subImage(i-subStep:i+subStep, j-subStep:j+subStep) = cur;
    end
end
cornerNum = sum(maskMax(:));
corners = zeros(cornerNum, 2);
counter = 1;
for i = 1+step:size(image, 1)-step
    for j = 1+step:size(image, 2)-step
        if maskMax(i, j) == 1
            N = zeros(2,2);
            B = zeros(2,1);
            sumXX = 0;
            sumYY = 0;
            sumXY = 0;
            sumX = 0;
            sumY = 0;
            for t = i-step : i+step
                for k = j-step : j+step
                    sumXY = sumXY + I_X(t, k)*I_Y(t, k);
                    sumXX = sumXX + I_X(t, k)^2;
                    sumYY = sumYY + I_Y(t, k)^2;
                    sumX = sumX + k*I_X(t,k)*I_X(t,k) + t*I_X(t,k)*I_Y(t,k);
                    sumY = sumY + k*I_X(t,k)*I_Y(t,k) + t*I_Y(t,k)*I_Y(t,k);
                end
            end
            N(1,1) = sumXX;
            N(1,2) = sumXY;
            N(2,1) = sumXY;
            N(2,2) = sumYY;
            B(1,1) = sumX;
            B(2,1) = sumY;
            corner = linsolve(N,B);
            corners(counter, 1) = corner(2);
            corners(counter, 2) = corner(1);
            counter = counter + 1;
        end
            
    end
end
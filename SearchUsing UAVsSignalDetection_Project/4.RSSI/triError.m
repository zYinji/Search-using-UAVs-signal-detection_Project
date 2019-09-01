% ----------------------------------------------------------------------------------------------------------
%  File: triError.m
%
%  Master Project. All rights reserved.
%
%  Author: Yinji Zhu
%
% ----------------------------------------------------------------------------------------------------------
function errorMean = triError(X,Y,data,loop)
distance = data(:,2);

error = zeros(5,loop);
errorMean = zeros(5,1);
for i = 1:loop
    ranNumber = randperm(7); % random array the sequence of receiver points
    X = X(ranNumber);
    Y = Y(ranNumber);
    distance = distance(ranNumber);
    for j = 1:5
        XLoop = X(1:j+2);
        YLoop = Y(1:j+2);
        distanceLoop = distance(1:j+2);
        A = [2 * (XLoop(1:end-1) - XLoop(2:end)) 2 * (YLoop(1:end-1) - YLoop(2:end))];
        B = [(XLoop(1:end-1).^2 - XLoop(2:end).^2) + (YLoop(1:end-1).^2 - YLoop(2:end).^2) - (distanceLoop(1:end-1).^2 - distanceLoop(2:end).^2)];
        position = inv(A'*A) * A' * B;
        error(j,i) = norm(position);
    end
end

errorMean = mean(error,2); % calculate the mean error of the number of localization points

%% plot errorMean versus the number of localization points
figure;
x=3:1:7;
plot(x,errorMean,'-or'); 
set(gca,'XTick',[3:1:7]);
xlabel('Number of Receiers');
ylabel('Mean Error');
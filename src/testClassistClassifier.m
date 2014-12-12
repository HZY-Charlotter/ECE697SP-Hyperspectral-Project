clc, clear, close all;

load hsi;
load mapTrain;
load mapTest;
load trainingSamplesPerClass;

% %% Test
% lots = [2, 3, 6, 11, 14, 15, 19];
% 
% mapTrain(~ismember(mapTrain, lots)) = 0;
% mapTest(~ismember(mapTest, lots)) = 0;

%% Parameters
alpha = 0.1;
sigma = 2.5e-2;

nystroemFraction = 1e-3; % 1percent

sectionSize = 10000;

RSVD.k_fraction = 0.7;
RSVD.p = 10;
RSVD.q = 3;

testIDX = mapTest > 0;

tic;
%% Perform classification
predictedLabels = randomizedSetsClassistClassifier(hsi, mapTrain, testIDX, alpha, sigma, nystroemFraction, RSVD, sectionSize);

mapPredict = reshape(predictedLabels, size(mapTrain));

% %% Test----------
% mapPredict = zeros(size(mapTrain));
% for r=1:length(lots)
%     mapPredict(mapPredict_tmp == r) = lots(r);
% end
% %% ------------

%% Error rate
testError = errorRate(mapPredict, mapTest);
cm = getConfusionMatrix(mapPredict, mapTest);
[precision, recall] = precisionRecall(cm);

toc
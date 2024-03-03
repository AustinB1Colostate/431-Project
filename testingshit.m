%% This will be a pan thompkins that is putting average data into columns for the NN
clc;
close all;
clear;
%% Load in the signal data
%Using data sets that have: Normal, Ventricular Flutter, Ventricular
%Tachycardia, and Ventricular Fibrillation and maybe (noise) using the MIT-BIH Malignant Ventricular Ectopy Database

ECG_test_table = table();
%Inputs
%Sample Frequency
%Annotations.txt files
%Data CSV files
%Maybe time window: Deciding to use 2 second window for each of the
%signals, so the data extracted and analyzed is the annotation and the 2
%seconds after showing the arrhythemia
%Example is patient 419, who had ventricular flutter
%Load Data
load('419m_test.mat');
type('419m.info');

%Read Annotations and get times
annotations = readcell("anno_flut_419_test.txt",'ExpectedNumVariables',8);
secondcoldata = val(1,:);
gain = 200;

dt = 0.004;
n = length(secondcoldata);
fs = 250; %Sample frequency Hz
T = n*dt ; %sampling window in seconds
t=(1:n)/250;        % time sampling vector
x = secondcoldata / gain;      % scaled to mV


nEvents = length(annotations);
%get list of unique ECG annotation types, and count of unique event types

% types = unique(annotations(2:21,8));
types = unique(annotations(:,8));

n_types = length(types);
%% Looping
% List of event types to analyze
eventTypes = {'(N', '(VFL'}; % Add other event types as needed
ECG_test_table = table();

for eventType = eventTypes
    logicalMatch = matches(annotations(:,8), eventType);
    eventInds = find(logicalMatch);
    for i = 1:length(eventInds)
        eventInd = eventInds(i);
        sampleInd = annotations{eventInd,1};
        sampleInd = (sampleInd-120)*fs; % Adjust based on the actual start time in your annotations
    
        beginInd = round(sampleInd);
        endInd = round(sampleInd) + round(2*fs); % Two second window
        
        % Adjust endInd to not exceed the length of x
        endInd = min(endInd, length(x));

        % Ensure beginInd is within the array bounds
        if beginInd >= 1 && beginInd < endInd - 3
            % Extract segment for analysis
            segment_x = x(beginInd:endInd);
            segment_t = t(beginInd:endInd);
            
            % Find peaks in this segment
            [pks, locs] = findpeaks(segment_x, 'MinPeakHeight', 0.2, 'MinPeakDistance', 40);

            if ~isempty(locs)  % Check if any peaks were found
                % Calculate statistics from the found peaks
                R_wave_amplitudes = segment_x(locs);
                mean_R_wave_amplitude = mean(R_wave_amplitudes);
                std_R_wave_amplitude = std(R_wave_amplitudes);
                RR_intervals = diff(locs) / fs;
                average_RR_time = mean(RR_intervals);
                variance_RR_time = var(RR_intervals);

                % Append to the table
                current_stats = table(mean_R_wave_amplitude, std_R_wave_amplitude, average_RR_time, variance_RR_time, eventType, ...
                                      'VariableNames', {'Mean_R_Amplitude', 'STD_R_Amplitude', 'Average_RR_Time', 'Variance_RR_Time', 'Event_Type'});
                ECG_test_table = [ECG_test_table; current_stats];
            end
        end
    end
end




disp(ECG_test_table);



%% Using find peaks and no pan thompkins just for R waves. 

%% Load in the signal data
%Using data sets that have: Normal, Ventricular Flutter, Ventricular
%Tachycardia, and Ventricular Fibrillation and maybe (noise) using the MIT-BIH Malignant Ventricular Ectopy Database
ECG_stats_table = table();
%Inputs
%Sample Frequency
%Annotations.txt files
%Data CSV files
%Maybe time window: Deciding to use 2 second window for each of the
%signals, so the data extracted and analyzed is the annotation and the 2
%seconds after showing the arrhythemia
%Example is patient 419, who had ventricular flutter
%Load Data
load('419m.mat');
type('419m.info');

%Read Annotations and get times
annotations = readcell("anno_flut_419.txt",'ExpectedNumVariables',8);
secondcoldata = val(1,:);
gain = 200;

dt = 0.004;
n = length(secondcoldata);
fs = 250; %Sample frequency Hz
T = n*dt ; %sampling window in seconds
t=(1:n)/250;        % time sampling vector
x = secondcoldata / gain;      % scaled to mV


nEvents = length(annotations);
%get list of unique ECG annotation types, and count of unique event types

types = unique(annotations(:,8));

n_types = length(types);

% List of event types to analyze
eventTypes = {'(N', '(VFL'}; % Add other event types as needed


for eventType = eventTypes
    logicalMatch = matches(annotations(:,8), eventType);
    eventInds = find(logicalMatch);
    for i = 1:length(eventInds)
        eventInd = eventInds(i);
        sampleInd = annotations{eventInd,1};
        sampleInd = (sampleInd-60)*fs; % Adjust based on the actual start time in your annotations

        beginInd = round(sampleInd);
        endInd = round(sampleInd) + round(2*fs); % Two second window

        % Adjust endInd to not exceed the length of x
        endInd = min(endInd, length(x));

        % Ensure beginInd is within the array bounds
        if beginInd >= 1 && beginInd < endInd
            % Extract segment for analysis
            segment_x = x(beginInd:endInd);
            segment_t = t(beginInd:endInd);

            % Find peaks in this segment
            [pks, locs] = findpeaks(segment_x, 'MinPeakHeight', 0.2, 'MinPeakDistance', 40);

            if ~isempty(locs)  % Check if any peaks were found
                % Calculate statistics from the found peaks
                R_wave_amplitudes = segment_x(locs);
                mean_R_wave_amplitude = mean(R_wave_amplitudes);
                std_R_wave_amplitude = std(R_wave_amplitudes);
                RR_intervals = diff(locs) / fs;
                average_RR_time = mean(RR_intervals);
                variance_RR_time = var(RR_intervals);

                % Append to the table
                current_stats = table(mean_R_wave_amplitude, std_R_wave_amplitude, average_RR_time, variance_RR_time, eventType, ...
                                      'VariableNames', {'Mean_R_Amplitude', 'STD_R_Amplitude', 'Average_RR_Time', 'Variance_RR_Time', 'Event_Type'});
                ECG_stats_table = [ECG_stats_table; current_stats];
            end
        end
    end
end

disp(ECG_stats_table);


% Randomizing the table order
rand_stats = ECG_stats_table(randperm(size(ECG_stats_table,1)),:);
%%training and testing the NN

% Let's partition the data for training and testing
c = cvpartition(rand_stats.Event_Type, "Holdout", 0.20);
trainingIndices = training(c); % Indices for the training set
testIndices = test(c); % Indices for the test set

% Separate the training and testing data
Train = rand_stats(trainingIndices,:);
Test = rand_stats(testIndices,:);

% Here, we use multiple predictors
XTrain = Train{:, {'Mean_R_Amplitude', 'STD_R_Amplitude', 'Average_RR_Time', 'Variance_RR_Time'}};
YTrain = Train.Event_Type;

% Convert YTrain to categorical if it's not already
YTrain = categorical(YTrain);

Mdl = fitcnet(XTrain, YTrain)

% Prepare the predictors and response for testing
XTest = Test{:, {'Mean_R_Amplitude', 'STD_R_Amplitude', 'Average_RR_Time', 'Variance_RR_Time'}};
YTest = Test.Event_Type;

% Convert YTest to categorical if it's not already
YTest = categorical(YTest);

% Evaluate the model on the train set
trainPredictions = predict(Mdl, XTrain);
% Evaluate the model on the test set
testPredictions = predict(Mdl, XTest);
% Calculate and display the training accuracy
trainAccuracy = sum(YTrain == trainPredictions) / numel(YTrain);
fprintf('Training Accuracy: %.2f%%\n', trainAccuracy * 100);


% Calculate and display the test accuracy
testAccuracy = sum(YTest == testPredictions) / numel(YTest);
fprintf('Test Accuracy: %.2f%%\n', testAccuracy * 100);

% Confusion matrix for the training set
figure;
confusionchart(YTrain, trainPredictions);
title('Confusion Matrix for Training Set');

% Predict the responses using the trained model Mdl and display the confusion matrix
figure;
confusionchart(YTest, testPredictions);
title('Confusion Matrix for Testing Set');

% Evaluate on independent test set
% Prepare the predictors and response for testing

XTest_ind = ECG_test_table{:, {'Mean_R_Amplitude', 'STD_R_Amplitude', 'Average_RR_Time', 'Variance_RR_Time'}};
YTest_ind = categorical(ECG_test_table.Event_Type);
ind_testPredictions = predict(Mdl,XTest_ind);
ind_test_accuracy = sum(YTest_ind == ind_testPredictions) / numel(YTest_ind);
fprintf('Independent Test Accuracy: %.2f%%\n', ind_test_accuracy * 100);

% Confusion matrix for the training set
figure;
confusionchart(YTest_ind, ind_testPredictions);
title('Confusion Matrix for Independent Testing Set');
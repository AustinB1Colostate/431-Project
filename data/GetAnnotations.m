%% Get Info files
% 
% type("data\MIT_DataBase_TrainingData\04015m.info")
% type("data\MIT_DataBase_TrainingData\04043m.info")
% type("data\MIT_DataBase_TrainingData\04048m.info")
% type("data\MIT_DataBase_TrainingData\04126m.info")
% type("data\MIT_DataBase_TrainingData\04746m.info")
load arrhythmia.mat
%% Get All Annotations listed in the PatientDataBase.csv
% Then, retreive all data points that have been annotated with abdnormal
PatientData_Filenames = readtable("PatientDataBase.csv");
PatientData_Filenames = PatientData_Filenames.AnnotationFileNames;

numFiles = length(PatientData_Filenames);
for i = 1:numFiles
    fileName = PatientData_Filenames{i}
    disp(fileName)

    % use readcell() to load annotations.txt into a cell array
    annotations = readcell(fileName, "ExpectedNumVariables", 6);
    annotations(1,:) = [];
    % find the number of events (rows) in the annonotations
    [nr,nc] = size(annotations);
    nEvents = nr;
    
    %% get list of unique ECG annotation types, and count of unique event types
    types = unique(annotations(2:end,3));
    n_types = height(types);
    fprintf('There are %i types of events:\n', n_types);
    disp(types);
    % count up the number of normal, fusion, supraventricular premature, and ventricular premature events
    n_normal = sum(matches(annotations(2:end,3), 'N'));
    n_fusion = sum(matches(annotations(2:end,3), 'F'));
    n_supraventricularPremature = sum(matches(annotations(2:end,3), 'S'));
    n_ventricularPremature = sum(matches(annotations(2:end,3), 'V'));
    % uncomment the following line to display the results
    fprintf('Summary:  %i normal, %i fusion,\n %i supraventricular premature,\n %i ventricular premature\n', ...
        n_normal, n_fusion, n_supraventricularPremature, n_ventricularPremature);
    %% Create Time Stamps for Each Case
    
end





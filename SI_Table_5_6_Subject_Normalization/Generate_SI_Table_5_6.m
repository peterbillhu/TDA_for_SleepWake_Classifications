clear; clc;

%% Step 1 :: Load all featrues.
% Feature vectors are stored in the mat file 'pdfeatNewPS2.mat'.
cd ..;
load('pdfeatNewPS2.mat');
cd SI_Table_5_6_Subject_Normalization;
load('Original_subject_indices_All.mat');

ftH90NewPS2_CGMH = subject_Normalization(ftH90NewPS2_CGMH, Original_subject_indices_Tra);
ftH90NewPS2_DREAM = subject_Normalization(ftH90NewPS2_DREAM, Original_subject_indices_Dream);
ftH90NewPS2_UCD = subject_Normalization(ftH90NewPS2_UCD, Original_subject_indices_UCD);
ftH90NewPS2_Val = subject_Normalization(ftH90NewPS2_Val, Original_subject_indices_Val);

ftR120NewPS2_CGMH = subject_Normalization(ftR120NewPS2_CGMH, Original_subject_indices_Tra);
ftR120NewPS2_DREAM = subject_Normalization(ftR120NewPS2_DREAM, Original_subject_indices_Dream);
ftR120NewPS2_UCD = subject_Normalization(ftR120NewPS2_UCD, Original_subject_indices_UCD);
ftR120NewPS2_Val = subject_Normalization(ftR120NewPS2_Val, Original_subject_indices_Val);
% Set number of random seeds.
numOfSeeds = 1;
% Load features.
% Features defined by filtration of height functions:
v90T = [ftH90NewPS2_CGMH(:,1:16), ftH90NewPS2_CGMH(:,end)]; 
v90V = [ftH90NewPS2_Val(:,1:16), ftH90NewPS2_Val(:,end)]; 
v90Dreams = [ftH90NewPS2_DREAM(:,1:16), ftH90NewPS2_DREAM(:,end)]; 
v90UCD = [ftH90NewPS2_UCD(:,1:16), ftH90NewPS2_UCD(:,end)]; 
% Features defined by filtration of V-R complexes:
v120T = [ftR120NewPS2_CGMH(:,1:16), ftR120NewPS2_CGMH(:,25:40), ftR120NewPS2_CGMH(:,end)];
v120V = [ftR120NewPS2_Val(:,1:16), ftR120NewPS2_Val(:,25:40), ftR120NewPS2_Val(:,end)];
v120Dreams = [ftR120NewPS2_DREAM(:,1:16), ftR120NewPS2_DREAM(:,25:40), ftR120NewPS2_DREAM(:,end)];
v120UCD = [ftR120NewPS2_UCD(:,1:16), ftR120NewPS2_UCD(:,25:40), ftR120NewPS2_UCD(:,end)];

%% Step 2 :: Generate columns of the table.

% Generate SI Table 5 (training on "Dreams")
expName = 'EXP_Table_SI_5_training_on_Dreams';
Subject_run_seeds_Dreams(expName,...
                         numOfSeeds,...
                         [v120T(:,1:end-1) v90T],...
                         [v120V(:,1:end-1) v90V],...
                         [v120Dreams(:,1:end-1) v90Dreams],...
                         [v120UCD(:,1:end-1) v90UCD],...
                         2,...                 %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                         'SVM');
fprintf('%s is Done!\n',expName);

       
% Generate SI Table 6 (training on "UCD")
expName = 'EXP_Table_SI_6_training_on_UCD';
Subject_run_seeds_UCD(expName,...
                      numOfSeeds,...
                      [v120T(:,1:end-1) v90T],...
                      [v120V(:,1:end-1) v90V],...
                      [v120Dreams(:,1:end-1) v90Dreams],...
                      [v120UCD(:,1:end-1) v90UCD],...
                      3,...                 %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                      'SVM');
fprintf('%s is Done!\n',expName);
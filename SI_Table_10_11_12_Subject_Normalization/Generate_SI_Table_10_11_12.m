clear; clc;

%% Step 1 :: Load all featrues
cd ..;
load('pdfeatNewPS2_without_wake.mat');
cd SI_Table_10_11_12_Subject_Normalization;

load('numPatientAll.mat');
load('Subject_indices_without_wake_All.mat');

ftH90NewPS2_CGMH = subject_Normalization(ftH90NewPS2_CGMH, Original_subject_indices_Tra_without_wake);
ftH90NewPS2_DREAM = subject_Normalization(ftH90NewPS2_DREAM, Original_subject_indices_Dream_without_wake);
ftH90NewPS2_UCD = subject_Normalization(ftH90NewPS2_UCD, Original_subject_indices_UCD_without_wake);
ftH90NewPS2_Val = subject_Normalization(ftH90NewPS2_Val, Original_subject_indices_Val_without_wake);

ftR120NewPS2_CGMH = subject_Normalization(ftR120NewPS2_CGMH, Original_subject_indices_Tra_without_wake);
ftR120NewPS2_DREAM = subject_Normalization(ftR120NewPS2_DREAM, Original_subject_indices_Dream_without_wake);
ftR120NewPS2_UCD = subject_Normalization(ftR120NewPS2_UCD, Original_subject_indices_UCD_without_wake);
ftR120NewPS2_Val = subject_Normalization(ftR120NewPS2_Val, Original_subject_indices_Val_without_wake);

numOfCeeds = 20;

v90T = [ftH90NewPS2_CGMH(:,1:16), ftH90NewPS2_CGMH(:,end)]; 
v90V = [ftH90NewPS2_Val(:,1:16), ftH90NewPS2_Val(:,end)]; 
v90Dreams = [ftH90NewPS2_DREAM(:,1:16), ftH90NewPS2_DREAM(:,end)]; 
v90UCD = [ftH90NewPS2_UCD(:,1:16), ftH90NewPS2_UCD(:,end)]; 

v120T = [ftR120NewPS2_CGMH(:,1:16), ftR120NewPS2_CGMH(:,25:40), ftR120NewPS2_CGMH(:,end)];
v120V = [ftR120NewPS2_Val(:,1:16), ftR120NewPS2_Val(:,25:40), ftR120NewPS2_Val(:,end)];
v120Dreams = [ftR120NewPS2_DREAM(:,1:16), ftR120NewPS2_DREAM(:,25:40), ftR120NewPS2_DREAM(:,end)];
v120UCD = [ftR120NewPS2_UCD(:,1:16), ftR120NewPS2_UCD(:,25:40), ftR120NewPS2_UCD(:,end)];

%% Step 2 :: Generate columns of tables
       
% Generate SI Table 10 (training on "Training")
expName = 'EXP_Table_SI_10_training_on_Training';
run_ceeds(expName,...
                  numOfCeeds,...
                  [v120T(:,1:end-1) v90T],...
                  [v120V(:,1:end-1) v90V],...
                  [v120Dreams(:,1:end-1) v90Dreams],...
                  [v120UCD(:,1:end-1) v90UCD],...
                  1,...                 %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                  'SVM');
fprintf('%s is Done!\n',expName);
       
% Generate SI Table 11 (training on "Dreams")
expName = 'EXP_Table_SI_11_training_on_Dreams';
run_ceeds_Dreams(expName,...
                         numOfCeeds,...
                         [v120T(:,1:end-1) v90T],...
                         [v120V(:,1:end-1) v90V],...
                         [v120Dreams(:,1:end-1) v90Dreams],...
                         [v120UCD(:,1:end-1) v90UCD],...
                         2,...                 %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                         'SVM');
fprintf('%s is Done!\n',expName);
       
% Generate SI Table 12 (training on "UCD")
expName = 'EXP_Table_SI_12_training_on_UCD';
run_ceeds_UCD(expName,...
                      numOfCeeds,...
                      [v120T(:,1:end-1) v90T],...
                      [v120V(:,1:end-1) v90V],...
                      [v120Dreams(:,1:end-1) v90Dreams],...
                      [v120UCD(:,1:end-1) v90UCD],...
                      3,...                 %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                      'SVM');
fprintf('%s is Done!\n',expName);

function result = getModel(expName,...                          %% Name of experiment
                           randomCeedNo,...                     %% Input randomCeed for training data sampling
                           pdfeatTrainWLabel,...                %% Training data with labels
                           pdfeatValWLabel,...                  %% Valiadtion (i.e., test) data with labels
                           id_of_training_dataset,...           %% 1 : Training/Validation, 2 : DREAMS, 3 : UCD
                           id_of_test_dataset,...               %% 1 : Training/Validation, 2 : DREAMS, 3 : UCD
                           MODEL_TYPE)                          %% 'SVM' : svm model, 'RT' : random forest tree

%% Step 1 :: Deteremine true label of training dataset
if (id_of_training_dataset == 1) %% i.e., Dataset "Training" or "Validation" provided by CGMH.
    true_label_of_training = 12;
elseif (id_of_training_dataset == 2) %% i.e., Dataset " Dreams"
    true_label_of_training = 4;
else                                        %% i.e., Dataset "UCD"
    true_label_of_training = 1;
end
                       
%% Step 2 :: Load trraining/validation vectors (with labels)
%note that the sum(numPatient) is not equal to length(pdfeatT)
%This is because the preprocessing ones are missing.
pdfeatT = pdfeatTrainWLabel;
% for the validation
pdfeatV = pdfeatValWLabel;

%% Description for DREAMS datasets : 
% Website : http://www.tcts.fpms.ac.be/~devuyst/Databases/DatabaseSpindles/#Format
% Note that in the dream dataset, the label represents:
% 5=wake
% 4=REM stage
% 3=sleep stage S1
% 2=sleep stage S2
% 1=sleep stage S3
% 0=sleep stage S4
% -1=sleep stage movement
% -2 or -3 =unknow sleep stage 

%% Description for UCD datasets : 
% Website : https://physionet.org/pn3/ucddb/
% Note that in the dream dataset, the label represents:
% 0	Wake
% 1	REM
% 2	Stage 1
% 3	Stage 2
% 4	Stage 3
% 5	Stage 4
% 6	Artifact
% 7	Indeterminate

%% Step 3 :: Generate pdfeatT (for training) & pdfeatV (for validation)
pdfeatT = ( getPreprocessPDfeat(pdfeatT) );
pdfeatV = ( getPreprocessPDfeat(pdfeatV) );
% pdfeatT = [zscore(pdfeatT(:,1:end-1)) pdfeatT(:,end)];
% pdfeatV = [zscore(pdfeatV(:,1:end-1)) pdfeatV(:,end)];
% Extract sleep and awake for balance training
W = find(pdfeatT(:,end)==true_label_of_training);
nW = length(W);
S = find(pdfeatT(:,end)~=true_label_of_training);
nS = length(S);
pdfeatW = pdfeatT( W, 1:end) ;
% Determine sample for training by random ceed
rng(randomCeedNo);
rand_per_ind = randperm(nS);

%% Step 4 :: Determine which model the function perfom and rate of number of sleep and wake
if (strcmp(MODEL_TYPE,'SVM') == 1)
    fnW = floor(1*nW); %% SVM
elseif (strcmp(MODEL_TYPE,'RT') == 1)    
    fnW = floor(1*nW); %% RT
end
pdfeatS = pdfeatT( S( rand_per_ind(1:fnW) ), 1:end );
pdfeatT = [pdfeatW; pdfeatS];

%% Step 5 :: Update TruthLab by following the labels defined by different datasets
label = pdfeatT(:, end) == true_label_of_training;
switch id_of_test_dataset
    case 1 %CGMH
        TruthLab = pdfeatV(:, end) == 12;
    case 2 %DREAM
        TruthLab = pdfeatV(:, end) == 4;
    case 3 %UCD
        TruthLab = pdfeatV(:,end) ==1;
end

%% Step 5 :: Generate taining model (SVM or RT)
if (strcmp(MODEL_TYPE,'SVM') == 1)
    svmModel = fitcsvm(pdfeatT(:,1:end-1), label); %% Standard SVM model with linear kernel  & training
    [labelV scoreV] = predict(svmModel,  pdfeatV(:,1:end-1));
    %save(['./Models/', expName, '_', 'SVM', '_', 'ceed', num2str(randomCeedNo), '.mat'], 'svmModel');
elseif (strcmp(MODEL_TYPE,'RT') == 1)
    % 128 || 256
    rtModel = TreeBagger(128,pdfeatT(:,1:end-1), label); %% Standard RT model with 128 trees & training
    [labelV scoreV] = predict(rtModel,  pdfeatV(:,1:end-1));
    % Only for RT
    labelV = cell2mat(labelV);
    labelV = str2num(labelV);
    %save(['./Models/', expName, '_', 'RT', '_', 'ceed', num2str(randomCeedNo), '.mat'], 'rtModel');
end

%% Step 6 :: Compute statistics
TP = length(find((TruthLab .* labelV)==1));
TN = length(find((~TruthLab .* ~labelV)==1));
FN = length(find(TruthLab==1)) - TP;
FP = length(find(~TruthLab==1)) - TN;
SE = TP / (TP + FN);
SP = TN / (TN + FP);
ACC = (TP + TN) / (TP + TN + FP + FN);
PR = TP / (TP + FP);
F1 = 2 * TP / (2 * TP + FP + FN);
P_yes = (TP + FP) * (TP + FN) / (TP + TN + FP + FN)^2;
P_no = (TN + FP) * (TN + FN) / (TP + TN + FP + FN)^2;
P_o = (TP + TN) / (TP + TN + FP + FN);
P_e = P_yes + P_no; 
Kappa = (P_o - P_e) / (1 - P_e);

[X,Y,T,AUC_New,OPTROCPT] = perfcurve(TruthLab, scoreV(:,2), 1);

result = [TP, FP, TN, FN, SE, SP, ACC, PR, F1, AUC_New, Kappa];
end
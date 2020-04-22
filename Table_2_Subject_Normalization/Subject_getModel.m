%% We note that AUC is not computed in the function, it should be computed separately
%% Please consult the record file saved to compute AUC.
%% The output form of result is the row vector:
%% [TP, FP, TN, FN, SE, SP, ACC, PR, F1, Kappa]
function result = Subject_getModel(expName,...                          %% Name of experiment
                                   randomSeedNo,...                     %% Input randomCeed for training data sampling
                                   pdfeatTrainWLabel,...                %% Training data with labels
                                   pdfeatValWLabel,...                  %% Valiadtion (i.e., test) data with labels
                                   id_of_training_dataset,...           %% 1 : Training/Validation, 2 : DREAMS, 3 : UCD
                                   id_of_test_dataset,...               %% 1 : Training/Validation, 2 : DREAMS, 3 : UCD
                                   test_Dataset_Name,...
                                   MODEL_TYPE)                          %% 'SVM' : svm model, 'RT' : random forest tree

                               
load('Subject_indices_without_wake_All.mat');

%% Step 1 :: Deteremine true label of training dataset
if (id_of_training_dataset == 1)     %% i.e., Dataset "Training" or "Validation" provided by CGMH.
    true_label_of_training = 12;
elseif (id_of_training_dataset == 2) %% i.e., Dataset " Dreams"
    true_label_of_training = 4;
else                                 %% i.e., Dataset "UCD"
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
pdfeatT = (getPreprocessPDfeat(pdfeatT));
pdfeatV_buff = pdfeatV;
pdfeatV_buff = (getPreprocessPDfeat(pdfeatV_buff));
ind_new = update_subject_indices(pdfeatV, test_Dataset_Name);
% pdfeatT = [zscore(pdfeatT(:,1:end-1)) pdfeatT(:,end)];
% pdfeatV_buff = [zscore(pdfeatV_buff(:,1:end-1)) pdfeatV_buff(:,end)];
if (length(ind_new) == 0)
    pdfeatV = pdfeatV_buff;
else
    [m_1,n_1] = size(pdfeatV);
    for i = 1 : m_1
        if (length(find(ind_new(:,1) == i)) == 0) %% means it is a regular vector
            pdfeatV(i,:) = pdfeatV_buff(1,:);
            pdfeatV_buff(1,:) = [];
        else
            pdfeatV(i,:) = zeros(1,n_1);
        end
    end
end
% Extract sleep and awake for balance training
W = find(pdfeatT(:,end)==true_label_of_training);
nW = length(W);
S = find(pdfeatT(:,end)~=true_label_of_training);
nS = length(S);
pdfeatW = pdfeatT( W, 1:end) ;
% Determine sample for training by random ceed
rng(randomSeedNo);
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
    svmModel = fitcsvm(pdfeatT(:,1:end-1), label); %% Standard 
    [labelV scoreV] = predict(svmModel,  pdfeatV(:,1:end-1));
elseif (strcmp(MODEL_TYPE,'RT') == 1)
    % 128 || 256
    rtModel = TreeBagger(128,pdfeatT(:,1:end-1), label); 
    [labelV scoreV] = predict(rtModel,  pdfeatV(:,1:end-1));
    % Only for RT
    labelV = cell2mat(labelV);
    labelV = str2num(labelV);
end

%% Step 6 :: Compute statistics
if (strcmp(test_Dataset_Name, 'Tra') == 1) %% CGMH
    numPatient = numPatientTra_without_wake;
    Subject_Info = Original_subject_indices_Tra_without_wake;
    Subject_Info(ind_new) = -1;
end
if(strcmp(test_Dataset_Name, 'Val') == 1) %% Validation
    numPatient = numPatientVal_without_wake;
    Subject_Info = Original_subject_indices_Val_without_wake;
    Subject_Info(ind_new) = -1;
end
if(strcmp(test_Dataset_Name, 'Dream') == 1) %% Dream
    numPatient = numPatientDream_without_wake;
    Subject_Info = Original_subject_indices_Dream_without_wake;
    Subject_Info(ind_new) = -1;
end
if(strcmp(test_Dataset_Name, 'UCD') == 1) %% UCD
    numPatient = numPatientUCD_without_wake;
    Subject_Info = Original_subject_indices_UCD_without_wake;
    Subject_Info(ind_new) = -1;
end
   
[m,n] = size(numPatient);
result = [];
AUC = [];

for i = 1 : m
    ind = (Subject_Info(:)==i); 
    TruthLab_Buff = TruthLab(ind, :);
    labelV_Buff = labelV(ind, :);
    AUC = scoreV(ind,2)';
    
       %% Comupute Statistics
    TP = length(find((TruthLab_Buff .* labelV_Buff)==1));
    TN = length(find((~TruthLab_Buff .* ~labelV_Buff)==1));
    FN = length(find(TruthLab_Buff==1)) - TP;
    FP = length(find(~TruthLab_Buff==1)) - TN;
    if ((TP + FN) == 0)
        continue;
    else
        SE = TP / (TP + FN);
    end
    if ((TN + FP) == 0)
        continue;
    else
        SP = TN / (TN + FP);
    end
    ACC = (TP + TN) / (TP + TN + FP + FN);
    if ((TP + FP) == 0)
        continue;
    else
        PR = TP / (TP + FP);
    end
    if ((2 * TP + FP + FN) == 0)
        continue;
    else
        F1 = 2 * TP / (2 * TP + FP + FN);
    end
    
    P_yes = (TP + FP) * (TP + FN) / (TP + TN + FP + FN)^2;
    P_no = (TN + FP) * (TN + FN) / (TP + TN + FP + FN)^2;
    P_o = (TP + TN) / (TP + TN + FP + FN);
    P_e = P_yes + P_no;
    if (P_e == 1)
        continue;
    else
        Kappa = (P_o - P_e) / (1 - P_e);
    end
  
    Value = isnan([TP, FP, TN, FN, SE, SP, ACC, PR, F1, Kappa]);
    if (length(find(Value == 1)) >= 1) %% it means that features(i,:) contains nan entries.
       continue;
    end
    [X,Y,T,AUC_New,OPTROCPT] = perfcurve(TruthLab_Buff, scoreV(ind,2), 1);
    result = [result; [TP, FP, TN, FN, SE, SP, ACC, PR, F1, AUC_New, Kappa]];
    %save(['./Table_Infos/', expName, '_', MODEL_TYPE, '_', 'ceed', num2str(randomSeedNo), '_AUC_Array_Subject_', num2str(i), '.mat'], 'AUC');
    %save(['./Table_Infos/', expName, '_', MODEL_TYPE, '_', 'ceed', num2str(randomSeedNo), '_AUC_Array_Subject_', num2str(i), '.mat'], 'AUC');
end 
end
function result = Subject_getModel_3_classes(expName,...                          %% Name of experiment
                                             randomSeedNo,...                     %% Input randomCeed for training data sampling
                                             pdfeatTrainWLabel,...                %% Training data with labels
                                             pdfeatValWLabel,...                  %% Valiadtion (i.e., test) data with labels
                                             id_of_training_dataset,...           %% 1 : Training/Validation, 2 : DREAMS, 3 : UCD
                                             test_Dataset_Name,...
                                             id_of_test_dataset)                  %% 1 : Training/Validation, 2 : DREAMS, 3 : UCD
                                     
load('numPatientAll.mat');
load('Original_subject_indices_All.mat');
                                 
%% Step 1 :: Load trraining/validation vectors (with labels)
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
ind_new = (update_subject_indices(pdfeatV, test_Dataset_Name));
% pdfeatT = [zscore(pdfeatT(:,1:end-1)) pdfeatT(:,end)];
% pdfeatV_buff = [zscore(pdfeatV_buff(:,1:end-1)) pdfeatV_buff(:,end)];
[m_1,n_1] = size(pdfeatV);
for i = 1 : m_1
    if (length(find(ind_new(:,1) == i)) == 0) %% means it is a regular vector
        pdfeatV(i,:) = pdfeatV_buff(1,:);
        pdfeatV_buff(1,:) = [];
    else
        pdfeatV(i,:) = zeros(1,n_1);
    end
end

%% Step 4 :: Extract sleep and awake and rem (with random seed)
if (id_of_training_dataset == 1)        %% i.e., Dataset provided by CGMH.
    W = find(pdfeatT(:,end)== 11); 
    nW = length(W);
    R = find(pdfeatT(:,end)== 12);
    nR = length(R);
    S = find(pdfeatT(:,end) ~= 11 & pdfeatT(:,end) ~= 12);
    nS = length(S);
elseif (id_of_training_dataset == 2)    %% i.e., Dataset " Dreams"
    W = find(pdfeatT(:,end)== 5); 
    nW = length(W);
    R = find(pdfeatT(:,end)== 4);
    nR = length(R);
    S = find(pdfeatT(:,end) ~= 5 & pdfeatT(:,end) ~= 4);
    nS = length(S);
else                                    %% i.e., Dataset "UCD"
    W = find(pdfeatT(:,end)== 0); 
    nW = length(W);
    R = find(pdfeatT(:,end)== 1);
    nR = length(R);
    S = find(pdfeatT(:,end) ~= 0 & pdfeatT(:,end) ~= 1);
    nS = length(S);
end

% Determine sample for training by random seed
pdfeatR = pdfeatT(R, 1:end);
pdfeatW = pdfeatT(W, 1:end);
rng(randomSeedNo);
rand_per_ind = randperm(nS);
fnW = floor(1.1*nW);
pdfeatS = pdfeatT( S( rand_per_ind(1:fnW) ), 1:end ) ;
pdfeatT = [pdfeatW; pdfeatR; pdfeatS];

%% Step 5 :: Deteremine true label of training dataset
if (id_of_training_dataset == 1)        %% i.e., Dataset "Training" or "Validation" provided by CGMH.
    labelW = (pdfeatT(:, end) == 11);
    labelR = (pdfeatT(:, end) == 12);
    label = 2*labelW + labelR;
elseif (id_of_training_dataset == 2)    %% i.e., Dataset " Dreams"
    labelW = (pdfeatT(:, end) == 5);
    labelR = (pdfeatT(:, end) == 4);
    label = 2*labelW + labelR;
else                                    %% i.e., Dataset "UCD"
    labelW = (pdfeatT(:,end) == 0);
    labelR = (pdfeatT(:, end) == 1);
    label = 2*labelW + labelR;
end

% Label modification for testing dataset
switch id_of_test_dataset
    case 1 %CGMH
        TruthLabW = (pdfeatV(:, end) == 11);
        TruthLabR = (pdfeatV(:, end) == 12);
        TruthLab = 2*TruthLabW + TruthLabR;
    case 2 %DREAM
        TruthLabW = (pdfeatV(:, end) == 5);
        TruthLabR = (pdfeatV(:, end) == 4);
        TruthLab = 2*TruthLabW + TruthLabR;
    case 3
        TruthLabW = pdfeatV(:,end) ==0;
        TruthLabR = (pdfeatV(:, end) == 1);
        TruthLab = 2*TruthLabW + TruthLabR;  
end

%% Step 6 :: Generate taining model (for RT only)
svmModel = fitcecoc(pdfeatT(:,1:end-1), label);
[labelV scoreV] = predict(svmModel,  pdfeatV(:,1:end-1));
%% save(['./Models/', expName, '_', 'SVM', '_', 'ceed', num2str(randomCeedNo), '.mat'], 'svmModel');

%% Step 6 :: Evaluation (compute statistics)
if (strcmp(test_Dataset_Name, 'Tra') == 1) %% CGMH
    numPatient_ = numPatient;
    Subject_Info = Original_subject_indices_Tra;
    Subject_Info(ind_new) = -1;
end
if(strcmp(test_Dataset_Name, 'Val') == 1) %% Validation
    numPatient_ = numPatientVal;
    Subject_Info = Original_subject_indices_Val;
    Subject_Info(ind_new) = -1;
end
if(strcmp(test_Dataset_Name, 'Dream') == 1) %% Dream
    numPatient_ = numPatientDream;
    Subject_Info = Original_subject_indices_Dream;
    Subject_Info(ind_new) = -1;
end
if(strcmp(test_Dataset_Name, 'UCD') == 1) %% UCD
    numPatient_ = numPatientUCD;
    Subject_Info = Original_subject_indices_UCD;
    Subject_Info(ind_new) = -1;
end
   
[m,n] = size(numPatient_);
result = [];

    for i = 1 : m
        ind = (Subject_Info(:)==i); 
        TruthLab_Buff = TruthLab(ind, :);
        labelV_Buff = labelV(ind, :);

        S22=length(find((TruthLab_Buff.*labelV_Buff)==4));
        S11=length(find((TruthLab_Buff.*labelV_Buff)==1));
        S00=length(find((TruthLab_Buff+labelV_Buff)==0));

        S21=length(find(TruthLab_Buff== 2 & labelV_Buff == 1));
        S20=length(find(TruthLab_Buff== 2 & labelV_Buff == 0));
        S12=length(find(TruthLab_Buff== 1 & labelV_Buff == 2));
        S10=length(find(TruthLab_Buff== 1 & labelV_Buff == 0));
        S02=length(find(TruthLab_Buff== 0 & labelV_Buff == 2));
        S01=length(find(TruthLab_Buff== 0 & labelV_Buff == 1));
        
        if (S20 + S21 + S22 == 0 ||...
            S10 + S11 + S12 == 0 ||...    
            S00 + S01 + S02 == 0 ||...
            S02 + S12 + S22 == 0 ||...
            S01 + S11 + S21 == 0 ||...
            S00 + S10 + S20 == 0)
            continue;
        end
        
        SE2 = S22 / (S20 + S21 + S22);
        SE1 = S11 / (S10 + S11 + S12);
        SE0 = S00 / (S00 + S01 + S02);
        
        pP2 = S22 / (S02 + S12 + S22);
        pP1 = S11 / (S01 + S11 + S21);
        pP0 = S00 / (S00 + S10 + S20);
        
        totoalSubjects = (S22+S11+S00+S21+S20+S12+S10+S02+S01);
        Acc = (S22 + S11 + S00) / totoalSubjects;
        p_o = Acc;
        p_e = ((S20 + S21 + S22) * (S02 + S12 + S22) + (S10 + S11 + S12) * (S01 + S11 + S21) + (S00 + S01 + S02) * (S00 + S10 + S20)) / (totoalSubjects * totoalSubjects);
        Kappa = (p_o - p_e) / (1 - p_e);
        
        Value = isnan([S22,S11,S00,S21,S20,S12,S10,S02,S01,SE2,SE1,SE0,pP2,pP1,pP0,Acc,Kappa]);
        if (length(find(Value == 1)) >= 1) %% it means that features(i,:) contains nan entries.
           continue;
        end
        result = [result; [S22,S11,S00,S21,S20,S12,S10,S02,S01,SE2,SE1,SE0,pP2,pP1,pP0,Acc,Kappa]];    
    end
end
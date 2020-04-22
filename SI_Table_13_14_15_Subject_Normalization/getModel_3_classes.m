function result = getModel_3_classes(expName,...                          %% Name of experiment
                                     randomCeedNo,...                     %% Input randomCeed for training data sampling
                                     pdfeatTrainWLabel,...                %% Training data with labels
                                     pdfeatValWLabel,...                  %% Valiadtion (i.e., test) data with labels
                                     id_of_training_dataset,...           %% 1 : Training/Validation, 2 : DREAMS, 3 : UCD
                                     id_of_test_dataset)                  %% 1 : Training/Validation, 2 : DREAMS, 3 : UCD
                                     
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
pdfeatT = ( getPreprocessPDfeat(pdfeatT) );
pdfeatV = ( getPreprocessPDfeat(pdfeatV) );
% pdfeatT = [zscore(pdfeatT(:,1:end-1)) pdfeatT(:,end)];
% pdfeatV = [zscore(pdfeatV(:,1:end-1)) pdfeatV(:,end)];

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
rng(randomCeedNo);
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
%save(['./Models/', expName, '_', 'SVM', '_', 'ceed', num2str(randomCeedNo), '.mat'], 'svmModel');

%% Evaluation (compute statistics)
S22=length(find((TruthLab.*labelV)==4));
S11=length(find((TruthLab.*labelV)==1));
S00=length(find((TruthLab+labelV)==0));

S21=length(find(TruthLab== 2 & labelV == 1));
S20=length(find(TruthLab== 2 & labelV == 0));
S12=length(find(TruthLab== 1 & labelV == 2));
S10=length(find(TruthLab== 1 & labelV == 0));
S02=length(find(TruthLab== 0 & labelV == 2));
S01=length(find(TruthLab== 0 & labelV == 1));

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

result = [S22,S11,S00,S21,S20,S12,S10,S02,S01,SE2,SE1,SE0,pP2,pP1,pP0,Acc,Kappa];
end
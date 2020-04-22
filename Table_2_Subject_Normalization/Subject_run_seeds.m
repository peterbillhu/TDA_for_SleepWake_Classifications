function Subject_run_seeds(Exp_Name,...                     %% Experiment name
                           numOfSeeds,...                   %% Number of ceeds
                           pdfeatTrainWLabel,...            %% features of Trianing dataset 
                           pdfeatValWLabel,...              %% features of Validation dataset
                           pdfeatDREAMWLabel,...            %% features of Dreams dataset
                           pdfeatTUCDwLabel,...             %% features of UCDSB dataset
                           Id_of_training_set,...           %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                           model_Mode)                      %% training model :: 'SVM' or 'RT'

%% Step 1 :: Final statistics
% Statistic Targets are ::
% [TP, TN, FN, FP, SE, SP, ACC, PR, F1, Kappa, scoreV(:,2)'] (defined in getModel_subject.m)
% where scoreV(:,2)' is used for computing AUC.
collectionTra     = [];
collectionVal     = [];
collectionDreams  = [];
collectionUCD     = [];

%% Step 2 :: Ceed Iterations
for ceed = 1 : numOfSeeds
    resultTra = Subject_getModel([Exp_Name, '_Training'],...      %% Name of experiment
                                 ceed,...                         %% Input randomCeed for training data sampling
                                 [pdfeatTrainWLabel],...          %% Training data with labels
                                 [pdfeatTrainWLabel],...          %% Valiadtion (i.e., test) data with labels
                                 Id_of_training_set,...           %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                                 1,...                            %% ID of test set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                                 'Tra',...
                                 model_Mode);                     %% 'SVM' : svm model, 'RT' : random forest tree
    collectionTra = [collectionTra, resultTra'];                  
    
    resultVal = Subject_getModel([Exp_Name, '_Validation'],...    %% Name of experiment
                                 ceed,...                         %% Input randomCeed for training data sampling
                                 [pdfeatTrainWLabel],...          %% Training data with labels
                                 [pdfeatValWLabel],...            %% Valiadtion (i.e., test) data with labels
                                 Id_of_training_set,...           %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                                 1,...                            %% ID of test set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                                 'Val',...
                                 model_Mode);                     %% 'SVM' : svm model, 'RT' : random forest tree
     collectionVal = [collectionVal, resultVal'];
     
     resultDreams = Subject_getModel([Exp_Name, '_Dreams'],...    %% Name of experiment
                                     ceed,...                     %% Input randomCeed for training data sampling
                                     [pdfeatTrainWLabel],...      %% Training data with labels
                                     [pdfeatDREAMWLabel],...      %% Valiadtion (i.e., test) data with labels
                                     Id_of_training_set,...       %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                                     2,...                        %% ID of test set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                                     'Dream',...
                                     model_Mode);                 %% 'SVM' : svm model, 'RT' : random forest tree
     collectionDreams = [collectionDreams, resultDreams'];
     
     resultUCD = Subject_getModel([Exp_Name, '_UCD'],...          %% Name of experiment
                                  ceed,...                        %% Input randomCeed for training data sampling
                                  [pdfeatTrainWLabel],...         %% Training data with labels
                                  [pdfeatTUCDwLabel],...          %% Valiadtion (i.e., test) data with labels
                                  Id_of_training_set,...          %% ID of training set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                                  3,...                           %% ID of test set :: 1 : Trianing/Validation, 2 : DREAMS, 3 : UCD
                                  'UCD',...
                                  model_Mode);                    %% 'SVM' : svm model, 'RT' : random forest tree
     collectionUCD = [collectionUCD, resultUCD'];    
end

%% Step 3 :: Save results (under the directory ./Table_Infos/)
save(['./Table_Infos/', Exp_Name, '_Training', '.mat'], 'collectionTra');
save(['./Table_Infos/', Exp_Name, '_Validation', '.mat'], 'collectionVal');
save(['./Table_Infos/', Exp_Name, '_Dreams', '.mat'], 'collectionDreams');
save(['./Table_Infos/', Exp_Name, '_UCD', '.mat'], 'collectionUCD');

%% Step 4 :: Save average statitics
result_Tra = statistics_in_avg(collectionTra);
result_Val = statistics_in_avg(collectionVal);
result_Dreams = statistics_in_avg(collectionDreams);
result_UCD = statistics_in_avg(collectionUCD);

save(['./Table_Infos/', Exp_Name, '_Training_avg', '.mat'], 'result_Tra');
save(['./Table_Infos/', Exp_Name, '_Validation_avg', '.mat'], 'result_Val');
save(['./Table_Infos/', Exp_Name, '_Dreams_avg', '.mat'], 'result_Dreams');
save(['./Table_Infos/', Exp_Name, '_UCD_avg', '.mat'], 'result_UCD');

end
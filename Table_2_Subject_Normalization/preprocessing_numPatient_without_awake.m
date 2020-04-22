% % % %% Original
% % % 
% % % %% CGMH-training
% % % Original_subject_indices_Tra = 1 : 66021;
% % % beginIndex = 1;
% % % for i = 1 : 89
% % %     numOfEpochs = numPatient(i,1);
% % %     for j = beginIndex : beginIndex + numOfEpochs - 1
% % %         Original_subject_indices_Tra(j) = i;
% % %     end
% % %     beginIndex = beginIndex + numOfEpochs;
% % % end
% % % 
% % % %% CGMH-validation
% % % Original_subject_indices_Val = 1 : 19570;
% % % beginIndex = 1;
% % % for i = 1 : 27
% % %     numOfEpochs = numPatientVal(i,1);
% % %     for j = beginIndex : beginIndex + numOfEpochs - 1
% % %         Original_subject_indices_Val(j) = i;
% % %     end
% % %     beginIndex = beginIndex + numOfEpochs;
% % % end
% % % 
% % % %% Dream
% % % Original_subject_indices_Dream = 1 : 19042;
% % % beginIndex = 1;
% % % for i = 1 : 20
% % %     numOfEpochs = numPatientDream(i,1);
% % %     for j = beginIndex : beginIndex + numOfEpochs - 1
% % %         Original_subject_indices_Dream(j) = i;
% % %     end
% % %     beginIndex = beginIndex + numOfEpochs;
% % % end
% % % 
% % % %% UCD
% % % Original_subject_indices_UCD = 1 : 19769;
% % % beginIndex = 1;
% % % for i = 1 : 25
% % %     numOfEpochs = numPatientUCD(i,1);
% % %     for j = beginIndex : beginIndex + numOfEpochs - 1
% % %         Original_subject_indices_UCD(j) = i;
% % %     end
% % %     beginIndex = beginIndex + numOfEpochs;
% % % end

% % % Step 1 :: Load all featrues
% % load('pdfeatNewPS2.mat');
% % 
% % %% CGMH
% % % numPatient_Tra_without_wake
% % [m,n] = size(numPatient);
% % beginIndex = 1;
% % for i = 1 : m
% %     numOfEpochs = numPatient(i,1);
% %     COUNTER = 0;
% %     for j = beginIndex : beginIndex + numOfEpochs - 1
% %         if (ftH90NewPS2_CGMH(j,end) >= 12)
% %             COUNTER = COUNTER + 1;
% %         end
% %     end
% %     Original_subject_indices_Tra(i) = COUNTER;
% %     beginIndex = beginIndex + numOfEpochs;
% % end
% % 
% % % numPatient_Tra_without_wake
% % [m,n] = size(numPatientVal);
% % beginIndex = 1;
% % for i = 1 : m
% %     numOfEpochs = numPatientVal(i,1);
% %     COUNTER = 0;
% %     for j = beginIndex : beginIndex + numOfEpochs - 1
% %         if (ftH90NewPS2_Val(j,end) >= 12)
% %             COUNTER = COUNTER + 1;
% %         end
% %     end
% %     Original_subject_indices_Val(i) = COUNTER;
% %     beginIndex = beginIndex + numOfEpochs;
% % end
% % 
% % %% Dream
% % [m,n] = size(numPatientDream);
% % beginIndex = 1;
% % for i = 1 : m
% %     numOfEpochs = numPatientDream(i,1);
% %     COUNTER = 0;
% %     for j = beginIndex : beginIndex + numOfEpochs - 1
% %         if (ftH90NewPS2_DREAM(j,end) <= 4)
% %             COUNTER = COUNTER + 1;
% %         end
% %     end
% %     Original_subject_indices_Dream(i) = COUNTER;
% %     beginIndex = beginIndex + numOfEpochs;
% % end
% % 
% % %% UCD
% % [m,n] = size(numPatientUCD);
% % beginIndex = 1;
% % for i = 1 : m
% %     numOfEpochs = numPatientUCD(i,1);
% %     COUNTER = 0;
% %     for j = beginIndex : beginIndex + numOfEpochs - 1
% %         if (ftH90NewPS2_UCD(j,end) >= 1)
% %             COUNTER = COUNTER + 1;
% %         end
% %     end
% %     Original_subject_indices_UCD(i) = COUNTER;
% %     beginIndex = beginIndex + numOfEpochs;
% % end
% % 
% % fprintf('Done!\n');

%% Original

%% CGMH-training
Original_subject_indices_Tra_without_wake = 1 : 56267;
beginIndex = 1;
for i = 1 : 89
    numOfEpochs = numPatientTra_without_wake(i,1);
    for j = beginIndex : beginIndex + numOfEpochs - 1
        Original_subject_indices_Tra_without_wake(j) = i;
    end
    beginIndex = beginIndex + numOfEpochs;
end

%% CGMH-validation
Original_subject_indices_Val_without_wake = 1 : 16030;
beginIndex = 1;
for i = 1 : 27
    numOfEpochs = numPatientVal_without_wake(i,1);
    for j = beginIndex : beginIndex + numOfEpochs - 1
        Original_subject_indices_Val_without_wake(j) = i;
    end
    beginIndex = beginIndex + numOfEpochs;
end

%% Dream
Original_subject_indices_Dream_without_wake = 1 : 15780;
beginIndex = 1;
for i = 1 : 20
    numOfEpochs = numPatientDream_without_wake(i,1);
    for j = beginIndex : beginIndex + numOfEpochs - 1
        Original_subject_indices_Dream_without_wake(j) = i;
    end
    beginIndex = beginIndex + numOfEpochs;
end

%% UCD
Original_subject_indices_UCD_without_wake = 1 : 15572;
beginIndex = 1;
for i = 1 : 25
    numOfEpochs = numPatientUCD_without_wake(i,1);
    for j = beginIndex : beginIndex + numOfEpochs - 1
        Original_subject_indices_UCD_without_wake(j) = i;
    end
    beginIndex = beginIndex + numOfEpochs;
end

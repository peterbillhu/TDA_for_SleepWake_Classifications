# TDA_for_SleepWake_Classifications
Released codes for the paper:  

"A persistent homology approach to heart rate variability analysis with an application to sleep-wake classification"

Authors: Yu-Min Chung, Chuan-Shen Hu, Yu-Lun Lo, and Hau-Tieng Wu

=======================================================================================================================================

**To launch the codes, please follow the steps:

Step 1. Download the .rar file Released_Codes_Subject_Normalization_2020_04_23_Only_Codes, and unzip it.

Step 2. Download .mat files: pdfeatNewPS2, pdfeatNewPS2_without_wake, pdfeatR120H2_Dreams, and pdfeatR120H2_UCD_Val. Put them in the folder of the launch.m which is located. The download link: https://drive.google.com/drive/folders/1QHNcQOoWEl-2eptHySNlLyYwiUg_yLV8?usp=sharing

Step 3. Execute lauch.m by Matlab, then all tables will be generated in corresponding folders, these folders are named "Table_Infos" under the following folders:

Table_1_Subject_Normalization                                 : Subject, 1 seed, Training on Training, Sleep versus Wake

Table_2_Subject_Normalization                                 : Subject, 1 seed, Training on Training, REM versus non-REM

Table_3_Subject_Normalization                                 : Subject, 1 seed, Training on Training, Three classes

SI_Table_1_2_Subject_Normalization                            : Subject, 1 seed, Training on Dreams & UCD, Sleep versus Wake

SI_Table_3_4_Subject_Normalization                            : Subject, 1 seed, Training on Dreams & UCD, REM versus non-REM

SI_Table_5_6_Subject_Normalization                            : Subject, 1 seed, Training on Dreams & UCD, Three classes 

SI_Table_7_8_9_Subject_Normalization                          : non-Subject, 20 seeds, Training on Training & Dreams & UCD, Sleep versus Wake

SI_Table_10_11_12_Subject_Normalization                       : non-Subject, 20 seeds, Training on Training & Dreams & UCD, REM versus non-REM

SI_Table_13_14_15_Subject_Normalization                       : non-Subject, 20 seeds, Training on Training & Dreams & UCD, Three classes

SI_Table_16_17_Subject_Normalization                          : comparison for H and VR features: Subject, 1 seed, Training on Training, Sleep versus Wake

SI_Table_18_19_Subject_Normalization                          : Add VR-H2 features: Subject, 1 seed, Training on Dreams & UCD, Sleep versus Wake

=======================================================================================================================================

Except using launch.m, you can just generate certain tables you concern: For each Folder, execute the Matlab .m file named "Generate_Table_(...)" to obtain the corresponding table(s). 

The result would be stored under the fold "Table_Infos". For example, the file "EXP_Table_1_training_on_Training_UCD_avg.mat" means the column of  [TP, FP, TN, FN, SE, SP, ACC, PR, F1, AUC, Kappa] with respect to the testing dataset UCD. Or for the 2 classes classification, a column represent satistics [S22,S11,S00,S21,S20,S12,S10,S02,S01,SE2,SE1,SE0,pP2,pP1,pP0,Acc,Kappa].

Because the functions for computing AUC in Matlab might not be launched successfully in certain systems, if the code in each folder can not be executed successfully, please use "%" to mark the statement "[X,Y,T,AUC_New,OPTROCPT] = perfcurve(TruthLab, scoreV(:,2), 1);" in the file "Subject_getModel.m" or "getModel.m".

All codes can be executed successfully by Matlab 2019 (equipped with full Mathwork packages) under the Ubuntu system.

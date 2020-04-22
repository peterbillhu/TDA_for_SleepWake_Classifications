1. To obtain Table 3, you only need to execute .m file "Generate_Table_3" direcly.

2. The output tables are saved under the folder "Table_Infos", which is named of the form "EXP_Table_3_training_on_Training_XXXX_avg.mat", where the XXXX is name of testing dataset. The form of each mat file is a 17 by 2 matrix, where the rows represent

 [S22,S11,S00,S21,S20,S12,S10,S02,S01,SE2,SE1,SE0,pP2,pP1,pP0,Acc,Kappa]

respectively. The first column and the second column represent means and standard deviations among subjects.

3. Because the functions for computing AUC in Matlab can not be launched successfully in certain systems, the value is not included in the mat files, and they are saved under folder "Table_Infos" and named of the form "EXP_Table_3_training_on_Training_SVM_ceed1_AUC_Array_Subject_XXX.mat", where XXX denotes the number of the subject. One can compute AUC by consultting this file.
function newFeatures = subject_Normalization(inputFeatures, indices)

%% Number of subjects
Number_of_subjects = max(indices);
indices = indices';
[m,n] = size(inputFeatures);

for i = 1 : m
       %% Check that whether current row contains nan or not
    if (max(isnan(inputFeatures(i,:))) == 1)  %% it means that the row contains nan entries
        indices(i,1) = -1;
    end
end

newFeatures = inputFeatures;

for i = 1 : Number_of_subjects
     %% Subject Normalization
     sub_idx = find(indices(:,1) == i);    
     newFeatures(sub_idx,1:end-1) = zscore(newFeatures(sub_idx,1:end-1));
end
    
end
function output = update_subject_indices(features, test_Dataset_Name)
    
    [m,n] = size(features);
    output = [];
    load('Original_subject_indices_All.mat');
    
       %% Pick True indices 
    if (strcmp(test_Dataset_Name, 'Tra') == 1) %% CGMH
        subject_indices = Original_subject_indices_Tra;
    end
    if(strcmp(test_Dataset_Name, 'Val') == 1) %% Validation
        subject_indices = Original_subject_indices_Val;
    end
    if(strcmp(test_Dataset_Name, 'Dream') == 1) %% Dream
        subject_indices = Original_subject_indices_Dream;
    end
    if(strcmp(test_Dataset_Name, 'UCD') == 1) %% UCD
        subject_indices = Original_subject_indices_UCD;
    end
    
       %% Find nan terms
    for i = 1 : m
        Value = isnan(features(i,:));
        if (length(find(Value == 1)) >= 1) %% it means that features(i,:) contains nan entries.
            output = [output; i];
        end
    end

end
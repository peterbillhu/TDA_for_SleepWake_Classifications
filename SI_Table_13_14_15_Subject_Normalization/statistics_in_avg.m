%% The following function comuputes average statistic targets 
% [TP, TN, FN, FP, SE, SP, ACC, PR, F1, Kappa] (except AUC)
function result = statistics_in_avg(collection)

% The first column of result is avgs of statistic targets
% The second column of result is stds of statistic targets
[m, n] = size(collection);
result = zeros(m,2);
for i = 1 : m
    buff = collection(i,:);
    result(i,1) = mean(buff);
    result(i,2) = std(buff);
end
end
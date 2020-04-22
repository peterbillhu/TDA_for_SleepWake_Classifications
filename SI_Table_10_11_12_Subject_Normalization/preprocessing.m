clear; clc;

% Step 1 :: Load all featrues
load('pdfeatNewPS2.mat');

%% CGMH
ind = (ftH90NewPS2_CGMH(:,end)>=12); ftH90NewPS2_CGMH = ftH90NewPS2_CGMH(ind, :);
ind = (ftH90NewPS2_Val(:,end)>=12); ftH90NewPS2_Val = ftH90NewPS2_Val(ind, :);
ind = (ftR120NewPS2_CGMH(:,end)>=12); ftR120NewPS2_CGMH = ftR120NewPS2_CGMH(ind, :);
ind = (ftR120NewPS2_Val(:,end)>=12); ftR120NewPS2_Val = ftR120NewPS2_Val(ind, :);

%% Dream
ind = (ftH90NewPS2_DREAM(:,end)<=4); ftH90NewPS2_DREAM = ftH90NewPS2_DREAM(ind, :);
ind = (ftR120NewPS2_DREAM(:,end)<=4); ftR120NewPS2_DREAM = ftR120NewPS2_DREAM(ind, :);

%% UCD
ind = (ftH90NewPS2_UCD(:,end)>=1); ftH90NewPS2_UCD = ftH90NewPS2_UCD(ind, :);
ind = (ftR120NewPS2_UCD(:,end)>=1); ftR120NewPS2_UCD = ftR120NewPS2_UCD(ind, :);
fprintf('Done!\n');
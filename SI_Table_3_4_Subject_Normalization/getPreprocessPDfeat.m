function pmat = getPreprocessPDfeat(pdfeat)

[n, numTS] = size(pdfeat);
pmat = pdfeat;
[n,m] = size(pdfeat);
%% After z-normalization, matrices may contain nan entires. The following process is to reduce nan numbers.
    for i = 1:m-1
        pmat = pmat( find( ~isnan(pmat(:,i))), :);
        pmat = pmat( find( pmat(:,i)<1e8), :);
    end
end
function [corr,ix,jx] = corr_comp(filein,ix,jx)
% Calculate Pearson correlation between two gene expression matrices
% Filein contains gene expression matrix dm, number of samples ns

load(filein);
clear ng h;

half = false;
if jx==0
    jx = ix;
    half = true;
end

dm = dm';
corr = (dm(:,ix)'*dm(:,jx))/(ns-1);

if half
    corr = corr - diag(ones(1,size(corr,1))); % Remove autocorrelation
end
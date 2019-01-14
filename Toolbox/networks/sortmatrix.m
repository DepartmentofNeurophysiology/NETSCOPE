function [order,max_comp] = sortmatrix(corr)
% Sort a matrix so that variables with the same principal component are
% next to each other.
% file: file containing MI matrix
% n: number of principal components to use for sorting

%load(file,'corr');

% THIS DOES NOT WORK
% Remove all-zero genes (they form one cluster)
%genes = sum(corr)>0;
%corr = corr(genes,genes);

ng = size(corr,1);
max_comp = zeros(ng,ng-1);
[~,sc] = pca(corr);
clear corr;

for i = 1:ng
    [~,j] = sort(sc(i,:),'descend');
    max_comp(i,:) = j;
end

[~,order] = sortrows(max_comp);
%order = [order;find(~genes)'];
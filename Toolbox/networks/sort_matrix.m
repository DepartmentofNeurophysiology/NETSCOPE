function [order,max_comp] = sort_matrix(mat,ncomps)
%% Sort network nodes by similarity in connectivity
% Use PCA to find similarities in the connectivity profiles of nodes, and
% then sort them so that nodes with the same PC are next to each other.
% 
% [order,max_comp] = sort_matrix(mat,ncomps)
% 
% Input:
% mat:      N by N network matrix
% ncomps:   (optional) number of components to use (to refine sorting).
%           Default is maximum which is N-1.
% 
% Output:
% order:    new order of the nodes so that mat(order,order) is the sorted
%           matrix.
% max_comp: N by ncomps matrix with the maximum component of each node

n = size(mat,1);
conn = find(sum(mat,1) ~= 0);
nconn = length(conn);
if nargin == 1
    ncomps = nconn-1;
end
max_comp = nan(n,ncomps);
[~,scores] = pca(mat(conn,conn));

for i = 1:nconn
    [~,j] = sort(scores(i,:),'descend');
    max_comp(conn(i),:) = j(1:ncomps);
end
[~,order] = sortrows(max_comp);
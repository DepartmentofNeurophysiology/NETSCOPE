function [sps,gcc] = sparsify_network(mat)
%% Remove indirect links from the network using network sparsification
% This function removes links from that network that are the result of
% indirect correlations. This is done by network sparsification based on
% the Data Processing Inequality. This function iterates over all triangles
% in the network and removes the weakest links. This can also be used to
% calculate the network Global Clustering Coefficient.
% 
% [sps,gcc] = sparsify_network(mat)
% 
% Input:
% mat:  network matrix
% 
% Output:
% sps:  sparsified network matrix
% gcc:  global clustering coefficient

sps = tril(mat,-1);
[s,t] = find(sps>0); % Edge indices (source-target, s>t)
gcc = 0;

for i = 1:length(s)
    u = find(mat(s(i),1:t(i))>0 & mat(t(i),1:t(i))>0); % Edge triangular neighbors
    u(u==s(i) | u==t(i)) = []; % Don't double count edge i
    gcc = gcc+length(u);
    for j = 1:length(u)
        if mat(s(i),t(i)) < mat(s(i),u(j)) && mat(s(i),t(i)) < mat(t(i),u(j))
            sps(s(i),t(i)) = 0;
        elseif mat(t(i),u(j)) < mat(s(i),u(j)) && mat(t(i),u(j)) < mat(s(i),t(i))
            sps(t(i),u(j)) = 0;
        elseif mat(s(i),u(j)) < mat(s(i),t(i)) && mat(s(i),u(j)) < mat(t(i),u(j))
            sps(s(i),u(j)) = 0;
        end
    end
end

sps = sps + sps';
gcc = gcc / nchoosek(size(mat,1),3);
function ct = get_centrality(mi,paths)
%% Get network betweenness centrality
% For every node calculate the 'betweenness centrality', a measure to
% determine how important the role of a node is in the global network
% structure.
% 
% ct = get_centrality(mi,paths)
% 
% Input:
% mi:       MI/network matrix
% paths:    (optional) cell array with shortest paths, will be computed if
%           missing
% 
% Output:
% ct:       array of centrality values for each node

n = size(mi,1);
if nargin==1
    disp('Computing shortest paths...');
    for i = 1:n
        [~,paths(i,:)] = shortestpath(mi,i);
    end
end
ct = zeros(1,n);

disp('Computing betweenness centrality...');
for i = 1:n
    for j = 1:(i-1)
        ct(paths{i,j}(2:end-1)) = ct(paths{i,j}(2:end-1)) + 1;
    end
end
ct = ct / (0.5*(n^2 - n)); % Normalize

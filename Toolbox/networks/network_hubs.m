function centrality = network_hubs(m,paths)
%% Get network betweenness centrality
% m: adjacency matrix
% paths: (optional) cell array with shortest paths, will be computed if
% missing

tic;
n = size(m,1);
if nargin==1
    [~,paths] = getshortestpaths(m);
end

% Calculate betweenness centrality for each node
centrality = zeros(1,n);
for i = 1:n
    for j = 1:n
        paths{i,j} = paths{i,j}(2:end-1);
        centrality(paths{i,j}) = centrality(paths{i,j}) + 1;
    end
%    if toc>10
%        disp(i/n);
%        tic;
%    end
end
centrality = centrality / (n^2 - n); % Normalize

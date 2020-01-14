function dos = get_dos_matrix(mi)
%% Calculate the Degree of Separation (DOS) matrix of a network
% Compute the DOS, i.e. the minimum number of steps necessary to get from
% one network node to another, for all nodes in a network. The DOS is the
% unweighted equivalent of the shortest path and only takes into account
% the number of edges, not the edge weight. This function computes the DOS
% for all pairs of nodes and stores them in a matrix same sized to the
% input matrix.
% 
% dos = get_dos(mi,source,target)
%
% Input:
% mi:       MI/network matrix
%
% Output:
% dos:      DOS matrix
% 
% See also SHORTESTPATH, KSHORTESTPATHS

mi = double(mi);
mi(mi>0) = 0.5; % For conversion to distance metric by shortestpath()

n = size(mi,1);
dos = zeros(n);

for i = 1:n
    dos(i,:) = shortestpath(mi,i);
end
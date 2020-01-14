function [d,p] = shortestpath(mi,source,target)
%% Calculate the shortest path in a graph using Dijkstra's algorithm.
% This function calculates the shortest path from a node i to node j (or
% all other nodes) in the network. The length of a path is defined by the
% sum of the distances between the nodes along the path. The shortest path
% (i,j) is the path from i to j for which this path length is minimal. The
% distance between nodes is equal to the ratio of Variation of Information
% (VOI, equals 1-MI) to Mutual Information (MI).
% 
% [d,p] = shortestpath(mi,source,target)
% 
% Input:
% mi:       MI/network matrix
% source:   source node
% target:   (optional) target node. When not specified, the shortest path
%           from source node to all other nodes will be computed.
% 
% Output:
% d:        path length of the shortest path (number or vector in the case
%           of multiple targets).
% p:        the shortest path itself. Cell or cell array containing a list
%           of nodes that constitute the path.
% 
% See also GET_PATHLENGTH, KSHORTESTPATHS, GET_DOS

dist = (1-mi) ./ mi;
n = size(dist,1);

d = inf(1,n); % distance between source and targets
d(source) = 0;
prev = -ones(1,n); % previous node in shortest path, -1=undefined
q = true(1,n); % unvisited nodes
nodes = 1:n; % list of all nodes

if nargin == 2 % Look for all nodes instead of a single target node
    target = -1;
end

while sum(q)>0
    % Select closest unvisited node
    [~,k] = min(d(q));
    un = nodes(q); % all unvisited nodes
    u = un(k); % closest unvisited node
    q(u) = false; % node is visited
    
    % If target node is reached, quit
    if u == target
        d = d(u);
        p = [];
        while u~=-1
            p = [u p];
            u = prev(u);
        end
        p = {p}; % Convert to cell for compatibility with other functions
        return;
    end
    
    % For every target: if the new path (via u) is shorter than the old
    % one, replace.
    tdist = d(u) + dist(u,:); % temporary distance
    index = tdist<d; % This is not equal to index=L(u,:)>0, because of inf values
    d(index) = tdist(index);
    prev(index) = u;
end

p = cell(1,n); % Calculate paths
for i = 1:n
    u = i;
    while u~=-1 % Go back along shortest path until source is reached
        p{i} = [u p{i}];
        u = prev(u);
    end
end
function [d,A] = kshortestpaths(L,K,source,target)
%% Calculate K shortest paths (KSPs) in a graph using Yen's algorithm.
% 
% [d,A] = kshortestpaths(L,K,source,target)
% 
% Input:
% L:        length matrix (e.g. dot inverse of network matrix)
% K:        number of shortest paths to find
% source:   source node
% target:   target node (contrary to shortestpath(), single node only)
% 
% Output:
% d:        T by K array with path lengths
% A:        T by K cell array with paths

n = size(L,1);
if n ~= size(L,2) % Bilateral map
    L = [L;[L(:,(n+1):(2*n))' L(:,1:n)]];
end

A = cell(K,1);
[~,A(1,:)] = shortestpath(L,source,target); % First KSP using Dijkstra

B = []; % Potential KSPs
Bc = []; % Cost of potential KSPs
for k = 1:K-1
    for i = 1:length(A{k})-1
        L1 = L; % Copy of original length matrix
        spurNode = A{k}(i); % Set the spur node
        rootPath = A{k}(1:i); % Copy root path from previous KSP
        rootCost = getpathlength(L1,rootPath); % Cost of root path

        for j = 1:k % For all KSPs that are already found
            p = A{j};
            if length(p)>i
                if isequal(rootPath,p(1:i))
                    L1(p(i),p(i+1)) = Inf; % Remove edge from graph
                end
            end
        end

        L1(rootPath(1:end-1),:) = Inf; % Remove root path nodes from graph
        L1(:,rootPath(1:end-1)) = Inf;

        [spurCost,spurPath] = shortestpath(L1,spurNode,target);
        spurPath = spurPath{1};
%        if spurCost ~= Inf
            totalPath = [rootPath spurPath(2:end)];
            totalCost = rootCost+spurCost;
            B = [B {totalPath}];
            Bc = [Bc totalCost];
            for j = 1:length(B)-1 % Discard path if duplicate
                if isequal(B{j},totalPath)
                    B = B(1:end-1);
                    Bc = Bc(1:end-1);
                    break;
                end
            end
%        else
%            disp('inf');
%        end
    end

    [~,ksp] = min(Bc);
    if isempty(B)
        break;
    else
        A(k+1) = B(ksp);
    end
    B(ksp) = [];
    Bc(ksp) = [];
end
A = A'; % From KxT to TxK matrix size
d = getpathlength(L,A);
function [d,A] = kshortestpaths(mi,K,source,target)
%% Calculate K shortest paths (KSPs) in a graph using Yen's algorithm.
% See shortestpath function for details on shortest paths.
% 
% [d,A] = kshortestpaths(mi,K,source,target)
% 
% Input:
% mi:       MI/network matrix
% K:        number of shortest paths to find
% source:   source node
% target:   target node (single node)
% 
% Output:
% d:        T by K array with path lengths
% A:        T by K cell array with paths
% 
% See also SHORTESTPATH

dist = (1 - mi) ./ mi;
A = cell(K,1);
[~,A(1,:)] = shortestpath(mi,source,target); % First KSP using Dijkstra

B = []; % Potential KSPs
Bc = []; % Cost of potential KSPs
for k = 1:K-1
    for i = 1:length(A{k})-1
        mi1 = mi; % Copy of original MI matrix
        spurNode = A{k}(i); % Set the spur node
        rootPath = A{k}(1:i); % Copy root path from previous KSP
        rootCost = get_pathlength(mi1,rootPath); % Cost of root path

        for j = 1:k % For all KSPs that are already found
            p = A{j};
            if length(p)>i
                if isequal(rootPath,p(1:i))
                    mi1(p(i),p(i+1)) = 0; % Remove edge from graph
                end
            end
        end

        mi1(rootPath(1:end-1),:) = 0; % Remove root path nodes from graph
        mi1(:,rootPath(1:end-1)) = 0;

        [spurCost,spurPath] = shortestpath(mi1,spurNode,target);
        spurPath = spurPath{1};
%        if spurCost ~= Inf % Error check
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
    if isempty(B) || B{ksp}(end) ~= target
        fprintf('Found %d paths.\n', k+1);
        break;
    else
        A(k+1) = B(ksp);
    end
    B(ksp) = [];
    Bc(ksp) = [];
end
A = A'; % From KxT to TxK matrix size
d = get_pathlength(mi,A);
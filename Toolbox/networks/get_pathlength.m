function d = get_pathlength(L,p)
%% Calculate the pathlength of a path in a network
% The pathlength is the sum of the edge lengths in L between all nodes in
% path.
% 
% d = get_pathlength(L,p)
% 
% Input:
% L: length matrix (dot inverse of projections matrix, uni- or bilateral)
% p: path or cell array/matrix of paths
% 
% Output:
% d: pathlength

if ~iscell(p)
    p = {p};
end

d = zeros(size(p));
for i = 1:numel(p)
    for j = 2:length(p{i})
        d(i) = d(i) + L(p{i}(j-1),p{i}(j));
    end
end
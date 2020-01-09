function d = get_pathlength(mi,p)
%% Calculate the pathlength of a path in a network
% The pathlength is the sum of the distances between the nodes along the
% path. The distance is given by the Variation of Information (VOI) which
% equals 1-MI.
% 
% d = get_pathlength(mi,p)
% 
% Input:
% mi: MI/network matrix
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
        d(i) = d(i) + 1 - mi(p{i}(j-1),p{i}(j));
    end
end
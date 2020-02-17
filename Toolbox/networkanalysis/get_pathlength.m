function d = get_pathlength(mi,p)
%% Calculate the pathlength of a path in a network
% The pathlength is the sum of the distances between the nodes along the
% path. The distance is given by the ratio of Variation of Information
% (VOI, equals 1-MI) to Mutual Information (MI).
% 
% d = get_pathlength(mi,p)
% 
% Input:
% mi: MI/network matrix
% p: path or cell array/matrix of paths
% 
% Output:
% d: pathlength
% 
% See also SHORTESTPATH, KSHORTESTPATHS

dist = (1 - mi) ./ mi;

if ~iscell(p)
    p = {p};
end

d = zeros(size(p));
for i = 1:numel(p)
    for j = 2:length(p{i})
        d(i) = d(i) + dist(p{i}(j-1),p{i}(j));
    end
end
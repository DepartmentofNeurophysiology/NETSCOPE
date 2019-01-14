function [map,thr] = filtermap_bin(map,threshold)
%% Filter a fixed percentage of connections from a map.
% 
% [map,thr] = filtermap_bin(map,threshold)
% 
% Input:
% map: projections matrix (uni- or bilateral)
% threshold: threshold value for % of targets that will be filtered (0-100)
% 
% Output:
% map: filtered projections matrix
% thr: actual threshold value

%% Initialize variables.
values = map(map>0);
sv = sort(values);
ind = max(ceil(length(sv)*(threshold/100)),1);
thr = sv(ind);
map(map<=thr) = 0;
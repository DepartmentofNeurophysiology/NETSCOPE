function [mi, dist] = normalize_MI(mi_unnorm, hi, hj)
%% Normalize MI and calculate VI matrix
% Normalize MI matrix with respect to the joint entropy, calculate the
% Variation of Information (VI) matrix, which measures information
% distance, as opposed to MI which measures information similarity, and
% calculate the distance matrix which is VI./MI.
% 
% [mi, dist] = normalize_MI(mi_unnormalized,hi,[hj])
% 
% Input:
% mi_unnorm:  MI matrix
% hi:         entropy vector
% hj:         (optional) entropy vector
% 
% Output:
% mi:         normalized MI matrix
% dist:       normalized VI matrix

if nargin == 2
    hj = hi;
end
n1 = length(hi);
n2 = length(hj);

% Joint entropy
joint_h = repmat(hi, 1, n2) + repmat(hj', n1, 1) - mi_unnorm;

% Normalized MI
mi = mi_unnorm ./ joint_h;
mi(isnan(mi)) = 0;

% Variation of information; a distance measure
vi = 1 - mi; % == joint_h - mi_unnormalized
dist = vi ./ mi;
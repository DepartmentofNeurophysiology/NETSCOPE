function [mi, voi] = normalize_MI(mi_unnormalized,h)
%% Normalize MI and calculate distance matrix
% Normalize MI matrix with respect to the joint entropy and calculate the
% Variation of Information (VOI) matrix, which measures information
% distance, as opposed to MI which measures information similarity.
% 
% [mi, voi] = normalize_MI(mi_unnormalized,h)
% 
% Input:
% mi_unnormalized:  MI matrix from compute MI functions
% h:                entropy vector from compute MI functions
% 
% Output:
% mi:               normalized MI matrix


n = length(h);

% Joint entropy
joint_h = repmat(h,1,n) + repmat(h',n,1) - mi_unnormalized;

% Normalized MI
mi = mi_unnormalized ./ joint_h;

% Variation of information; a distance measure (as opposed to MI which is a
% measure of similarity)
voi = 1 - mi; % == joint_h - mi_unnormalized
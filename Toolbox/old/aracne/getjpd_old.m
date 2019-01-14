function [mi,h1,h2] = getjpd_old(x1,x2)
%% THIS WORKS FOR MATLAB VERSION < 2016
% 
% Get copula-transformed, Gaussian kernel density estimated joint
% probability distribution of two variables
% 
% x1,2: two column vectors with data
% 
% jpd: joint probability distribution

n = length(x1); % Number of observations
bw = 0.136946099658913; % Determined with getjpd()

% Copula-transform (rank order) variables
[~,y1] = sort(x1);
[~,y2] = sort(x2);
y1 = y1/n;
y2 = y2/n;

% Estimate true copula joint PDF by Gaussian Kernel Density Estimation
cv = linspace(0,1,101); % Values along copula-transformed axes (interval [0,1])
[cv1,cv2] = meshgrid(cv,cv);
p12 = getksd([y1 y2],[cv1(:) cv2(:)],bw);
p12 = reshape(p12,[length(cv) length(cv)]) / sum(p12(:));
p1 = sum(p12,2);
p2 = sum(p12,1);

% Calculate Mutual Information
mi = nansum(sum(p12 .* log(p12 ./ (p1*p2))));
h1 = -nansum(p1 .* log(p1));
h2 = -nansum(p2 .* log(p2));
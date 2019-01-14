function [mi,h1,h2] = getjpd(x1,x2,bw)
%% THIS WORKS FOR MATLAB VERSION >= 2016
% 
% Get copula-transformed, Gaussian kernel density estimated joint
% probability distribution of two variables
% 
% x1,2: two column vectors with data
% bw: bandwidth for kernel smoothing
% 
% jpd: joint probability distribution

n = length(x1); % Number of observations

% Copula-transform (rank order) variables
%xv1 = linspace(min(x1),max(x1)+0.01,100); % Values along both axes
%xv2 = linspace(min(x2),max(x2)+0.01,100);
%y1 = zeros(n,1); % Copula-transformed x1,2
%y2 = zeros(n,1);
%for i = 1:length(x1)
%    %y1(i) = length(find(x1<xv1(i))) / n;
%    %y2(i) = length(find(x2<xv2(i))) / n;
%    y1(i) = length(find(x1<=x1(i))) / n;
%    y2(i) = length(find(x2<=x2(i))) / n;
%end
[~,y1] = sort(x1);
[~,y2] = sort(x2);
y1 = y1/n;
y2 = y2/n;

% Estimate true copula joint PDF by Gaussian Kernel Density Estimation
cv = linspace(0,1,101); % Values along copula-transformed axes (interval [0,1])
[cv1,cv2] = meshgrid(cv,cv);
if nargin==3
    p12 = ksdensity([y1 y2],[cv1(:) cv2(:)],'BandWidth',bw);
else
    p12 = ksdensity([y1 y2],[cv1(:) cv2(:)]);
end
p12 = reshape(p12,[length(cv) length(cv)]) / sum(p12(:));
p1 = sum(p12,2);
p2 = sum(p12,1);

% Calculate Mutual Information
%mi = nansum(sum(log(p12 ./ (p1*p2)))) / n;
mi = nansum(sum(p12 .* log(p12 ./ (p1*p2))));
h1 = -nansum(p1 .* log(p1));
h2 = -nansum(p2 .* log(p2));
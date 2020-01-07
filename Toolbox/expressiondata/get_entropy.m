function h = get_entropy(px)
%% Compute entropy from gene transcription distributions
% 
% h = get_entropy(px)
% 
% Input:
% px: distributions matrix from get_distributions()
% 
% Output:
% h: array with the entropy of each gene

ngenes = size(px,1);
h = zeros(ngenes,1);
for i = 1:ngenes
    h(i) = -nansum(px(i,:) .* log(px(i,:)));
end
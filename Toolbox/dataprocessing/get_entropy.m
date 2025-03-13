function h = get_entropy(px)
%% Compute entropy from data distributions
% 
% h = get_entropy(px)
% 
% Input:
% px: distributions matrix from get_distributions()
% 
% Output:
% h: array with the entropy of each variable
% 
% See also GET_DISTRIBUTIONS

nvars = size(px,1);
h = zeros(nvars,1);
for i = 1:nvars
    h(i) = -nansum(px(i,:) .* log(px(i,:)));
end
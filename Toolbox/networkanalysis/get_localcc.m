function lcc = get_localcc(mi)
%% Calculate local clustering coefficient for every node in network
% 
% lcc = get_localcc(mi)
% 
% Input:
% mi:   MI/network matrix
% 
% Output:
% lcc:  local clustering coefficients

mi = mi>0;
mi = mi - diag(diag(mi));
n = size(mi,1);
lcc = zeros(1,n);

for i = 1:n
    nb = find(mi(i,:)); % Node neighbors
    nhs = length(nb); % Neighborhood size
    nbh = mi(nb,nb); % Neighborhood map
    lcc(i) = sum(sum(nbh)) / (nhs*(nhs-1));
end
%lcc(isnan(lcc)) = 0; % If a node has no neighbours, LCC is undefined
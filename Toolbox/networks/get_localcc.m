function lcc = get_localcc(mat)
%% Calculate local clustering coefficient for every node in network
% 
% lcc = get_localcc(mat)
% 
% Input:
% mat:  network matrix
% 
% Output:
% lcc:  local clustering coefficients

mat = mat>0;
mat = mat - diag(diag(mat));
n = size(mat,1);
lcc = zeros(1,n);

for i = 1:n
    nb = find(mat(i,:)); % Node neighbors
    nhs = length(nb); % Neighborhood size
    nbh = mat(nb,nb); % Neighborhood map
    lcc(i) = sum(sum(nbh)) / (nhs*(nhs-1));
end
%lcc(isnan(lcc)) = 0;
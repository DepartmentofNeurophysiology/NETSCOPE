function cc = network_localcc(m)
%% Calculate local clustering coefficient for every node in network
% m: adjacency matrix (full)
% cc: local clustering coefficients

m = m>0;
n = size(m,1);
cc = zeros(1,n);

for i = 1:n
    nb = find(m(i,:)); % Node neighbors
    nhs = length(nb); % Neighborhood size
    nbh = m(nb,nb); % Neighborhood map
    cc(i) = sum(sum(nbh)) / (nhs*(nhs-1));
end
cc(isnan(cc)) = 0;
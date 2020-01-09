function gcc = get_globalcc(mi)
%% Calculate global clustering coefficient
% 
% gcc = get_globalcc(mat)
% 
% Input:
% mi:   MI/network matrix
% 
% Output:
% gcc:  global clustering coefficient

mi = tril(mi);
[s,t] = find(mi>0); % Edge indices (source-target, s>t)
gcc = 0;

for i = 1:length(s)
    u = find(mi(s(i),1:t(i))>0 & mi(t(i),1:t(i))>0); % Edge triangular neighbors
    u(u==s(i) | u==t(i)) = []; % Don't double count edge i
    gcc = gcc+length(u);
end

gcc = gcc / nchoosek(size(mi,1),3);
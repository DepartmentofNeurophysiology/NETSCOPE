function gcc = get_globalcc(mat)
%% Calculate global clustering coefficient
% 
% gcc = get_globalcc(mat)
% 
% Input:
% mat:  network matrix
% 
% Output:
% gcc:  global clustering coefficient

mat = tril(mat);
[s,t] = find(mat>0); % Edge indices (source-target, s>t)
gcc = 0;

for i = 1:length(s)
    u = find(mat(s(i),1:t(i))>0 & mat(t(i),1:t(i))>0); % Edge triangular neighbors
    u(u==s(i) | u==t(i)) = []; % Don't double count edge i
    gcc = gcc+length(u);
end

gcc = gcc / nchoosek(size(mat,1),3);
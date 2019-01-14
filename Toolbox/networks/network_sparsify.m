function [mf,tr] = network_sparsify(m)
%% Use Data Processing Inequality to sparsify network and at the same time
%% count number of triangles in original network for global cluster coeff.
% m: adjacency matrix (full)

mf = tril(m,-1);
[s,t] = find(mf>0); % Edge indices (source-target, s>t)
tr = 0;
tic;

for i = 1:length(s)
    u = find(m(s(i),1:t(i))>0 & m(t(i),1:t(i))>0); % Edge triangular neighbors
    u(u==s(i) | u==t(i)) = []; % Don't double count edge i
    tr = tr+length(u);
    for j = 1:length(u)
        if m(s(i),t(i)) < m(s(i),u(j)) && m(s(i),t(i)) < m(t(i),u(j))
            mf(s(i),t(i)) = 0;
        elseif m(t(i),u(j)) < m(s(i),u(j)) && m(t(i),u(j)) < m(s(i),t(i))
            mf(t(i),u(j)) = 0;
        elseif m(s(i),u(j)) < m(s(i),t(i)) && m(s(i),u(j)) < m(t(i),u(j))
            mf(s(i),u(j)) = 0;
        end
    end
    
%    if toc>10
%        disp(i/length(s));
%        tic;
%    end
end

mf = mf+mf';
tr = tr/nchoosek(size(m,1),3);
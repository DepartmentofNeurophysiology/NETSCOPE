function [conn,pcount] = connectedcomps(m)
%% Find connected components of network
% 
% m: adjacency matrix
% conn: cell array with one cell per CC containing node numbers
% pcount: pattern count, occurence of CCs of a certain size

conn = [];
n = size(m,1);
v = false(1,n); % Visited

for i = 1:n
    conn = [conn {[]}];
    if v(i) == false
        [v,conn] = getnbh(i,v,conn,m);
    end
end
conn(cellfun(@isempty,conn)) = [];

cc_sizes = cellfun(@length,conn);
pcount = histcounts(cc_sizes,1:(n+1));

end

function [v,conn] = getnbh(j,v,conn,m)
    v(j) = true;
    conn{end} = [conn{end} j];
    for k = 1:length(v)
        if v(k)==false && (m(j,k) > 0 || m(k,j) > 0)
            [v,conn] = getnbh(k,v,conn,m);
        end
    end
end
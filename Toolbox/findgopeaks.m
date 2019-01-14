function p = findgopeaks(table,n)

s = sum(table);
p = zeros(1,n);
for i = 1:n
    [~,loc] = max(s); % find max peak
    p(i) = loc;
    s(loc) = -inf;
end
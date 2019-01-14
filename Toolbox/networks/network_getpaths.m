function [dist,paths] = network_getpaths(m)

n = size(m,1);

dist = zeros(n);
paths = cell(n);
tic;

for i = 1:n
    [dist(i,:),paths(i,:)] = shortestpath(1./m,i);
%    if toc>10
%        disp(i/n);
%        tic;
%    end
end
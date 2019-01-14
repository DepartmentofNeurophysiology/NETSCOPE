function networkstats(map,filter,fname,show)
%% Informatics pipeline for analysis of network statistics
% Calculate node in- and output distribution, degree of separation, etc.
% and store results.
% 
% map: network adjacency matrix
% filter: filter threshold, single value or array
% fname: output filename
% show: include to show figures with network stats

n = size(map,1);
nf = length(filter);

% Sort map with PCA
%o = sortmatrix(map,50);
%map = map(o,o);

% In- and output per node
in = sum(map) / n;
out = sum(map') / n;
avg = (in+out)/2;

% Binarize map
bin = cell(nf,1); % Binarized map
deg = cell(nf,1); % Node degree
for i = 1:nf
    bin{i} = map>filter(i);
    bin{i} = max(bin{i},bin{i}');
    deg{i} = sum(bin{i}) / n;
end

% Degree of separation
dos = cell(nf,1);
for i = 1:nf
    dos{i} = zeros(n);
    for j = 1:n
        dos{i}(j,:) = shortestpath(1./bin{i},j);
    end
end

thr = filter;
save(fname,'map','in','out','avg','bin','dos','deg','thr');
if nargin==4
    showstats(fname);
end
function degreeplots(fname,i,h)
%% Show figure with unweighted network statistics
% fname: filename with data from networkstats
% i: for multiple maps in a file, which map to select (default=0)

if nargin==1
    i = 0;
end
if i==0
    load(fname,'map','avg')
    bin = map;
    dos = zeros(size(map));
    deg = avg;
    thr = 0;
else
    load(fname,'bin','dos','deg','thr');
    bin = bin{i};
    dos = dos{i};
    deg = deg{i};
    thr = thr(i);
end
n = size(bin,1);

%% Binarized map
if nargin<3
    figure;
else
    figure(h);
end
subplot(2,2,1);
imagesc(bin);
colorbar eastoutside;
title(sprintf('Binarized matrix, %d genes, threshold=%f',n,thr));
axis square off;

subplot(2,2,2);
stairs(deg,'red');
title('Average normalized node degree');
xlabel('Nodes');
ylabel('Degree');

subplot(2,2,3);
m = max(dos(~isinf(dos))); % Maximum DoS
d = length(find(sum(isinf(dos))==n-1));
imagesc(dos);
colorbar;
caxis([0 m+1]);
title(sprintf('DoS, mean=%f, max=%d, inf=%d',mean(dos(~isinf(dos))),m,d));
axis square off;

subplot(2,2,4);
histogram(deg,'normalization','probability');
title('Distribution of average node degree');
xlabel('Average normalized degree');
ylabel('Probability');
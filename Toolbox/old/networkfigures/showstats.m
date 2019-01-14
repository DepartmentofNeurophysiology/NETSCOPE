function showstats(fname,i)
%% Show figures with network statistics
% fname: filename with data from networkstats

load(fname,'map','in','out','avg','bin','dos','deg');
n = size(map,1);

%% Show map
figure;
subplot(2,2,[1 3]);
imagesc(map);
colorbar eastoutside;
title(sprintf('Gene similarity for %d genes',n));
axis square off;

subplot(2,2,2);
stairs(in,'red');
hold on;
stairs(out,'black');
stairs(avg,'blue');
title('Average MI per node');
xlabel('Nodes');
ylabel('Average MI (I/O)');
legend('Columns','Rows','Average');

subplot(2,2,4);
[nc,xc] = histcounts(avg,'Normalization','probability');
xc = xc(2:end) - (xc(2)-xc(1))/2;
bar(xc,nc);
title('Distribution of average MI');
xlabel('Average MI');
ylabel('Probability');

%{
subplot(2,2,4);
x = linspace(0,max([conv div])*1.1,50);
[nc,xc] = histcounts(conv,x,'Normalization','probability');
[nd,xd] = histcounts(div,x,'Normalization','probability');
xc = xc(2:end) - (xc(2)-xc(1))/2;
xd = xd(2:end) - (xd(2)-xd(1))/2;
bar(xc,nc,'r','FaceAlpha',0.5,'EdgeColor','none');
hold on;
bar(xd,nd,'b','FaceAlpha',0.5,'EdgeColor','none');
title('Convergence and divergence distributions');
xlabel('Convergence or divergence');
ylabel('Probability');
legend('Convergence','Divergence');
%}

if ~iscell(bin)
    i = 1;
    bin = {bin};
    deg = {deg};
    dos = {dos};
end

%% Binarized map
figure;
subplot(2,2,[1 3]);
imagesc(bin{i});
colorbar eastoutside;
title(sprintf('Binarized matrix, %d genes, threshold=0.035',n));
axis square off;

subplot(2,2,2);
stairs(deg{i},'red');
title('Average normalized degree per node');
xlabel('Nodes');
ylabel('Degree');

subplot(2,2,4);
[nc,xc] = histcounts(deg{i},'Normalization','probability');
xc = xc(2:end) - (xc(2)-xc(1))/2;
bar(xc,nc);
title('Distribution of average degree');
xlabel('Average normalized degree');
ylabel('Probability');

%{
subplot(1,2,2);
dos(isinf(dos))=0;
imagesc(dos);
colorbar eastoutside;
m = max(dos(~isinf(dos)));
%caxis([0 m+1]);
title(sprintf('Degree of Separation, %d genes, maximum = %d',n,m));
axis square off;
%}
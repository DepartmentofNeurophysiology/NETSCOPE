function compareconn(c,s,bins)
% Compare distributions of two series of data

c = c(c>0);
s = s(s>0);

if nargin==3
    [~,x] = histcounts([c s],bins);
else
    [~,x] = histcounts([c s]);
end
nc = histcounts(c,x,'Normalization','probability');
ns = histcounts(s,x,'Normalization','probability');
x = x(2:end) - (x(2)-x(1))/2;

figure;
bar(x,nc,'blue','FaceAlpha',0.5,'EdgeColor','none');
hold on;
bar(x,ns,'red','FaceAlpha',0.5,'EdgeColor','none');

title('Distribution of controls vs significant genes');
ylabel('Probability');
legend('Controls','Significant','Location','northwest');
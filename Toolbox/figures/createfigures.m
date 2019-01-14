function createfigures(full,folder,labels)
%% Create figures for significant networks - use createfigures2 for the rest
% full: network data struct
% folder: output folder
% labels: (optional) transcript labels

%% Filter out nodes with no connections
% should this happen??
rm_nodes = sum(full.map)==0;
full.map(rm_nodes,:) = [];
full.map(:,rm_nodes) = [];
full.dos(rm_nodes,:) = [];
full.dos(:,rm_nodes) = [];

%% Adjacency matrix

cluster_table = linkage(double(full.map>0),'complete','cityblock'); % Clustering
clusters = cluster(cluster_table,'cutoff',1);
%{
[~,order] = sort(clusters);
f = figure('Visible','off');
imagesc(full.map(order,order)); % Show map reordered by cluster

colorbar('eastoutside');
title('Mutual information for significant genes');
axis square off;
savefigas(f,fullfile(folder,'adjacency'));
close(f);
%}
f = figure('Visible','off');
if nargin==3 % If transcript labels are provided, show in dendrogram
    labels(rm_nodes) = [];
    dendrogram(cluster_table,0,'Labels',labels);
else
    dendrogram(cluster_table,0);
    set(gca,'xtick',[]);
end
set(gca,'xticklabelrotation',90);
set(get(gca,'xaxis'),'fontsize',5);
title('Hierarchical clustering of genes by connectivity');
savefigas(f,fullfile(folder,'dendrogram'));
close(f);

%% Degree distribution
%{
f = figure('Visible','off');
histogram(mean(full.map>0),'normalization','probability');
title('Distribution of average degree of significant genes');
xlabel('Normalized degree');
ylabel('Probability');
savefigas(f,fullfile(folder,'degree'));
close(f);

%% Degree of Separation real vs random
if isfield(full,'rdos')
    f = figure('Visible','off');
    boxplot([full.rdos mean(full.dos(~isinf(full.dos)))],[repmat({'random'},1,10) {'real'}]);
    ylim([0 max(ylim)+0.1]);
    title('Average DoS for random vs real (full) network');
    savefigas(f,fullfile(folder,'dos'));
    close(f);
end
%}
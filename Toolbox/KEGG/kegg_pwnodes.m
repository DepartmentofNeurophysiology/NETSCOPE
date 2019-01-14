function [pw_genes,pw_nodes,rel,dos] = kegg_pwnodes(pw)
%% Find all nodes in a KEGG pathway
% Store genes not found in the GE data, as well as compounds (Ca2+) and
% pathway references. From the gene relations described in the KEGG data,
% create an undirected, binary adjacency matrix with gene interactions and
% calculate degree of separation.
% 
% pw: KEGG pathway ID
% 
% pw_genes: KEGG IDs of genes (and other compounds) present in pathway
% pw_nodes: map pw_genes to the nodes shown in the pathway
% rel: square binary adjacency matrix with interactions between genes

%% Download pathway info
fname = [tempname() '.xml'];
url = sprintf('http://rest.kegg.jp/get/%s/kgml',pw);
websave(fname,url);

%% Read pathway file
x = xmlread(fname);
delete(fname);
nodes = x.getElementsByTagName('entry');
relations = x.getElementsByTagName('relation');
pw_genes = [];
pw_nodes = cell(nodes.getLength,1);

%% List genes present in pathway
for i = 0:nodes.getLength-1
    node = str2double(nodes.item(i).getAttribute('id'));
    pw_nodes{node} = [];
    ids = char(nodes.item(i).getAttribute('name'));
    ids = strsplit(ids,' ');
    for j = 1:length(ids)
        k = find(strcmp(ids{j},pw_genes),1);
        if isempty(k)
            pw_genes = [pw_genes;ids(j)];
            pw_nodes{node} = [pw_nodes{node} length(pw_genes)];
        else
            pw_nodes{node} = [pw_nodes{node} k];
        end
    end
end

%% List gene interactions in pathway
rel = zeros(length(pw_genes));
for i = 0:relations.getLength-1
    n1 = str2double(relations.item(i).getAttribute('entry1'));
    n2 = str2double(relations.item(i).getAttribute('entry2'));
    rel(pw_nodes{n1},pw_nodes{n2}) = 1;
end

%% Calculate degree of separation between genes
rel = max(rel,rel'); % Symmetrize matrix
i = find(sum(rel)==0); % Filter out disconnected genes
rel(i,:) = [];
rel(:,i) = [];
pw_genes(i) = [];
for j = length(pw_nodes):-1:1
    pw_nodes{j}(ismember(pw_nodes{j},i)) = [];
end
pw_nodes(cellfun(@isempty,pw_nodes)) = []; % Remove empty nodes

dos = zeros(size(rel));
for i = 1:size(rel,1)
    dos(i,:) = shortestpath(1./rel,i);
end
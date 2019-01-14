function [map,g] = fullmap

load('kegg_data','pw_genes','relations');

g = {''};

% Create list of all KEGG genes
for i = 1:320
    a = ismember(pw_genes{i},g);
    g = [g;pw_genes{i}(~a)];
end
g = g(2:end);

% Filter out non-genes (compounds, pathways, ...)
%{
for i = length(g):-1:1
    if ~strcmp(g{i}(1:3),'mmu')
        g(i) = [];
    end
end
%}

map = false(length(g));
% Filter out non-genes from pw_genes and relations
for i = 1:320
    a = ismember(pw_genes{i},g);
    a = a & (sum(relations{i})>0 | sum(relations{i}')>0)';
    pw_genes{i} = pw_genes{i}(a);
    relations{i} = relations{i}(a,a);
    [~,b] = ismember(pw_genes{i},g);
    map(b,b) = relations{i}>0;
end

% Filter out empty rows/columns
%{
a = sum(map)>0 | sum(map')>0;
map = map(a,a);
g = g(a);
%}
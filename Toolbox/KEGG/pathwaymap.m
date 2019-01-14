function [map,filters,included] = pathwaymap(pw_genes,mfname,sfname,conf)
%% Create MI submap to compare with KEGG pathway map
% Genes present in the KEGG pathway but not in the GE data are filtered
% out.
% 
% pw_genes: IDs (universal or KEGG) of genes present in pathway from
% kegg_pwnodes. Can be a cell array of ID arrays to create multiple pathway
% maps.
% mfname: filename of file containing full MI matrix (path relative from
% Tido\Msc-project\data_Tido)
% sfname: filename of file containing shuffle corrected matrix
% conf: leave empty to create submatrices of shuffled MI matrices
% 
% map: MI submap of pathway genes
% filters: data from the shuffle correction used for thresholding
% included: binary array indicating what pw_genes have been included in the
% map

path = 'F:\Tido\Msc-project\data_Tido\mutualinfo\';
try
% Convert KEGG IDs to universal IDs
if ~iscell(pw_genes) % Single, uni
    pw_genes = {pw_genes};
else
    if ischar(pw_genes{1}) % Single, kegg
        pw_genes = {pw_genes};
    end
    if iscell(pw_genes{1}) % Multiple, kegg
        load([path '\..\gene_ids'],'kgenes','kegg_ids');
        for i = 1:length(pw_genes)
            [~,tmp] = ismember(pw_genes{i},kgenes);
            pw_genes{i} = kegg_ids(tmp);
        end
        clear tmp kgenes kegg_ids;
    end
end
catch
    keyboard
end
load([path '..\gene_ids'],'ge_ids');
n = length(pw_genes); % Number of pathways
nogene = cell(n,1); % For each pathway, genes that weren't included
included = cell(n,1); % For each pathway, genes that were included
for i = 1:n
    % Convert gene IDs to indices in the GE data
    [~,pw_genes{i}] = ismember(pw_genes{i},ge_ids);
    nogene{i} = find(pw_genes{i}==0)';
    included{i} = pw_genes{i}>0;
    pw_genes{i} = pw_genes{i}(included{i});
end

%% Load MI data
fprintf('Loading map data and creating map ... \n');
load([path mfname],'corr');
map = cell(n,1);
for i = 1:n
    map{i} = corr(pw_genes{i},pw_genes{i});
end
clear corr;
%% Load SC-avg data
load([path sfname],'sc');
sc_avg = cell(n,1);
for i = 1:n
    sc_avg{i} = sc(pw_genes{i},pw_genes{i});
end
clear sc;
%% Load SC-std data
load([path sfname],'sc_std');
sc_st = cell(n,1);
for i = 1:n
    sc_st{i} = sc_std(pw_genes{i},pw_genes{i});
end
clear sc_std;

%% Add missing genes to matrix as all-zero rows/columns
fprintf('Adding genes ... \n');
for i = 1:n
     map{i} = addgenes(map{i},nogene{i});
     sc_avg{i} = addgenes(sc_avg{i},nogene{i});
     sc_st{i} = addgenes(sc_st{i},nogene{i});
end

fprintf('Creating filters ... \n');
%% Create filters
if nargin==3
    conf = [];
end
filters = cell(n,1);
for i = 1:n
    if isempty(conf) % if conf==[], simply output sc,sc_std
        filters{i} = [sc_avg(i) sc_st(i)];
    else % if conf~=[], output filtered maps with confidence levels
        filters{i} = false([size(map{i}) length(conf)]);
        for j = 1:length(conf)
            filters{i}(:,:,j) = map{i} > (sc_avg{i} + conf(j)*sc_st{i});
        end
    end
end

%% Format output for one pathway vs. multiple
if n==1
    map = map{1};
    filters = filters{1};
    included = included{1};
end
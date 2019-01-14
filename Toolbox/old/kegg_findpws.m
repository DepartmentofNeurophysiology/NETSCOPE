function [pws,pwn,gid,gf,pwg,pw_nodes,rels,pf] = kegg_findpws(org,steps,pws,gid)
%% List all KEGG pathway IDs and names for a certain organism
% 
% org: organism (e.g. 'mmu' or 'hsa')
% steps: (optional) where to start this function (default: 1 = at the start)
% pws: needed if steps >= 3
% gene_id: needed if steps >= 3
% 
% pws: KEGG pathway IDs (e.g. mmu04010)
% pwn: pathway names (e.g. 'MAPK Signalling Pathway')
% gid: gene_id from kegg_findgenes, linking gene names to KEGG gene IDs
% gf: binary array showing what genes were found in the KEGG database
% pwg: pw_genes from kegg_pw_getgenes, containing all genes associated with
% a particular pathway
% nodes: pw_nodes from kegg_pw_getgenes, containing node no.s for pw_genes
% rels: square binary adjacency matrix with interactions between genes
% pf: binary array showing what genes were found in at least one KEGG pathway

if nargin==1
    steps = 1;
end

%% Download pathway data
if steps == 1
    fprintf('Downloading KEGG pathways for %s ... ',org);
    url = sprintf('http://rest.kegg.jp/list/pathway/%s',org);
    data = urlread(url,'TimeOut',10);
    data = textscan(data,'path:%s\t%[^\n]');
    pws = data{1}; % KEGG pathway IDs
    pwn = data{2}; % pathway names
    fprintf('%d pathways found.\n',length(pws));
else
    pwn = [];
end

%% kegg_findgenes
if steps <= 2
    fprintf('Downloading KEGG genes corresponding to Gene Expression data.\n');
    fprintf('Progress update every 5 minutes ...\n');
    [gid,gf] = kegg_findgenes; % gene_id, gfound
else
    gf = [];
end

% Save progress
%global tt;
%tt = tempname();
%save(tt,'gid','gf');

%% kegg_pw_getgenes
n = length(pws);
fprintf('Downloading pathway data for %d pathways ...\n',n);
pwg = cell(n,1);
pw_nodes = cell(n,1);
rels = cell(n,1);
pf = false(size(gid));
tic;
temp = find(~cellfun(@isempty,gid));
for i = 1:n
    [pwg{i},pw_nodes{i},rels{i}] = kegg_pw_getgenes(pws{i},1);
    in = ismember(gid(temp),pwg{i});
    pf(temp(in)) = true;
    if toc>60
        fprintf('%d/%d downloaded ... \n',i,n);
        tic;
    end
end
fprintf('%d/%d genes found in pathways.\n',sum(pf),length(gid));

%delete(tt);
clearvars -global;
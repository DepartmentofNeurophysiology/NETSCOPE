function [gene_id,found] = kegg_findgenes(genelist)
%% Search KEGG gene database by gene name and couple each gene with an ID
% Match genes from the GE data to a gene from the KEGG database. Genes that
% can't be matched will have an empty gene_id.
% 
% genelist: cell array containing gene names (optional; default: load
% from file
% gene_id: corresponding gene IDs from KEGG database
% found: binary array indicating which genes were found

if nargin==0
    load('F:\Tido\Msc-project\data_Tido\ge_data','genelist');
end
gene_id = cell(size(genelist));
found = false(size(genelist));

tic;
for i = 1:length(genelist)
    % Find gene in KEGG database
    url = sprintf('http://rest.kegg.jp/find/mmu/%s',genelist{i});
    str = urlread(url,'Timeout',10);
    gnames = strsplit(sscanf(str,'%*[^\t]\t%s'),',');
    gnames(end) = [];
    f = find(strcmpi(gnames,genelist{i}),1); % Ignore upper/lower case
    if ~isempty(f)
        gene_id{i} = sscanf(str,[repmat('%*[^\n]\n',1,f-1) '%s'],1);
        found(i) = true;
    end
    
    if toc>300
        disp(i/length(genelist));
        tic;
    end
end
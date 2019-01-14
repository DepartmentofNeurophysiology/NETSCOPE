function [pathways,pw_genes,pwfound] = kegg_findpws(gene_id)
% Old, obsolete

pathways = {''};
pw_genes = {0};
pwfound = true(size(gene_id));

tic;
for i = 1:length(gene_id)
    if isempty(gene_id{i})
        pwfound(i) = false;
        continue;
    end
    
    % Find pathways related to gene
    url = sprintf('http://rest.kegg.jp/get/%s',gene_id{i});
    str = urlread(url,'Timeout',10);
    gene_data = textscan(str,'%s','Delimiter','\n');
    pw_header = strfind(gene_data{1},'PATHWAY');
    pw_header = find(~cellfun(@isempty,pw_header));
    if isempty(pw_header)
        pwfound(i) = false;
        continue;
    end
    
    % Store first pathway
    pw{1} = sscanf(gene_data{1}{pw_header},'PATHWAY     %[^ ]%*s');
    k = find(~cellfun(@isempty,strfind(pathways,pw{1})));
    if isempty(k) % New pathway
        pathways = [pathways;pw(1)];
        pw_genes = [pw_genes;{i}];
    else % Existing pathway
        pw_genes{k} = [pw_genes{k};i];
    end
    
    % Store other pathways
    j = 1;
    while gene_data{1}{pw_header+j}(1)==' '
        pw{j+1,1} = sscanf(gene_data{1}{pw_header+j},'%*[ ]%[^ ]%*s');
        k = find(~cellfun(@isempty,strfind(pathways,pw{j+1})));
        if isempty(k)
            pathways = [pathways;pw(j+1)];
            pw_genes = [pw_genes;{i}];
        else
            pw_genes{k} = [pw_genes{k};i];
        end
        j = j+1;
    end
    clear pw;
    
    if toc>300
        disp([i i/length(gene_id)]);
        tic;
    end
end
pathways = pathways(2:end);
pw_genes = pw_genes(2:end);
function gene_id = match_genes(genes,src,bsize)
%% Match genes from different datasets by looking them up in bioDBnet
% 
% Only works in MATLAB 2016 or later!
% 
% genes: gene names
% src: either 'kegg' or 'name' referring to KEGG IDs or gene names
% bsize: batch size, too big causes server errors. Typically 1000 when
% src=='name' and 500 for 'kegg'
% 
% gene_id: universal IDs of genes

if strcmp(src,'kegg')
    url1 = 'https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json?method=db2db&input=kegggeneid&inputValues=';
elseif strcmp(src,'name')
    url1 = 'https://biodbnet-abcc.ncifcrf.gov/webServices/rest.php/biodbnetRestApi.json?method=db2db&input=genesymbol&inputValues=';
else
    error('Wrong argument');
end
url2 = '&outputs=geneid&taxonId=10090';
wo = weboptions('Timeout',20');
n = length(genes);
gene_id = zeros(n,1);

for i = 1:bsize:n
    inputstr = genes{i};
    for j = (i+1):min(i+bsize-1,n)
        inputstr = sprintf('%s,%s',inputstr,genes{j});
    end
    d = webread(sprintf('%s%s%s',url1,inputstr,url2),wo);
    for k = 0:min(bsize-1,n-i)
        if ~isempty(d.(['x' num2str(k)]).outputs)
            gene_id(i+k) = str2num(d.(['x' num2str(k)]).outputs.GeneID{1});
        end
    end
    fprintf('Matched %d out of %d genes\n',min(i+bsize-1,n),n);
end
fprintf('Done matching, %d genes were found.\n',sum(gene_id~=0));
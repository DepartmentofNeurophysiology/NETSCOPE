function index = findgene(genes,varargin)
%% Find genes by name in a list of gene names
% Find genes by matching (parts of) names and return the results as list
% indices.
% 
% index = findgene(genes,terms...)
% 
% Input:
% genes:    cell array with gene names
% terms:    search terms as strings (variable number of parameters)
% 
% Output:
% index:    list of array indices with the results.
% 
% Example:
% findgene([list of gene names], 'abc', 'def') will return indices of any
% genes in the gene list that contain the substrings 'abc' OR 'def'.

genes = lower(genes);
found = false(size(genes));

for i = 1:length(varargin)
    varargin{i} = lower(varargin{i});
    if iscell(varargin{i})
        for j = 1:length(varargin{i})
            found = found | (~cellfun(@isempty,strfind(genes,varargin{i}{j})));
        end
    else
        found = found | (~cellfun(@isempty,strfind(genes,varargin{i})));
    end
end

index = find(found);
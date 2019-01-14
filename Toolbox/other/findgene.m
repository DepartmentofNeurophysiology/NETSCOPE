function index = findgene(genes,varargin)
% Find genes by name

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
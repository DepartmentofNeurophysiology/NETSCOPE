function index = findvar(vars, varargin)
%% Find variables by name in a list of names
% Find variables by matching (parts of) names and return the results as list
% indices.
% 
% index = findgene(vars, terms...)
% 
% Input:
% vars:     cell array with names
% terms:    search terms as strings (variable number of parameters)
% 
% Output:
% index:    list of array indices with the results.
% 
% Example:
% findvar([list of variables, e.g. genes], 'abc', 'def') will return
% indices of any genes in the gene list that contain the substrings
% 'abc' OR 'def'.

vars = lower(vars);
found = false(size(vars));

for i = 1:length(varargin)
    varargin{i} = lower(varargin{i});
    if iscell(varargin{i})
        for j = 1:length(varargin{i})
            found = found | (~cellfun(@isempty,strfind(vars,varargin{i}{j})));
        end
    else
        found = found | (~cellfun(@isempty,strfind(vars,varargin{i})));
    end
end

index = find(found);
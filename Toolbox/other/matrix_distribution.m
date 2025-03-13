function [px, ex] = matrix_distribution(varargin)
%% Get distribution of data in a matrix
% For large matrix that can't be loaded completely because of memory
% limitations, the MAT file containing the matrix can be specified, so that
% it can be loaded and processed in batches. This function assumes the
% data is confined to the interval [0,1].
% 
% [px, ex] = matrix_distribution(...)
% 
% Input: the following Name-Value argument pairs:
% file:     (optional) MAT file containing a matrix. Required if mat 
%           argument is not specified.
% varname:  (optional) name of matrix variable in MAT file. Required if 
%           file argument is specified.
% mat:      (optional) matrix. Required if file argument is not specified.
% batch:    (optional) batch size for loading data, default: 4000.
% bins:     (optional) number of bins used for counting, default: 1000.
% 
% Output:
% px:       data distribution - array of bin counts
% ex:       bin edges

% Parse arguments
options = struct();
for i = 1:2:length(varargin)
    options.(varargin{i}) = varargin{i+1};
end
if isfield(options,'file')
    file = matfile(options.file);
    vn = options.varname;
    dim = size(file,vn);
elseif isfield(options,'mat')
    vn = 'mat';
    file.mat = options.mat;
    dim = size(file.mat);
end
if ~isfield(options,'batch')
    options.batch = 4000;
end
if ~isfield(options,'bins')
    options.bins = 1000;
end
    
% Count data
ex = linspace(0,1,options.bins+1);
px = zeros(1,options.bins);

for i = 1:options.batch:dim(1)
    msub = file.(vn)(i:min(i+options.batch-1,dim(1)),1:dim(2));
    px = px + histcounts(msub(:),ex);
end
function n = get_distribution(file,bsize)
%% Calculate data distribution of large matrix
% file: MAT file containing MI matrix
% bsize: batch size for loading data (optional)

m = matfile(file);
if nargin==1
    bsize = 4000; % Batch size
end
dim = size(m,'corr',1);

x = -0.001:0.001:1.001;
n = zeros(1,1002);

for i = 1:bsize:dim
    msub = m.corr(i:min(i+bsize-1,dim),1:dim);
    n = n + histcounts(msub(:),x);
end
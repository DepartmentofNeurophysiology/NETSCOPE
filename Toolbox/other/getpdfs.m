function [px,ex] = getpdfs(dm)
% Get PDFs of genes

ng = size(dm,1);
bsize = 0.0001;
ex = 0:bsize:max(dm(:))+bsize;
px = zeros(ng,length(ex)-1);

for i = 1:ng
    px(i,:) = histcounts(dm(i,:),ex);
end

px = px ./ repmat(sum(px,2),1,length(ex)-1);
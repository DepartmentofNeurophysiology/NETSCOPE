function [px,ex,h] = calcEntropy(dm)
% Calculate normalized distributions for genes, and unnormalized entropy

ng = size(dm,1);
px = cell(ng,1);
ex = cell(ng,1);
h = zeros(ng,1);
for i = 1:ng
    [px{i},ex{i}] = histcounts(dm(i,:));
    px{i} = px{i}/sum(px{i});
    h(i) = -nansum(px{i} .* log(px{i}));
end
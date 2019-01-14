function [mi,h] = calc_mi(dm,ix,jx)

[px,ex,h] = calcEntropy(dm);
n = size(dm,1);
if nargin == 1
    ix = 1:n;
    jx = 1:n;
end
mi = zeros(n);
ix = reshape(ix,[1 length(ix)]);
jx = reshape(jx,[1 length(jx)]);

for i = ix
    if sum(dm(i,:))==0
        continue;
    end
    for j = jx
        if sum(dm(j,:))==0
            continue;
        end
        if isequal(ix,jx) && i<j
            continue;
        end
        % Convert bin edges to bin centers
        ctrs = {ex{i}(1:end-1) + (ex{i}(2)-ex{i}(1))/2 ...
            ex{j}(1:end-1) + (ex{j}(2)-ex{j}(1))/2};
        pxy = hist3([dm(i,:)' dm(j,:)'],ctrs);
        pxy = pxy / sum(pxy(:));
        % Calculate unnormalized mutual information
        mi(i,j) = sum(nansum(pxy .* log(pxy ./ (px{i}'*px{j}))));
        if isinf(mi(i,j)) % workaround
            pxy = hist3([dm(i,:)' dm(j,:)'],'Edges', ...
                [ex(i) ex(j)]);
            pxy = pxy(1:end-1,1:end-1) / sum(pxy(:));
            mi(i,j) = sum(nansum(pxy .* log(pxy ./ (px{i}'*px{j}))));
        end
    end
end
mi = mi(ix,jx);
h = h(ix);
mi = mi./repmat(h,1,length(jx));
mi(isnan(mi)) = 0;
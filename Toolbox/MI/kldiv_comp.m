function [kl,ix,jx] = kldiv_comp(filein,ix,jx)
% Calculate mutual information between two gene expression matrices
% Filein contains gene expression matrix dm, gene distributions (px,ex)

load(filein);
clear ng ns h;

if jx==0 % Only 1 index is provided
    jx = ix;
end
kl = zeros([length(ix) length(jx)]);

for i = 1:length(ix)
    if sum(dm(ix(i),:))==0
        continue;
    end
    for j = 1:length(jx)
        if (sum(dm(jx(j),:))==0)
            continue;
        end
        % Calculate KL divergence
        kl(i,j) = -nansum(px(i,:).*log(px(j,:)./px(i,:)));
    end
end
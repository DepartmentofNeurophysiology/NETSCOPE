function [mi,ix,jx] = mtinf_comp(filein,ix,jx)
%% Calculate mutual information between two gene expression matrices
% Filein contains gene expression matrix dm, gene distributions (px,ex)

% If function is called independently (not by corr_par_send)
a = load(filein);
dm = a.dm;
if isfield(a,'px')
    px = a.px;
    ex = a.ex;
else
    [px,ex] = calcEntropy(dm);
end
clear a;

% Since MI matrix is symmetric, if ix==jx only half of the MI matrix is
% calculated. If no ix or jx is provided, take the entire DM
if nargin==1
    ix = 1:size(dm,1);
    jx = ix;
    half = true;
elseif jx==0
    jx = ix;
    half = true;
else
    half = false;
end
mi = zeros([length(ix) length(jx)]);

for i = 1:length(ix)
    if sum(dm(ix(i),:))==0
        continue;
    end
    for j = 1:length(jx)
        if (half && ix(i)<=jx(j)) || (sum(dm(jx(j),:))==0)
            continue;
        end
        % Convert bin edges to bin centers
        ctrs = {ex{ix(i)}(1:end-1) + (ex{ix(i)}(2)-ex{ix(i)}(1))/2 ...
            ex{jx(j)}(1:end-1) + (ex{jx(j)}(2)-ex{jx(j)}(1))/2};
        pxy = hist3([dm(ix(i),:)' dm(jx(j),:)'],ctrs);
        pxy = pxy / sum(pxy(:));
        % Calculate unnormalized mutual information
        mi(i,j) = sum(nansum(pxy .* log(pxy ./ (px{ix(i)}'*px{jx(j)}))));
        if isinf(mi(i,j)) % workaround
            pxy = hist3([dm(ix(i),:)' dm(jx(j),:)'],'Edges', ...
                [ex(ix(i)) ex(jx(j))]);
            pxy = pxy(1:end-1,1:end-1) / sum(pxy(:));
            mi(i,j) = sum(nansum(pxy .* log(pxy ./ (px{ix(i)}'*px{jx(j)}))));
        end
    end
end

if half
    mi = max(mi,mi');
end
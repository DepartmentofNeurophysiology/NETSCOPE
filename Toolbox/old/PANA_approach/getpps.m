function [plm,pp] = getpps(x,genes,pw_genes)

n = length(genes);
nf = size(plm,1);
m = size(plm,2);
alpha = 0.9; % Confidence interval for component selection
Q = 0.95; % Frequency cutoff for selected components

coeffs = cell(nf,1); % Pf
scores = cell(nf,1); % Tf

for r = 1:1000 % R repetitions for bootstrapping
    
    % Sample random matrix, calculate gene variance
    xr = x(:,datasample(x,m));
    v = var(xr,[],2);
    gam_par = gamfit(v);
    % Determine component selection threshold
    cutoff = gaminv(1-alpha,gam_par(1),gam_par(2));
    
    % Select components
    for p = 1:nf % For every pathway submatrix
        xf = xr(pw_genes{p});
        [comp,sc,gene_var] = pca(xf');
        ind = gene_var>cutoff;
        coeffs{p} = [coeffs{p};comp(:,ind)'];
        scores{p} = [scores{p};sc(:,ind)'];
    end
end

% Count components
for p = 1:nf
    comps = unique(coeffs{p},'rows');
    count = zeros(size(comps,1),1);
    for i = 1:size(comps,1)
        count(i) = sum(ismember(coeffs{p},comps(i,:)));
    end
end
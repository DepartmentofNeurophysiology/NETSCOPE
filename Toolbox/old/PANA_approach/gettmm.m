function tmm = gettmm(dm)

dm = double(dm);
ns = size(dm,2);
tmm = ones(1,ns);

% Use first sample as reference
yref = dm(:,1); % Reference read counts
nr = sum(yref); % Reference read number

for k = 2:ns
    yk = dm(:,k); % Read counts
    nk = sum(yk); % Sample read number
    
    % Filter out 0's
    index = yref>0 & yk>0;
    yr = yref(index);
    yk = yk(index);
    
    % Trim data
    mk = log2( (yk/nk)./(yr/nr) ); % Gene-wise log-fold-change
    mks = sort(mk);
    lo = mks(floor(0.3*length(mks)));
    hi = mks(ceil(0.7*length(mks)));
    index = mk>lo & mk<hi;
    
    ak = log2( (yk/nk).*(yr/nr) ); % Absolute expression level
    aks = sort(ak);
    lo = aks(floor(0.3*length(aks)));
    hi = mks(ceil(0.7*length(aks)));
    index = index & (ak>lo & ak<hi);
    
    yr = yr(index);
    yk = yk(index);
    
    % Calculate TMM
    wkr = (nk-yk)./(nk*yk) + (nr-yr)./(nr*yr);
    mkr = log2(yk/nk)./log2(yr/nr);
    tmm(k) = sum(wkr.*mkr) / sum(wkr);
end
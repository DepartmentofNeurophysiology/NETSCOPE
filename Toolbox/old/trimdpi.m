function mt = trimdpi(m)

% Assume matrix is undirected, remove lower triangle
m = tril(m,-1)';

mt = m; % Trimmed matrix
n = size(m,1);
for i = 1:(n-2)
    if sum([m(i,:) m(:,i)'])==0
        continue;
    end
    for j = (i+1):(n-1)
        if sum([m(j,:) m(:,j)'])==0 || m(i,j)==0
            continue;
        end
        for k = (j+1):n
            if sum([m(k,:) m(:,k)'])==0 || m(j,k)==0 || m(i,k)==0
                continue;
            end
            
            if m(i,j) < m(j,k)
                if m(i,j) < m(i,k)
                    mt(i,j) = 0;
                else
                    mt(i,k) = 0;
                end
            elseif m(i,k) < m(j,k)
                mt(i,k) = 0;
            else
                mt(j,k) = 0;
            end
        end
    end
end
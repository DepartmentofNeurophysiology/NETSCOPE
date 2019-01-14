function x = sampleFrom(ex,px,n)
% Sample n random points from the distribution that models xi
% Optional: specify domain to sample from
% 
% px: PDF
% ex: domain of PDF
% n: number of points to sample
% 
% x: sampled points from original distribution

x = zeros(1,n); % Sampled datapoints

cdfx = cumtrapz(px);
cdfx = cdfx/cdfx(end);

for i = 1:n
    j = find(rand>cdfx,1);
    x(i) = ex(j);
    y(i) = cdfx(j);
end
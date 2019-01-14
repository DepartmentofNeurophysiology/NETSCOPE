function p = getksd(z,x,h)
%% Alternative for ksdensity() with bivariate data for older MATLAB versions
% z: bivariate data (two-column matrix)
% x: points to evaluate kernel function at
% h: bandwidth
% 
% p: function evaluated at x

n = size(x,1);
m = size(z,1);
p = zeros(n,1);

%for i = 1:m
%    d = sqrt(sum( (repmat(z(i,:),n,1)-x).^2 ,2));
%    p = p + normpdf(d/h) / h^2;
%end

for i = 1:m
    p = p + mvnpdf((repmat(z(i,:),n,1)-x)/h) / h;
end
p = p/m;
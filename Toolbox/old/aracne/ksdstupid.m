function [mi,h1,h2] = ksdstupid(dm,i)

n = size(dm,1);
mi = zeros(1,n);
h1 = zeros(1,n);
h2 = zeros(1,n);

for j = 1:n
    [mi(j),h1(j),h2(j)] = getjpd(dm(i,:)',dm(j,:)');
end
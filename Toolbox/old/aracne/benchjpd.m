function [mi,h1,h2] = benchjpd(bw)

n = length(bw);
mi = zeros(n+1,4); % rn_eq,rn,on_rn,on - hhh,lhh,lhl,hll
h1 = zeros(n+1,4);
h2 = zeros(n+1,4);

for i = 1:n
    x1 = randn(1000,1);
    [~,mi(i,1),h1(i,1),h2(i,1)] = getjpd(x1,x1,bw(i));
    [~,mi(i,2),h1(i,2),h2(i,2)] = getjpd(x1,randn(1000,1),bw(i));
    [~,mi(i,3),h1(i,3),h2(i,3)] = getjpd(x1,ones(1000,1),bw(i));
    [~,mi(i,4),h1(i,4),h2(i,4)] = getjpd(ones(1000,1),ones(1000,1),bw(i));
    disp(i);
end

i = n+1;
[~,mi(i,1),h1(i,1),h2(i,1)] = getjpd(x1,x1);
[~,mi(i,2),h1(i,2),h2(i,2)] = getjpd(x1,randn(1000,1));
[~,mi(i,3),h1(i,3),h2(i,3)] = getjpd(x1,ones(1000,1));
[~,mi(i,4),h1(i,4),h2(i,4)] = getjpd(ones(1000,1),ones(1000,1));
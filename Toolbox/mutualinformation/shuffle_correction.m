function shuffle_correction(gem,n,out)

ng = size(gem,1);
out = matfile(out,'Writable',true);
out.mi = zeros(ng,ng,n);

for i = 1:n
    sgem = shuffle_GEM(gem);
    out.mi(1:ng,1:ng,i) = compute_MI(sgem);
    lsdkfjslkd
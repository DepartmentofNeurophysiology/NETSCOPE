ind = [1 3 5 7 8 9];
x = 0:0.001:1;
n = cell(6,1);
for i = 1:length(ind)
  n{i} = zeros(1,1000);
end


for i = 1:length(ind)
    load(['shuffled_mi_' num2str(ind(i))]);

    for j = 1:1000:19972
        mib = mi(j:min(j+999,19972),1:19972);

        for k = 1:1000
            n{i}(k) = n{i}(k) + length(find(mib>x(k) & mib<=x(k+1)));
        end
    end
end
save('shufflehists','x','n');
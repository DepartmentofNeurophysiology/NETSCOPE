function genmaps(input)
%% Generate maps and compute statistics for various subsets of the network

load(input,'corr','genes','genestruct');
skipfields = {'dist'};
fn = fieldnames(genestruct);
np = length(fn);

%% Partition networks
for i = 1:np
    [~,index] = ismember(genestruct.(fn{i}),genes); % genes(index) = genestruct.ddd
    a.(fn{i}).genes = genestruct.(fn{i});
    a.(fn{i}) = networkpipeline(corr(index,index),skipfields);
end

save(input,'-struct','a','-append');
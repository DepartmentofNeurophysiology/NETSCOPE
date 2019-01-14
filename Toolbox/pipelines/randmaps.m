function randmaps(input,nreps)
%% Generate random maps with same degree as real maps
% Now with better data organization

a = load(input);
fn = fieldnames(a);
nmaps = length(fn);
skipfields = {'dist','localcc'};

for j = 1:nmaps
    if ~isfield(a.(fn{j}),'map')
        continue;
    end
    for i = 1:nreps
        map = a.(fn{j}).map;
        map = reshape(map(randperm(numel(map))),size(map)); % Shuffle connections
        rm = networkpipeline(map,skipfields);
        a.(fn{j}).rgcc(1,i) = rm.globalcc;
        a.(fn{j}).rdos(1,i) = mean(rm.dos(~isinf(rm.dos)));
        a.(fn{j}).filtered.rgcc(1,i) = rm.filtered.globalcc;
        a.(fn{j}).filtered.rdos(1,i) = mean(rm.filtered.dos(~isinf(rm.filtered.dos)));
        
        %disp([i j]);
    end
    %% Calculate small-worldness coefficient
    a.(fn{j}).sigma = (a.(fn{j}).globalcc/mean(a.(fn{j}).rgcc)) ...
        / (mean(a.(fn{j}).dos(~isinf(a.(fn{j}).dos)))/mean(a.(fn{j}).rdos));
end

save(input,'-struct','a');
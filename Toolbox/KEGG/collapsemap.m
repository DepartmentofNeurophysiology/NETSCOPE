function avg = collapsemap(map,nodes)
%% Collapse map by averaging groups of genes into nodes
% map: map
% nodes: cell array with indices of genes that belong to a node
% 
% avg: collapsed map

n = length(nodes); % Number of groups
avg = zeros(n);

for i = 1:n
    if isempty(nodes{i})
        continue;
    end
    
    for j = 1:n
        if isempty(nodes{j})
            continue;
        end
        
        avg(i,j) = mean(mean(map(nodes{i},nodes{j})));
        
    end
end
function map = addgenes(map,g)
%% Add all-zero rows and columns to a matrix
% 
% map: matrix
% g: rows/columns (array)
% 
% map: extended matrix

g = reshape(g,[1 length(g)]);
for i = g
    map = [map(1:i-1,:);zeros(1,size(map,2));map(i:end,:)];
    map = [map(:,1:i-1) zeros(size(map,1),1) map(:,i:end)];
end
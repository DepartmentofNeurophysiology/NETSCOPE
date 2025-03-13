function shuffled = shuffle_data(data)
%% Column-wise shuffle the data matrix
% Shuffle each column of the data matrix to remove any correlations between
% variables but preserve the sample-specific profiles.
% 
% shuffled = shuffle_data(data)
% 
% Input:
% data: data matrix (rows are variables, columns are samples)
% 
% Output:
% shuffled: shuffled data matrix

shuffled = zeros(size(data));
for i = 1:size(data,2)
    shuffled(:,i) = data(randperm(size(data,1)),i);
end
%% This script reconstructs a network from artificial expression data
% The connectivity matrix for a "ground truth" network is generated that
% consists of ND=100 disconnected sets of NC=10 nodes that are linearly
% connected. Expression data is then generated that conserves this topology
% and adds some noise. Then, the TITAN toolbox is used to infer a network 
% from the expression data. The network is compared to the ground truth
% network and quantified in terms of false positive rate and true positive
% rate.
% 
% Parameters:
% nsamples: array of numbers of samples to be used for artificial data
% noisefactor: array of noise factors for adding noise to artificial data
% ND: number of separate subgraphs in the ground truth graph
% NC: number of nodes per subgraph
% 
% The results are stored in two variables:
% fpr: false positive rate - array of size (length(nsamples) x length(noisefactor))
% tpr: false positive rate - array of size (length(nsamples) x length(noisefactor))
% 
% To recreate Figure 3 from the paper use the following values:
ND = 100;
NC = 10;
nsamples = [100 1000 4000 8000];
noisefactor = [.1 .3 .5];
% The resulting (fpr,tpr) matrices correspond to the data points from
% Figure 3A (with some variance).


startup;
fpr = zeros(length(nsamples), length(noisefactor));
tpr = zeros(length(nsamples), length(noisefactor));

for s = 1:length(nsamples) % Iterate over nsamples
    for n = 1:length(noisefactor) % Iterate over noisefactor
        %% Loop info
        fprintf("Settings: nsamples = %d, noisefactor = %f\n", nsamples(s), noisefactor(n));

        %% Generate connectivity matrix for ground truth network
        fprintf("Generating connectivity matrix for ground truth network\n");
        groundtruth = false(ND*NC);
        for i = 1:(ND*NC)
            for j = 1:i
                if i - j == ND
                    groundtruth(i,j) = true;
                    groundtruth(j,i) = true;
                end
            end
        end

        %% Generate expression data
        fprintf("Generating expression data\n");
        means = 0.2 + rand(ND, 1) * 1.8; % Means are between 0.2 and 1.8
        gem = exprnd(repmat(means, 1, nsamples(s))); % First layer of nodes

        for i = 1:NC-1
            % Copy previous layer and add noise
            gem = [gem ; gem(end+1-ND:end,:) .* (1 + randn(ND,nsamples(s)) * noisefactor(n))];
        end

        %% Reconstruct network using TITAN
        fprintf("Computing MI matrix\n");
        mi = compute_MI(gem);
        % Store MI matrices of 8000-sample networks for generating figures later on
        if nsamples(s)==8000
            mi_s8000{n} = mi;
        end

        %% Calculate cutoff point with shuffle correction (repeat n times for better results)
        fprintf("Computing MI matrix for shuffle correction\n");
        shuffled_gem = shuffle_GEM(gem);
        shuffled_mi = compute_MI(shuffled_gem);
        threshold = median(shuffled_mi(:)) + 3 * std(shuffled_mi(:));

        %% Evaluate resulting network
        fprintf("Evaluating network\n");
        mi(mi<threshold) = 0;           % Remove connections under threshold
        network = sparsify_network(mi); % Sparsify network
        network = network > 0;          % Binarize network

        tp = sum(sum(network & groundtruth));         % True positives
        tn = sum(sum((~network) & (~groundtruth)));   % True negatives
        fp = sum(sum(network & (~groundtruth)));      % False positives
        fn = sum(sum((~network) & groundtruth));      % False negatives
        tpr(s,n) = tp / (tp+fn);                      % True positive rate
        fpr(s,n) = fp / (fp+tn);                      % False positive rate

        fprintf("Results:\n\tFalse positive rate: %f\n\tTrue positive rate: %f\n", fpr(s,n), tpr(s,n));
    end
end

%% Calculate Degree of Separation
fprintf("Calculating Degree of Separation matrix\n");
dos = get_dos_matrix(network);

%% Recreate Figure from FPR, TPR and DOS
fprintf("Drawing ROC plot\n");
figure;
subplot(2, 3, 1:3);
hold on; box on;
mkr_size = 18 + (1:length(nsamples)) * 12;
for i = 1:length(noisefactor)
    scatter(fpr(:,i), tpr(:,i), mkr_size, 'filled');
end
xlabel('False positive rate');
ylabel('True positive rate');
l = legend(sprintfc('%2.0f%%', noisefactor*100), 'Location', 'southwest');
l.Title.String = "Noise factor";

fprintf("Drawing boxplots\n");
for i = 1:3
    subplot(2, 3, i+3);
    boxplot(mi_s8000{i}(dos>0), dos(dos>0), 'Colors', 'k', 'Symbol', 'k.');
    ylim([-0.0216 0.6516]);
    xlabel('Degree of Separation');
    ylabel('Mutual Information');
    title(sprintf('NSamples=8000, Noise factor=%2.0f%%', noisefactor(i)*100));
end
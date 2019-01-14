function createfigures2(full,index,folder)
%% Create figures that compare significant/control genes within one network
% full: network data struct
% index: index for control/significant genes (array, true for significant genes,
% false for controls)
% folder: output folder

% Filter out nodes with no connections
rm_nodes = sum(full.map)==0;
full.map(rm_nodes,:) = [];
full.map(:,rm_nodes) = [];
full.dos(rm_nodes,:) = [];
full.dos(:,rm_nodes) = [];
index(rm_nodes) = [];

%% Degree distribution sig-sig, cont-cont, sig-cont
s = mean(full.map(index,index)>0);
c = mean(full.map(~index,~index)>0);
sc = mean(full.map(index,~index)>0);
[~,bins] = histcounts([s c sc]);
f = figure('Visible','off');
% Significant genes
histogram(s,bins,'normalization','probability');
hold on;
% Controls
histogram(c,bins,'normalization','probability');
% Sig-Cont
histogram(sc,bins,'normalization','probability');

legend('Significant','Control','Sig-Cont');
xlabel('Normalized degree');
ylabel('Probability');
title('Degree distributions of significant/control genes');
savefigas(f,fullfile(folder,'degree-compare'));
close(f);

%% DEG boxplot
f = figure('Visible','off');
labels = [repmat({'Significant'},size(s)) repmat({'Control'},size(c)) ...
    repmat({'Sig-Cont'},size(sc))];
boxplot([s c sc],labels);
ylim([0 1]);
ylabel('Normalized degree');
title('Degree distributions of significant/control genes');
savefigas(f,fullfile(folder,'degree-boxplot'));
close(f);

%% DOS distribution, sig-sig, cont-cont, sig-cont
full.dos(isinf(full.dos)) = nan;
s = nanmean(full.dos(index,index));
c = nanmean(full.dos(~index,~index));
sc = nanmean(full.dos(index,~index));
[~,bins] = histcounts([s c]);
f = figure('Visible','off');
% Significant genes
histogram(s,bins,'normalization','probability');
hold on;
% Controls
histogram(c,bins,'normalization','probability');
% Sig-Cont
histogram(sc,bins,'normalization','probability');

legend('Significant','Control','Sig-Cont');
xlabel('Average DoS');
ylabel('Probability');
title('Average DoS distributions of significant/control genes');
savefigas(f,fullfile(folder,'dos-compare'));
close(f);

%% DOS boxplot
labels = [repmat({'Significant'},size(s)) repmat({'Control'},size(c)) ...
    repmat({'Sig-Cont'},size(sc))];
f = figure('Visible','off');
boxplot([s c sc],labels);
ylim([0 2]); % 2 for gset=ls/edp, 4 for gset=edp23/edp4/edpindep
ylabel('Average DoS');
title('Average DoS distributions of significant/control genes');
savefigas(f,fullfile(folder,'dos-boxplot'));
close(f);
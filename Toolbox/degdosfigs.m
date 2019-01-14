function degdosfigs(gset,sparse)

if sparse
    outdir = sprintf('figs\\sparse\\%s\\',gset);
else
    outdir = sprintf('figs\\%s\\',gset);
end
c1 = {'exc','inh','gli'};
class = {'class7','class3','class8'};
classs = {'excitatory','inhibitory','glia'};
map = cell(3,1);
dos = cell(3,1);
degdata = [];
dosdata = [];
gr = cell(1,2);
for i = 1:3 % for every cell type
    fname = sprintf('data_Tido\\mutualinfo\\%s\\%s',gset,class{i});
    load(fname,'genestruct','full','sig');
    index = ismember(genestruct.full,genestruct.sig);
    if sparse
        full = full.filtered;
        sig = sig.filtered;
    end
    
    rm_nodes = sum(sig.map)==0;
    sig.map(rm_nodes,:) = [];
    sig.map(:,rm_nodes) = [];
    cluster_table = linkage(double(sig.map>0),'complete','cityblock'); % Clustering
    f = figure('Visible','off');
    dendrogram(cluster_table,0);
    set(gca,'xtick',[]);
    title('Hierarchical clustering of genes by connectivity');
    savefigas(f,[outdir '\' classs{i} '\dendrogram']);
    close(f);
    
    % Filter out nodes with no connections
    map{i} = full.map;
    dos{i} = full.dos;
    rm_nodes = sum(map{i})==0;
    map{i}(rm_nodes,:) = [];
    map{i}(:,rm_nodes) = [];
    dos{i}(rm_nodes,:) = [];
    dos{i}(:,rm_nodes) = [];
    index(rm_nodes) = [];
    
    s = mean(map{i}(index,index)>0);
    c = mean(map{i}(~index,~index)>0);
    sc = mean(map{i}(index,~index)>0);
    degdata = [degdata s c sc];
    
    s = mean(dos{i}(index,index));
    c = mean(dos{i}(~index,~index));
    sc = mean(dos{i}(index,~index));
    dosdata = [dosdata s c sc];
    
    gr{1} = [gr{1} repmat({'s'},size(s)) repmat({'c'},size(c)) repmat({'sc'},size(sc))];
    gr{2} = [gr{2} repmat(c1(i),size([s c sc]))];
end
clear full genestruct fname rm_nodes;

f = figure('Visible','off');
boxplot(degdata,gr,'factorgap',[8 0],'fullfactor','on','widths',0.8);
if sparse
    ylim([0 0.25]);
else
    ylim([0 1]);
end
ylabel('Probability of connection');
title('Degree distributions of significant/control genes');
savefigas(f,[outdir 'deg_boxplot']);
close(f);

f = figure('Visible','off');
boxplot(dosdata,gr,'factorgap',[8 0],'fullfactor','on','widths',0.8);
if sparse
    ylim([1 5]);
else
    ylim([1 2]);
end
ylabel('Average DoS');
title('Average DoS distributions of significant/control genes');
savefigas(f,[outdir 'dos_boxplot']);
close(f);

% Save boxplot data for statistics
fname = 'figs\stats.xlsx';
sig1 = {'s','c','sc'};
sig2 = {'c','sc','s'};
pdeg = zeros(3,3);
mndeg = zeros(3,3);
stdeg = zeros(3,3);
pdos = zeros(3,3);
mndos = zeros(3,3);
stdos = zeros(3,3);
for i = 1:3 % for s,c,sc
    for j = 1:3 % for every cell type
        index1 = find(strcmp(gr{1},sig1{i})&strcmp(gr{2},c1{j}));
        index2 = find(strcmp(gr{1},sig2{i})&strcmp(gr{2},c1{j}));
        [~,pdeg(i,j)] = ttest2(degdata(index1),degdata(index2));
        [~,pdos(i,j)] = ttest2(dosdata(index1),dosdata(index2));
        mndeg(i,j) = mean(degdata(index1));
        stdeg(i,j) = std(degdata(index1));
        mndos(i,j) = mean(dosdata(index1));
        stdos(i,j) = std(dosdata(index1));
    end
end
pdeg = table(pdeg(:,1),pdeg(:,2),pdeg(:,3), ...
    'variablenames',classs,'rownames',strcat(sig1,'/',sig2));
mndeg = table(mndeg(:,1),mndeg(:,2),mndeg(:,3), ...
    'variablenames',classs,'rownames',sig1);
stdeg = table(stdeg(:,1),stdeg(:,2),stdeg(:,3), ...
    'variablenames',classs,'rownames',sig1);
pdos = table(pdos(:,1),pdos(:,2),pdos(:,3), ...
    'variablenames',classs,'rownames',strcat(sig1,'/',sig2));
mndos = table(mndos(:,1),mndos(:,2),mndos(:,3), ...
    'variablenames',classs,'rownames',sig1);
stdos = table(stdos(:,1),stdos(:,2),stdos(:,3), ...
    'variablenames',classs,'rownames',sig1);
writetable(pdeg,fname,'sheet',gset,'range','A3:D6','writerownames',true);
writetable(mndeg,fname,'sheet',gset,'range','A8:D11','writerownames',true);
writetable(stdeg,fname,'sheet',gset,'range','A13:D16','writerownames',true);
writetable(pdos,fname,'sheet',gset,'range','F3:I6','writerownames',true);
writetable(mndos,fname,'sheet',gset,'range','F8:I11','writerownames',true);
writetable(stdos,fname,'sheet',gset,'range','F13:I16','writerownames',true);

c2 = c1([2 3 1]);
pdeg = zeros(3);
pdos = zeros(3);
for i = 1:3 % cell type
    for j = 1:3 % s, c, sc
        index1 = find(strcmp(gr{1},sig1{j})&strcmp(gr{2},c1{i}));
        index2 = find(strcmp(gr{1},sig2{j})&strcmp(gr{2},c2{i}));
        [~,pdeg(i,j)] = ttest2(degdata(index1),degdata(index2));
        [~,pdos(i,j)] = ttest2(dosdata(index1),dosdata(index2));
    end
end
pdeg = table(pdeg(:,1),pdeg(:,2),pdeg(:,3), ...
    'variablenames',sig1,'rownames',strcat(c1,'/',c2));
pdos = table(pdos(:,1),pdos(:,2),pdos(:,3), ...
    'variablenames',sig1,'rownames',strcat(c1,'/',c2));
writetable(pdeg,fname,'sheet',gset,'range','A18:D21','writerownames',true);
writetable(pdos,fname,'sheet',gset,'range','F18:I21','writerownames',true);
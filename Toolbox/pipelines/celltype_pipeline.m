function celltype_pipeline(genestruct,folder,samples,suffix)
%% Pipeline from gene expression data to network statistics
% Find genes in Linarsson dataset
% Select gene subset and create gene expression submatrix
% Select celltype-specific samples and calculate MI
% Create celltype-specific networks and calculate statistics
% Create random networks and calculate small-worldness
% 
% genes: struct with lists of gene names to include
% folder: folder for output files
% samples: true/false whether to include only 84 samples per celltype
% suffix: suffix to add to filenames

if exist(folder,'dir')~=7
    mkdir(folder);
end
load('ge_data','dm','data','genelist','class1');

%% Reorganize genes and couple to Linarsson genes
disp('Matching genes');
ct = [3 7 8]; % Cell types to include
fn = fieldnames(genestruct);
np = length(fn);
genes = [];
for i = 1:np
    found = ismember(genestruct.(fn{i}),genelist);
    genestruct.(fn{i}) = genestruct.(fn{i})(found);
    genes = [genes;genestruct.(fn{i})];
end
genes = unique(genes);
[~,index] = ismember(genes,genelist); % genelist(index) = genes
dm = dm(index,:);
dmm = dm;
clear genelist;

%% Compute MI matrix for 6 cell types
disp('Computing MI matrices');
for i = ct
    if i==8 % glial cells
        dm = dmm(:,(data.class1==1|data.class1==4|data.class1==5)&data.tissue==2);
    else
        dm = dmm(:,data.class1==i&data.tissue==2);
    end
    if samples
        dm = dm(:,randperm(size(dm,2),84));
    end
    output = [fullfile(folder,'class') num2str(i) suffix];
    corr_par_send(dm,output);
    save(output,'genes','genestruct','-append');
end

%% Calculate network statistics, generate figures
delete(gcp('nocreate')); % Delete parallel pool created by corr_par_send
for i = 1:length(ct)
    fprintf('\nComputing network statistics and generating figures for celltype %d/%d\n',i,length(ct))
    input = [fullfile(folder,'class') num2str(ct(i)) suffix];
    genmaps(input);
    %randmaps(input,10);
    %genfigures(input,fullfile(folder,'figures',['class' num2str(ct(i))]));
end
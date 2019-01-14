function sample_pipeline(genestruct,output,samples)
%% Pipeline from gene expression data to network statistics
% Find genes in Linarsson dataset
% Select gene subset and create gene expression submatrix
% Select celltype-specific samples and calculate MI
% Create celltype-specific networks and calculate statistics
% Create random networks and calculate small-worldness
% 
% genes: struct with lists of gene names to include
% output: output file path/name
% samples: what samples to use for MI calculation

[folder,fname] = fileparts(output);
if exist(folder,'dir')~=7
    mkdir(folder);
end

%% Reorganize genes and couple to Linarsson genes
disp('Matching genes');
load('ge_data','dm','data','genelist');
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

%% Compute MI matrix
disp('Computing MI matrix');
dm = dmm(:,samples);
corr_par_send(dm,output);
save(output,'genes','genestruct','-append');

%% Calculate network statistics, generate figures
%delete(gcp('nocreate')); % Delete parallel pool created by corr_par_send
disp('Computing network statistics');
genmaps(output);
disp('Computing random network statistics');
randmaps(output,10);
disp('Generating figures');
genfigures(output,fullfile(folder,'figures',fname));
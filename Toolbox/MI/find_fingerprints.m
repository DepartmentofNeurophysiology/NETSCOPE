function find_fingerprints
%% Compute class-specific MI matrix
% creates temporary file 'subdm.mat' in current dir
% saves output in 'classn.mat' where n=class, in current dir

ge_data = 'F:\Tido\Msc-project\data_Tido\ge_data';
load(ge_data,'data');
classes = [7]; % Skip 6
ssc_index = data.tissue==2; % Select somatosensory cortex

% Compute matrices
for i = classes
    index = ssc_index & data.class1==i;
    load(ge_data,'dm');
    dm = dm(:,index);
    save('subdm','dm');
    clear dm;

    outname = sprintf('class%d',i);
    corr_par_send('subdm',outname,5000,'mi',1,0);
end
delete(gcp);
clear data outname;

%{
% Count matrices
x = -0.001:0.001:1.001;
n = cell(length(classes),1);
for i = classes
    n{i} = get_distribution(sprintf([folder 'class%d'],i));
    disp(i);
end
save('data_Tido\mutualinfo\class-fingerprints\mi_dists','x','n');
clear x n;

% Sort matrices
o = cell(length(classes),1);
comps = o;
for i = classes
    [o{i},comps{i}] = sortmatrix(sprintf([folder 'class%d'],i),10);
    disp(i);
end
save('data_Tido\mutualinfo\class-fingerprints\orders','o','comps');
clear;
%}
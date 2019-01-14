function genfigures(input,output,sparse)
%% Generate network statistics figures
% Save as FIG and PNG
% createfigures.m creates figures with statistics of the significant genes
% createfigures2.m creates figures comparing the statistics of significant
% and control genes
% 
% input: input file, e.g. 'class1'
% output: output dir

%% Remove file ext from input
[folder,fname] = fileparts(input);
input = fullfile(folder,fname);
%% Load data
load(input,'genestruct');
load(input,'sig','full');
if sparse
    sig = sig.filtered;
    full = full.filtered;
end
% Significant networks
createfigures(sig,output);
% Full networks
index = ismember(genestruct.full,genestruct.sig);
%createfigures2(full,index,output);

%%
%{
    % Gephi
    data.part = cell(size(full.map,1),1);
    data.part(1:ns) = {'sig'};
    data.part((ns+1):end) = {'cont'};
    exportNetwork(genelist,full.filtered.map,data,class1{i},0);
%}
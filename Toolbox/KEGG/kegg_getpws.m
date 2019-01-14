function [pw_ids,pw_names] = kegg_getpws(org)
%% Get information for all KEGG pathways for an organism
% 
% org: organism, e.g. 'mmu' (mus musculus)
% 
% pw_ids: KEGG pathway IDs
% pw_names: pathway names

fprintf('Downloading KEGG pathways for %s ... ',org);
url = sprintf('http://rest.kegg.jp/list/pathway/%s',org);
data = urlread(url,'TimeOut',10);
data = textscan(data,'path:%s\t%[^\n]');
pw_ids = data{1}; % KEGG pathway IDs
pw_names = data{2}; % pathway names
fprintf('%d pathways found.\n',length(pw_ids));
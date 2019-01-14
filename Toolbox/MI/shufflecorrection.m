function shufflecorrection(infile,outfolder)
% If you abort this function during mtinf_par_fetch(), first execute
% mtinf_par_fetch() and then shufflecorrection() to continue.

global f;
if ~isempty(f)
    corr_par_fetch;
end

R = 10; % Iterations
ng = 19972; % Number of genes
ns = 3005; % Number of samples

r = 1;
while exist(sprintf('%s\\shuffled_mi_%d.mat',outfolder,r),'file')==2
    r = r+1;
end

while r <= R
    fprintf('Computing shuffled matrix %d out of %d\n\n',r,R);
    
    % Shuffle columns
    load(infile,'dm');
    for i = 1:ns
        dm(:,i) = dm(randperm(ng),i);
    end
    save('shuffdm','dm');
    
    % Compute MI matrix
    fname = sprintf('%s\\shuffled_mi_%d.mat',outfolder,r);
    corr_par_send('shuffdm',fname,6000,'mi',1,0);
    
    r = r+1;
end
delete('shuffdm.mat');
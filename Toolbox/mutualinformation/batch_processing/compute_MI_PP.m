function compute_MI_PP(gem,file,px,ex,h,batch,fetch,cont)
%% This function is called from compute_MI_batch()

%% Set up batch structure
fprintf('Start time: %s\n',datestr(datetime('now')));
ngenes = size(gem,1);
% Declare global variables that can be used by fetching function
clearvars -global jobs outfile tempfile;
global jobs outfile tempfile;
tempfile = tempname(); % Temporary file for provisional results
save(tempfile,'gem','px','ex');

% Open output file, allocate matrix if it doesn't exist
outfile = matfile(file,'Writable',true);
if ~cont
    fprintf('Allocating memory for matrix\n');
    outfile.mi = zeros(ngenes);
end
outfile.h = h;

%% Create parallel pool and parallel batch jobs
gcp();
jobs = [];
lp = 1:batch:ngenes; % Loop index
for i = 1:length(lp)
    ix = lp(i):min(ngenes,lp(i)+batch-1);
    
    for j = 1:i
        jx = lp(j):min(ngenes,lp(j)+batch-1);
        
        if cont && sum(sum(outfile.mi(ix,jx)))>0
            continue;
        end

        if i==j
            jobs = [jobs;parfeval(@process_batch,3,tempfile,ix,0)];
        else
            jobs = [jobs;parfeval(@process_batch,3,tempfile,ix,jx)];
        end
    end
end

% Start fetching data right away
if fetch
    clear;
    fetch_results;
end
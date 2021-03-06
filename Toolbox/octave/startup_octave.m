%% Add Toolbox dirs to path
restoredefaultpath;
addpath(genpath('Toolbox'));

%% Load necessary packages
def = warning;
warning('off','all');
pkg load statistics;
warning(def);

%% Ignore division by zero errors (toolbox can work with Inf values)
warning('off','Octave:divide-by-zero');

clear RESTOREDEFAULTPATH_EXECUTED ans def;

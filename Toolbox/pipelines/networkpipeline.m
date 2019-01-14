function map = networkpipeline(map,skipfields)
% Save paths separately to save time when saving to a file
% skipfields: cell array of fieldnames to skip - possible values:
% filtered, dist, centrality, localcc, dos

if nargin==1
    skipfields = {};
end
if ~isstruct(map)
    map = struct('map',map);
end
load('distributions','t');

%% Approach 1:
% Previously:
% ls_corr = full_corr(ge_loc([s23;s4;c23;c4]),ge_loc([s23;s4;c23;c4]));
% Threshold matrix after shuffle correction
map.map(map.map<t) = 0;
% Symmetrize matrix (make network undirected)
map.map = (map.map+map.map')/2;

if ~isfield(map,'filtered')
    % Sparsify network using DPI and calculate global CC
    %disp('Counting triangles and network sparsification');
    [map.filtered,map.globalcc] = network_sparsify(map.map);
    if isequal(map.map,map.filtered)
        map = rmfield(map,'filtered');
    end
end

if ~ismember('dist',skipfields)
    if ~isfield(map,'dist')
        % Calculate shortest paths, node centrality, local CC
        %disp('Calculating shortest paths');
        [map.dist,paths] = network_getpaths(map.map);
    end
    if ~ismember('centrality',skipfields)
        %disp('Calculating network centrality');
        map.centrality = network_hubs(map.map,paths);
    end
    clear paths;
end

if ~isfield(map,'localcc') && ~ismember('localcc',skipfields)
    %disp('Calculating local clustering coefficients');
    map.localcc = network_localcc(map.map);
end

if ~isfield(map,'dos') && ~ismember('dos',skipfields)
    %disp('Calculating degree of separation');
    map.dos = network_getpaths(map.map>0);
end

if isfield(map,'filtered')
    %disp('Networkpipeline for filtered map');
    map.filtered = networkpipeline(map.filtered,skipfields);
end
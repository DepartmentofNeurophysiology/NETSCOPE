function export_network(filename, labels, mi, directed, varargin)
%% Export network data to a file in GEXF format.
% Export a network to a GEXF (XML-like) file that can be loaded by network
% visualization software, Gephi in particular.
%
% export_network(filename, labels, mi, directed, ...)
%
% Input:
% filename: (required) name of output file.
% labels:   (required) N by 1 cell array with node labels.
% mi:       (required) MI/network matrix (N by N).
% directed: (required) true/false whether edge directionality should be
%           considered.
%
% Optionally, Name-Value argument pairs can be added to include data
% describing nodes or edges, like labels, in the file. This data can be
% used by the network software to e.g. filter the network. Node data should
% be passed as N by 1 array and edge data as N by N matrix.
%
% Limitation: node data can not be named 'id' or 'label' and edge data can
% not be named 'id', 'source', 'target' or 'weight'.
%
% Example (where Nodecolor, Edgecolor and Edgetype are optional data):
% exportNetwork('nw.gexf', labels, [N*N array], false, 'Nodecolor', ...
%           [N*1 array], 'Edgecolor', [N*N array], 'Edgetype', [N*N array])

%% Parse arguments
n = length(labels); % Number of nodes
nodedata = struct();
edgedata = struct();
for i = 1:2:length(varargin)
    if isequal(size(varargin{i+1}),[n 1])
        nodedata.(varargin{i}) = varargin{i+1};
    elseif isequal(size(varargin{i+1}),[n n])
        edgedata.(varargin{i}) = varargin{i+1};
    end
end
node_att = fieldnames(nodedata);
edge_att = fieldnames(edgedata);

%% Create XML document object
disp('Creating document...');
if length(filename) < 5
    filename = [filename '.gexf'];
elseif ~strcmp(filename(end-4:end),'.gexf')
    filename = [filename '.gexf'];
end
f = fopen(filename, 'w');
fprintf(f, '<?xml version="1.0" encoding="utf-8"?>\n<gexf version="1.3">\n');

%% Create graph element
if directed
    fprintf(f, '   <graph defaultedgemode="directed" mode="static">\n');
else
    mi = max(mi,mi');
    mi = tril(mi);
    fprintf(f, '   <graph defaultedgemode="undirected" mode="static">\n');
end

% Create node attribute elements
if ~isempty(node_att)
    node_att_str = '      <attributes class="node">\n';
    for i = 1:length(node_att)
        att_str = '         <attribute id="%d" title="%s" type="string"/>\n';
        node_att_str = [node_att_str sprintf(att_str, i-1, node_att{i})];
    end
    fprintf(f, [node_att_str '      </attributes>\n']);
end

% Create edge attribute elements
if ~isempty(edge_att)
    edge_att_str = '      <attributes class="edge">\n';
    for i = 1:length(edge_att)
        att_str = '         <attribute id="%d" title="%s" type="string"/>\n';
        edge_att_str = [edge_att_str sprintf(att_str, i-1, edge_att{i})];
    end
    fprintf(f, [edge_att_str '      </attributes>\n']);
end

%% Write node data to file
disp('Writing node data to document...');
fprintf(f, '      <nodes>\n');
for i = 1:n
    node_str = sprintf('         <node id="%d" label="%s"', i-1, labels{i});
    if ~isempty(node_att)
        node_str = [node_str '>\n            <attvalues>\n'];
        for j = 1:length(node_att)
            att_str = '               <attvalue for="%d" value="%s"/>\n';
            if iscell(nodedata.(node_att{j})(i))
                node_str = [node_str sprintf(att_str, j-1, nodedata.(node_att{j}){i})];
            else
                node_str = [node_str sprintf(att_str, j-1, num2str(nodedata.(node_att{j})(i)))];
            end
        end
        node_str = [node_str '            </attvalues>\n          </node>\n'];
    else
        node_str = [node_str '/>\n'];
    end
    fprintf(f, node_str);
end
fprintf(f, '      </nodes>\n');

%% Add edge data to graph element
disp('Writing edge data to document...');
fprintf(f, '      <edges>\n');
l = 0;
for i = 1:n
    for j = 1:n
        if mi(i,j)==0
            continue;
        end
        edge_str = '         <edge id="%d" source="%d" target="%d" weight="%f"';
        edge_str = sprintf(edge_str, l, i-1, j-1, mi(i,j));
        if ~isempty(edge_att)
            edge_str = [edge_str '>\n            <attvalues>\n'];
            for k = 1:length(edge_att)
                att_str = '               <attvalue for="%d" value="%s"/>\n';
                if iscell(edgedata.(edge_att{k})(i,j))
                    edge_str = [edge_str sprintf(att_str, k-1, edgedata.(edge_att{k}){i,j})];
                else
                    edge_str = [edge_str sprintf(att_str, k-1, num2str(edgedata.(edge_att{k})(i,j)))];
                end
            end
            edge_str = [edge_str '            </attvalues>\n         </edge>\n'];
        else
            edge_str = [edge_str '/>\n'];
        end
        fprintf(f, edge_str);
        l = l+1;
    end
end
fprintf(f, '      </edges>\n');

fprintf(f, '   </graph>\n</gexf>');
fclose(f);

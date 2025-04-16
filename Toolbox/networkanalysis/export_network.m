function export_network(filename,labels,mi,directed,varargin)
%% Export network data to a file in GEXF format.
% Export a network to a GEXF (XML-like) file that can be loaded by network
% visualization software, Gephi in particular.
% 
% export_network(filename,labels,mi,directed,...)
% 
% Input:
% filename: (required) name of output file.
% labels:   (required) N-length cell array with node labels.
% mi:       (required) MI/network matrix (N by N).
% directed: (required) true/false whether edge directionality should be
%           considered.
%
% Optionally, add properties for nodes and/or edges. For every property,
% include a parameter that is a struct with the following fields:
% % name:   Name of the property
% % data:   Values of the property for all nodes/edges. Whether the
%           property is interpreted as a node- or edge-related property
%           depends on the matrix size. If it is 'N by 1' or '1 by N', it
%           is a node property. If the size is 'N by N', it is an edge
%           propperty.
% % type:   Choose 'boolean', 'int', 'long', 'float', 'double', or 'string'
%
% Limitation: node data can not be named 'id' or 'label' and edge data can
% not be named 'id', 'source', 'target' or 'weight'. Script does not check
% for this!
% 
% Example (where node_size and edge_group are extra properties):
% export_network('nw.gexf', [N*1 cell arr], [N*N arr], false, ...
%                struct('name','node_size', 'data',[N*1 arr], 'type','float'), ...
%                struct('name','edge_group', 'data',[N*N arr], 'type','boolean'))

%% Check arguments
N = length(labels); % Number of nodes
node_props = [];
edge_props = [];
for i = 1:length(varargin)
    warning_ending=" in extra parameter " + num2str(i);
    
    for f = ["name", "data", "type"]
        assert(isfield(varargin{i}, f), f+" field missing" + warning_ending);
    end
    
    sz = size(varargin{i}.data);
    if isequal(sz, [1 N]) || isequal(sz, [N 1])
        node_props = [node_props varargin{i}];
    elseif isequal(sz, [N N])
        edge_props = [edge_props varargin{i}];
    else
        error("Wrong size [" + num2str(sz) + "]" + warning_ending);
    end
    
    types = ["boolean","int","long","float","double","string"];
    assert(ismember(varargin{i}.type,types),"Unknown datatype "+varargin{i}.type + warning_ending);
end

%% Parse arguments
%{
N = length(labels); % Number of nodes
nodedata = struct();
edgedata = struct();
for i = 1:2:length(varargin)
    if isequal(size(varargin{i+1}),[N 1])
        nodedata.(varargin{i}) = varargin{i+1};
    elseif isequal(size(varargin{i+1}),[N N])
        edgedata.(varargin{i}) = varargin{i+1};
    end
end
node_att = fieldnames(nodedata);
edge_att = fieldnames(edgedata);
%}

%% Create XML document object
disp('Creating document...');
xmlDoc = com.mathworks.xml.XMLUtils.createDocument('gexf');
gexf = xmlDoc.getDocumentElement;
gexf.setAttribute('version','1.3'); % Not entirely sure about this

%% Create graph element
graph = xmlDoc.createElement('graph');
graph.setAttribute('mode','static'); % Network is not time dependent
if directed
    graph.setAttribute('defaultedgetype','directed');
else
    mi = max(mi,mi');
    mi = tril(mi);
    graph.setAttribute('defaultedgetype','undirected');
end

% Create node attribute elements
if ~isempty(node_props)
    atts = xmlDoc.createElement('attributes');
    atts.setAttribute('class','node');
    for i = 1:length(node_props)
        att = xmlDoc.createElement('attribute');
        att.setAttribute('id',num2str(i-1));
        att.setAttribute('title',node_props(i).name);
        att.setAttribute('type',node_props(i).type);
        atts.appendChild(att);
    end
    graph.appendChild(atts);
end

% Create edge attribute elements
if ~isempty(edge_props)
    atts = xmlDoc.createElement('attributes');
    atts.setAttribute('class','edge');
    for i = 1:length(edge_props)
        att = xmlDoc.createElement('attribute');
        att.setAttribute('id',num2str(i-1));
        att.setAttribute('title',edge_props(i).name);
        att.setAttribute('type',edge_props(i).type);
        atts.appendChild(att);
    end
    graph.appendChild(atts);
end
nodes = xmlDoc.createElement('nodes');
edges = xmlDoc.createElement('edges');
gexf.appendChild(graph);
graph.appendChild(nodes);
graph.appendChild(edges);

%% Add node data to graph element
disp('Writing node data to document...');
for i = 1:N
    node = xmlDoc.createElement('node');
    node.setAttribute('id',num2str(i-1));
    node.setAttribute('label',labels{i});
    if ~isempty(node_props)
        avs = xmlDoc.createElement('attvalues');
        for j = 1:length(node_props)
            av = xmlDoc.createElement('attvalue');
            av.setAttribute('for',num2str(j-1));
            if iscell(node_props(j).data(i))
                av.setAttribute('value',node_props(j).data{i});
            else
                av.setAttribute('value',num2str(node_props(j).data(i))); % num2str necessary?
            end
            avs.appendChild(av);
        end
        node.appendChild(avs);
    end
    nodes.appendChild(node);
end

%% Add edge data to graph element
disp('Writing edge data to document...');
l = 0;
for i = 1:N
    for j = 1:N
        if mi(i,j)==0
            continue;
        end
        edge = xmlDoc.createElement('edge');
        edge.setAttribute('id',num2str(l));
        edge.setAttribute('source',num2str(i-1));
        edge.setAttribute('target',num2str(j-1));
        edge.setAttribute('weight',num2str(mi(i,j)));
        if ~isempty(edge_props)
            avs = xmlDoc.createElement('attvalues');
            for k = 1:length(edge_props)
                av = xmlDoc.createElement('attvalue');
                av.setAttribute('for',num2str(k-1));
                if iscell(edge_props(k).data(i,j)) 
                    av.setAttribute('value',edge_props(k).data{i,j});
                else
                    av.setAttribute('value',num2str(edge_props(k).data(i,j)));
                end
                avs.appendChild(av);
            end
            edge.appendChild(avs);
        end
        edges.appendChild(edge);
        l = l+1;
    end
end

if length(filename) < 5
    filename = [filename '.gexf'];
elseif ~strcmp(filename(end-4:end),'.gexf')
    filename = [filename '.gexf'];
end

xmlwrite(filename,xmlDoc);
function export_network(filename,labels,mi,directed,varargin)
%% Export network data to a file in GEXF format.
% Export a network to a GEXF (XML-like) file that can be loaded by network
% visualization software, Gephi in particular.
% 
% export_network(filename,labels,mi,directed,...)
% 
% Input:
% filename: (required) name of output file.
% labels:   (required) N by 1 cell array with node labels.
% mi:       (required) MI/network matrix (N by N).
% directed: (required) true/false whether edge directionality should be
%           considered.

% Optionally, Name-Value argument pairs can be added to include data
% describing nodes or edges, like labels, in the file. This data can be
% used by the network software to e.g. filter the network. Node data should
% be passed as N by 1 array and edge data as N by N matrix.

% Limitation: node data can not be named 'id' or 'label' and edge data can
% not be named 'id', 'source', 'target' or 'weight'.
% 
% Example (where Nodecolor, Edgecolor and Edgetype are optional data):
% exportNetwork('nw.gexf',labels,[N*N array],false,'Nodecolor',[N*1 array], ...
%               'Edgecolor',[N*N array],'Edgetype',[N*N array])

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
if ~isempty(node_att)
    atts = xmlDoc.createElement('attributes');
    atts.setAttribute('class','node');
    for i = 1:length(node_att)
        att = xmlDoc.createElement('attribute');
        att.setAttribute('id',num2str(i-1));
        att.setAttribute('title',node_att{i});
        att.setAttribute('type','string');
        atts.appendChild(att);
    end
    graph.appendChild(atts);
end

% Create edge attribute elements
if ~isempty(edge_att)
    atts = xmlDoc.createElement('attributes');
    atts.setAttribute('class','edge');
    for i = 1:length(edge_att)
        att = xmlDoc.createElement('attribute');
        att.setAttribute('id',num2str(i-1));
        att.setAttribute('title',edge_att{i});
        att.setAttribute('type','string');
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
for i = 1:n
    node = xmlDoc.createElement('node');
    node.setAttribute('id',num2str(i-1));
    node.setAttribute('label',labels{i});
    if ~isempty(node_att)
        avs = xmlDoc.createElement('attvalues');
        for j = 1:length(node_att)
            av = xmlDoc.createElement('attvalue');
            av.setAttribute('for',num2str(j-1));
            if iscell(nodedata.(node_att{j})(i))
                av.setAttribute('value',nodedata.(node_att{j}){i});
            else
                av.setAttribute('value',num2str(nodedata.(node_att{j})(i)));
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
for i = 1:n
    for j = 1:n
        if mi(i,j)==0
            continue;
        end
        edge = xmlDoc.createElement('edge');
        edge.setAttribute('id',num2str(l));
        edge.setAttribute('source',num2str(i-1));
        edge.setAttribute('target',num2str(j-1));
        edge.setAttribute('weight',num2str(mi(i,j)));
        if ~isempty(edge_att)
            avs = xmlDoc.createElement('attvalues');
            for k = 1:length(edge_att)
                av = xmlDoc.createElement('attvalue');
                av.setAttribute('for',num2str(k-1));
                if iscell(edgedata.(edge_att{k})(i,j))
                    av.setAttribute('value',edgedata.(edge_att{k}){i,j});
                else
                    av.setAttribute('value',num2str(edgedata.(edge_att{k})(i,j)));
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
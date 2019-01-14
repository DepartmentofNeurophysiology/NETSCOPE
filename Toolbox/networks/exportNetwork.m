function exportNetwork(genes,conn,data,name,directed)
%% Export network data as GEXF-format file (XML)
% 
% genes: node labels, N by 1 cell array
% conn: N by N connectivity matrix (0-edges are excluded)
% data: node data. Struct with for each field a cell array of length N
% name: output filename
% directed: true/false whether edge directionality should be considered

%% Create xml document object
disp('Creating document...');
xmlDoc = com.mathworks.xml.XMLUtils.createDocument('gexf');
gexf = xmlDoc.getDocumentElement;

attribute = fieldnames(data);
n = length(genes); % Number of nodes
m = length(attribute); % Number of attributes

%% Create standard Gephi file format
gexf.setAttribute('version','1.3'); % Not sure what it should be
% Optional: add description
%meta = xmlDoc.createElement('meta');
%descr = xmlDoc.createElement('description');
%dstr = xmlDoc.createTextNode(description);
%meta.appendChild(descr);
%descr.appendChild(dstr);
%gexf.appendChild(meta);
% Graph format
graph = xmlDoc.createElement('graph');
graph.setAttribute('mode','static'); % Network is time-independent
if directed==1
    graph.setAttribute('defaultedgetype','directed'); % Network is directed
else
    conn = max(conn,conn');
    conn = tril(conn);
    graph.setAttribute('defaultedgetype','undirected');
end
if m>0
    attributes = xmlDoc.createElement('attributes');
    attributes.setAttribute('class','node');
    for i = 1:m
        att = xmlDoc.createElement('attribute');
        att.setAttribute('id',num2str(i-1));
        att.setAttribute('title',attribute{i});
        att.setAttribute('type','string');
        attributes.appendChild(att);
    end
    graph.appendChild(attributes);
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
    node.setAttribute('label',genes{i});
    if m>0
        avs = xmlDoc.createElement('attvalues');
        for j = 1:m
            av = xmlDoc.createElement('attvalue');
            av.setAttribute('for',num2str(j-1));
            if iscell(data.(attribute{j})(i))
                av.setAttribute('value',data.(attribute{j}){i});
            else
                av.setAttribute('value',num2str(data.(attribute{j})(i)));
            end
            avs.appendChild(av);
        end
        node.appendChild(avs);
    end
    nodes.appendChild(node);
end

%% Add edge data to graph element
disp('Writing edge data to document...');
k = 0;
for i = 1:n
    for j = 1:n
        if conn(i,j)==0
            continue;
        end
        edge = xmlDoc.createElement('edge');
        edge.setAttribute('id',num2str(k));
        edge.setAttribute('source',num2str(i-1));
        edge.setAttribute('target',num2str(j-1));
        edge.setAttribute('weight',num2str(conn(i,j)));
        edges.appendChild(edge);
        k = k+1;
    end
end

if ~strcmp(name(end-4:end),'.gexf')
    name = [name '.gexf'];
end
xmlwrite(name,xmlDoc);
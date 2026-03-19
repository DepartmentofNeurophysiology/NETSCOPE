## Introduction
NETSCOPE is a MATLAB/Octave/Python toolbox for information theoretical analysis of molecular networks. It can be used for network construction and analysis from a wide variety of biological data. Applications range from constructing gene co-expression networks and using topological patterns to identify genes or pathways of interest, to identifying functional links in fMRI- and EEG-based networks. The toolbox is plug-and-play, just download the code and start importing your data.

## Download and Setup
Download repository with:
```shell
git clone https://github.com/DepartmentofNeurophysiology/NETSCOPE.git
```

In MATLAB/Octave: to add the toolbox files to the search path and enable all functionality, navigate to the NETSCOPE directory and run the `startup` command.

## Documentation
![Workflow](https://github.com/DepartmentofNeurophysiology/NETSCOPE/blob/master/Documentation/workflow.png)


Type `help <function>` to see detailed information about a function.

## Supporting data
### Network construction from synthetic data (Figure 3 code)
[synthetic_data.m](synthetic_data.m) contains everything necessary to recreate Figure 3 from the manuscript. The code generates synthetic expression data from a ground truth network, constructs an MI-based network and compares it to the ground truth network. The results are shown as figures.

### Network construction from yeast expression data (Figure 5-7 data)
[yeast_data.mat](yeast_data.mat) contains the gene expression data from Ziemann et al., and the co-expression network data from YeastNet v3. See Table 1 from the manuscript for more details on the network data.

## Manuscript
Bergmans T, Jamal T, Rezeika A, Hsing C, Celikel T. 2026. “NETSCOPE: Information-Theory Based Network Discovery and Analysis” *(in submission)*

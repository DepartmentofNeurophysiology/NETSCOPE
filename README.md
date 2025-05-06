## Introduction
NETSCOPE is a MATLAB/Octave toolbox for information theoretical analysis of molecular networks. It can be used for network construction and analysis from a wide variety of biological data. Applications range from constructing gene co-expression networks and using topological patterns to identify genes or pathways of interest, to identifying functional links in fMRI- and EEG-based networks. The toolbox is plug-and-play, download the code and start importing your data. For more information, see the accompanying article (Bergmans, Jamal and Celikel 2025).

## Download and Setup
Download repository with:
```shell
git clone https://github.com/DepartmentofNeurophysiology/NETSCOPE.git
```

To add the toolbox files to the search path and enable all functionality, navigate in MATLAB/Octave to the NETSCOPE directory and run the `startup` command.

## Documentation
![Workflow](https://github.com/DepartmentofNeurophysiology/NETSCOPE/blob/master/Documentation/workflow.png)


Type `help <function>` to see detailed information about a function.

## Supporting data
### Network construction from synthetic data (Figure 3 code)
[synthetic_data.m](synthetic_data.m) contains everything necessary to recreate Figure 3 from the article. The code generates synthetic expression data from a ground truth network, constructs an MI-based network and compares it to the ground truth network. The results are shown as figures.

### Network construction from yeast expression data (Figure 5-7 data)
[yeast_data.mat](yeast_data.mat) contains the gene expression data from Ziemann et al., and the co-expression network data from YeastNet v3. See Table 1 from the article for more details on the network data.

## References
Bergmans, Jamal and Celikel. 2025. “NETSCOPE: Information-Theory Based Network Discovery and Analysis” *(in preparation)*

Kim, Hanhae, Junha Shin, Eiru Kim, Hyojin Kim, Sohyun Hwang, Jung Eun Shim, and Insuk Lee. 2014. “YeastNet v3: A Public Database of Data-Specific and Integrated Functional Gene Networks for Saccharomyces Cerevisiae.” Nucleic Acids Research 42 (D1): D731–36. https://doi.org/10.1093/nar/gkt981.

Ziemann, Mark, Antony Kaspi, and Assam El-Osta. 2019. “Digital Expression Explorer 2: A Repository of Uniformly Processed RNA Sequencing Data.” GigaScience 8 (giz022). https://doi.org/10.1093/gigascience/giz022.

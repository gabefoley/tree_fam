# Lots of Trees

<p align="center">
	<img src="docs/images/logo.png" alt="ASR Curation" width="400" />

</p>
 
Snakemake pipeline for making ancestors from data taken from Tree Fam


# Install instructions 


1. Clone this repository to your desktop

```
git clone https://github.com/gabefoley/lotsoftrees.git
```

2. Create a conda environment

```
conda create -n lots_of_trees python=3.10
```

3. Activate the conda environment

```
conda activate asr_curation
```

4. Install the required Python packages

```
pip install -r requirements.txt
```


5. Install the following so that they are callable from the command line
- [GRASP](https://bodenlab.github.io/GRASP-suite/project/graspcmd/) - callable as `grasp`


# Quickstart

By default, the pipeline will process every pair of alignment (.aln.emf) and tree (.phyloxml.xml) files it finds in the data folder - default `./data` by

1. Converting the Clustal and PhyloXML files into FASTA alignment and Newick format files
2. Running GRASP to make ancestors 

Output is written by default to `./output` 

```
snakemake --cores 1
```

You can also provide optional arguments

`data_folder` - changes where to look for the data folder (default is ./data)
`output_folder` - changes where to save the output (default is ./output)
`names` - path to a .txt file that contains a list of Tree Fam IDs that causes the pipeline to only process those contained in this list

If you don't provide `data_folder` or `output_folder` it will use the default values. If you don't provide `names` it will process all of the files it finds in `data_folder`




import glob
import os

try:
    DATA_FOLDER = config['data_folder']
except:
    DATA_FOLDER = "./data"

try:
    OUTPUT_FOLDER = config['output_folder']
except:
    OUTPUT_FOLDER = "./output"

try:
    NAMES = config['names']
except:
    NAMES = None


print (DATA_FOLDER)

if NAMES:
    DATASETS = expand(os.path.basename(x).split('.')[0] for x in glob.glob(DATA_FOLDER + "/*.fasta") if x in NAMES)
else:
    DATASETS = expand(os.path.basename(x).split('.')[0] for x in glob.glob(DATA_FOLDER + "/*.fasta"))


print (DATASETS)

rule all:
        input:
            # notebooks = [f'{OUTPUT_FOLDER}/{dataset}/subsets/{subset}/{cluster_thresh}/csv/{dataset}_{subset}_{cluster_thresh}_annotations.txt' for cluster_thresh in cluster_threshes for dataset in DATASETS for subset in subsets[dataset]],
            # trees = [f'{WORKDIR}/{dataset}/subsets/{subset}/{cluster_thresh}/{dataset}_{subset}_{cluster_thresh}.nwk' for cluster_thresh in cluster_threshes for dataset in DATASETS for subset in subsets[dataset]],
            # ancestors = [f'{WORKDIR}/{dataset}/subsets/{subset}/{cluster_thresh}/csv/{dataset}_{subset}_{cluster_thresh}_ancestors.csv' for cluster_thresh in cluster_threshes for dataset in DATASETS for subset in subsets[dataset]],
            # extants_and_ancestors = [f'{WORKDIR}/{dataset}/subsets/{subset}/{cluster_thresh}/concatenated_seqs/{dataset}_{subset}_{cluster_thresh}_ancestors.aln' for cluster_thresh in cluster_threshes for dataset in DATASETS for subset in subsets[dataset]]
            ancestors = [f"{OUTPUT_FOLDER}/{dataset}/{dataset}/GRASP_ancestors/GRASP_ancestors.fa" for dataset in DATASETS]

# Create the initial annotation file from the FASTA file or list of IDs
rule convert_alignment:
    input:
        DATA_FOLDER + "/{dataset}.aln.emf"
    output:
        OUTPUT_FOLDER + "/{dataset}/{dataset}.aln"
    shell:
        "bioconvert clustal2fasta {input} {output}"

# Create the initial annotation file from the FASTA file or list of IDs
rule convert_tree:
    input:
        DATA_FOLDER + "/{dataset}.phyloxml.xml"
    output:
        OUTPUT_FOLDER + "/{dataset}/{dataset}.nwk"
    shell:
        "bioconvert phyloxml2newick {input} {output}"

# Create the initial annotation file from the FASTA file or list of IDs
rule infer_ancestors:
    input:
        aln =  OUTPUT_FOLDER + "/{dataset}/{dataset}.aln",
        tree = OUTPUT_FOLDER + "/{dataset}/{dataset}.nwk"

    output:
        dir= directory(OUTPUT_FOLDER + "/{dataset}/GRASP_ancestors/"),
        aln= OUTPUT_FOLDER + "/{dataset}/{dataset}/GRASP_ancestors/GRASP_ancestors.fa",
        tree = OUTPUT_FOLDER + "/{dataset}/{dataset}/GRASP_ancestors/GRASP_ancestors.nwk"

    shell:
        "grasp -a {input.aln} -n {input.tree} -s LG -o {output.dir} -i BEP -j --save-as FASTA TREE -pre GRASP -t 2"


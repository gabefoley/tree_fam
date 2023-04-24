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
            ancestors = [f"{OUTPUT_FOLDER}/{dataset}/{dataset}/GRASP_ancestors/GRASP_ancestors.fa" for dataset in DATASETS],
            alignments = [f"{OUTPUT_FOLDER}/{dataset}/{dataset}.aa.fasta" for dataset in DATASETS],
            trees = [f"{OUTPUT_FOLDER}/{dataset}/{dataset}.nwk" for dataset in DATASETS]
# Create the initial annotation file from the FASTA file or list of IDs
rule copy_alignment:
    input:
        DATA_FOLDER + "/{dataset}.aa.fasta"
    output:
        OUTPUT_FOLDER + "/{dataset}/{dataset}.aa.fasta"
    shell:
        "cp {input} {output}"

# Create the initial annotation file from the FASTA file or list of IDs
rule extract_newick:
    input:
        DATA_FOLDER + "/{dataset}.nh.emf"
    output:
        OUTPUT_FOLDER + "/{dataset}/{dataset}.nwk"
    script:
        "scripts/extract_newick.py"

# Create the initial annotation file from the FASTA file or list of IDs
rule infer_ancestors:
    input:
        aln =  OUTPUT_FOLDER + "/{dataset}/{dataset}.aa.fasta",
        tree = OUTPUT_FOLDER + "/{dataset}/{dataset}.nwk"

    output:
        dir= directory(OUTPUT_FOLDER + "/{dataset}/GRASP_ancestors/"),
        aln= OUTPUT_FOLDER + "/{dataset}/{dataset}/GRASP_ancestors/GRASP_ancestors.fa",
        tree = OUTPUT_FOLDER + "/{dataset}/{dataset}/GRASP_ancestors/GRASP_ancestors.nwk"

    shell:
        "grasp -a {input.aln} -n {input.tree} -s LG -o {output.dir} -i BEP -j --save-as FASTA TREE -pre GRASP -t 2"


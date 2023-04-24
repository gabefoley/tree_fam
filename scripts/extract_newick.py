with open(snakemake.input[0]) as infile, open(snakemake.output[0], 'w') as outfile:
    copy = False
    for line in infile:
        if line.strip() == "DATA":
            copy = True
            continue
        elif line.strip() == "//":
            copy = False
            continue
        elif copy:
            outfile.write(line)
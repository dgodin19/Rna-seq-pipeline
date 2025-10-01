#!/usr/bin/env python

import argparse
parser = argparse.ArgumentParser(description='This script parses a GTF file and outputs a tab delimited file with the gene id and gene name.')
parser.add_argument('-i', dest='input', help='Input should be a GTF file', required=True)
parser.add_argument('-o', dest='gtf_parse_output', help='Name of output file containing the tab delimited file of gene ids and the corresponding gene name.', required=True)
args = parser.parse_args()

id_gene = {}
duplicates = {}

with open(args.input, 'r') as f:
    for line in f:
        if line.startswith("#"):
            continue
        fields = line.strip().split("\t")
        attributes = fields[8]

        gene_id = None
        gene_name = None

        for attr in attributes.split(";"):
            attr = attr.strip()
            if attr.startswith("gene_id"):
                gene_id = attr.split('"')[1]
            elif attr.startswith("gene_name"):
                gene_name = attr.split('"')[1]

        if gene_id and gene_name:
            if gene_id in id_gene and id_gene[gene_id] != gene_name:
                # record a duplicate with different names
                duplicates.setdefault(gene_id, set()).update([id_gene[gene_id], gene_name])
            else:
                id_gene[gene_id] = gene_name

# print(f"Total unique IDs: {len(id_gene)}")
# print(f"Duplicate IDs: {len(duplicates)}")

with open(args.gtf_parse_output, 'w') as t:
	header = 'gene_id'+ '\t' + 'gene_name' +'\n'
	t.write(header)
	for gene_id in id_gene:
		row = gene_id + '\t' + id_gene[gene_id] + '\n'
		t.write(row)


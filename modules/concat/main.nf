#!/usr/bin/bash nextflow

process CONCAT {
    container 'ghcr.io/bf528/pandas:latest'
    publishDir params.outdir, mode: "copy"
    label 'process_low'

    input:
    path exon_files

    output:
    path 'counts_matrix.csv'

    script:
    """
    concat.py -i . -o counts_matrix.csv
    """

    stub:
    """
    touch 'counts_matrix.csv'
    """
}

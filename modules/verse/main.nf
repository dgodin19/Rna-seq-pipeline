#!/usr/bin/bash nextflow

process VERSE {
    container 'ghcr.io/bf528/verse:latest'
    publishDir params.outdir, mode: "copy"
    label 'process_medium'

    input:
    tuple val(sample), path(gtf), path(bam)

    output:
    path("${sample}.exon.txt")

    script:
    """
    verse -a $gtf -o ${sample} $bam -t exon -S
    """

    stub:
    """
    touch ${sample}.exon.txt
    """
}

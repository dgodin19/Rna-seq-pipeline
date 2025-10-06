#!/usr/bin/bash nextflow

process STAR_ALIGN {
    container 'ghcr.io/bf528/star:latest'
	publishDir params.outdir, mode: "copy"
	label 'process_high'

	input:
    path(index_dir)
    tuple val (sample), path(reads)
    /*tuple path(index_dir), val(sample), path(R1),path(R2)*/

	output:
	tuple val(sample), path("*.bam"), emit: bam
    tuple val(sample), path("*.log.final.out"), emit: log

	script:
	"""
     STAR \
        --runThreadN $task.cpus \
        --genomeDir ${index_dir} \
        --readFilesIn ${reads.join(' ')} \
        --readFilesCommand zcat \
        --outFileNamePrefix ${sample}_ \
        --outSAMtype BAM SortedByCoordinate \
        2> ${sample}.log.final.out

	"""

    stub:
    """
    touch ${sample}.bam
    touch ${sample}.log.final.out
    """
}



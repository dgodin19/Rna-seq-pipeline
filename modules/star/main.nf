#!/usr/bin/bash nextflow

process STAR {
    container 'ghcr.io/bf528/star:latest'
	publishDir params.outdir, mode: "copy"
	label 'process_high'

	input:
    tuple path(reference), path(gtf)
    
	output:
	path 'STAR_index/'

	script:
	"""
	mkdir -p STAR_index
    STAR --runThreadN $task.cpus \
         --runMode genomeGenerate \
         --genomeDir STAR_index \
         --genomeFastaFiles $reference \
         --sjdbGTFfile $gtf

	"""
}



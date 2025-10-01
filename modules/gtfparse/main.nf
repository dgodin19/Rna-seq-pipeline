#!/usr/bin/bash nextflow

process GTF_PARSE {
	publishDir params.outdir, mode: "copy"
	label 'process_low'

	input:
	path(gtf)

	output:
	file('gtf_parse_output.txt')

	script:
	"""
	gtf_parse.py -i $gtf -o gtf_parse_output.txt
	"""
}


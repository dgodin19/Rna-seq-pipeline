#!/usr/bin/env nextflow
include {FASTQC} from './modules/fastqc'
include {GTF_PARSE} from './modules/gtfparse'
include {STAR} from './modules/star'
include {STAR_ALIGN} from './modules/star_align'

workflow {
    Channel.fromFilePairs(params.reads)
    | set { align_ch }

    /*align_ch.view()*/

    Channel.fromFilePairs(params.reads)
    | flatMap { sample_id, reads ->
        reads.collect { read -> tuple(sample_id, read) }
    }
    | set { fastqc_channel }

    fastqc_channel.view()

    FASTQC(fastqc_channel)

    GTF_PARSE(params.gtf)

    STAR(tuple(file(params.genome), file(params.gtf)))
    STAR_ALIGN(STAR.out.index_dir, align_ch)

        
}
#!/usr/bin/env nextflow
include {FASTQC} from './modules/fastqc'
include {GTF_PARSE} from './modules/gtfparse'
include {STAR} from './modules/star'

workflow {
    /*Channel.fromFilePairs(params.reads)
    | set { align_ch }

    align_ch.view()

    Channel.fromFilePairs(params.reads)
    | flatMap { sample_id, reads ->
        reads.collect { read -> tuple(sample_id, read) }
    }
    | set { fastqc_channel }

    fastqc_channel.view()

    FASTQC(fastqc_channel)

    GTF_PARSE(params.gtf)*/

    Channel.of([params.genome, params.gtf])
    | set {star_index_ch}

    STAR(star_index_ch)
}

#!/usr/bin/env nextflow
include {FASTQC} from './modules/fastqc'

workflow {
    Channel.fromFilePairs(params.reads)
    | set { align_ch }

    align_ch.view()

    Channel.fromFilePairs(params.reads)
    | flatMap { sample_id, reads ->
        reads.collect { read -> tuple(sample_id, read) }
    }
    | set { fastqc_channel }

    fastqc_channel.view()

    FASTQC(fastqc_channel)
}

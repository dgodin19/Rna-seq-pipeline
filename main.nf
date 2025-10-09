#!/usr/bin/env nextflow
include {FASTQC} from './modules/fastqc'
include {GTF_PARSE} from './modules/gtfparse'
include {STAR} from './modules/star'
include {STAR_ALIGN} from './modules/star_align'
include {MULTIQC} from './modules/multiqc'
include {VERSE} from './modules/verse'
include {CONCAT} from './modules/concat'

workflow {
    Channel.fromFilePairs(params.reads)
    | set { align_ch }

    Channel.fromFilePairs(params.reads)
    | flatMap { sample_id, reads ->
        reads.collect { read -> tuple(sample_id, read) }
    }
    | set { fastqc_channel }

    FASTQC(fastqc_channel)

    /*GTF_PARSE(params.gtf)*/



    STAR(tuple(file(params.genome), file(params.gtf)))
    STAR_ALIGN(STAR.out.index_dir, align_ch)

    fastqc_out = FASTQC.out.zip.map { it[1] }
    star_log_out = STAR_ALIGN.out.log.map { it[1] }

    multiqc_ch = fastqc_out.mix(star_log_out)
                         .flatten()
                         .distinct() 
                         .collect()
    multiqc_ch.view()


    MULTIQC(multiqc_ch) 
    bam_with_gtf = STAR_ALIGN.out.bam.map { sample, bam ->
    tuple(sample, file(params.gtf), bam)
    }
    VERSE(bam_with_gtf)

    CONCAT(VERSE.out.collect())     
        
}
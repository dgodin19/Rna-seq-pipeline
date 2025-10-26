# TYK2 RNA-Seq Analysis Pipeline

This Nextflow pipeline analyzes RNA sequencing data to investigate TYK2 expression in Type 1 Diabetes. The workflow automates quality control, genome indexing, alignment, quantification, and post-processing, using a combination of standard bioinformatics tools and custom Python modules. . This project aimed to reproduce findings from Figure 3 in [Chandra et al., 2022](https://www.nature.com/articles/s41467-022-34069-z).
# Modules Used
The following modules, located in the modules folder, are integrated into the pipeline:

    FASTQC: Performs quality control on raw sequencing reads.
    GTF_PARSE: Custom Python script for parsing and preprocessing GTF annotation files.
    STAR: Indexes the reference genome and annotation files for alignment.
    STAR_ALIGN: Aligns RNA-seq reads to the indexed reference genome.
    MULTIQC: Aggregates QC metrics and alignment statistics into unified multi-sample reports.
    VERSE: Performs quantification of gene expression from BAM files and GTF annotations.
    CONCAT: Custom Python script to aggregate quantification results across samples.

# File Structure

    main.nf: The primary Nextflow pipeline script.
    modules/: Contains all module scripts and custom processes.
 

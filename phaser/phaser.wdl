#   WDL workflow for phASER

task phaser {
    #   Inputs
    File bam
    File bai
    File vcf
    File tbi
    Boolean paired
    Int mapq
    Int baseq
    File blacklist
    File haplo_blacklist
    String sample
    Boolean pass_only
    String out_prefix
    #   Documentation for parameters
    parameter_meta {
        bam: "RNA-seq BAM file to run phASER on"
        bai: "BAI index for `bam`"
        vcf: "VCF file with WGS data for `bam`"
        tbi: "Tabix-generated index for `vcf`"
        paired: "Is `bam` generated from paired-end data?"
        mapq: "Minimum mapping quality"
        baseq: "Minimum base quality"
        blacklist: "BED file with blacklisted genes"
        haplo_blacklist: "BED file with regions blacklisted from the haplotypic counts"
        sample: "Sample name as present in `vcf`"
        pass_only: "Limit `vcf` to variantes that have passed quality filters"
        out_prefix: "Prefix for names of output files"
    }
    #   Run phASER
    command {
        phaser.py \
            --vcf ${vcf} \
            --bam ${bam} \
            --paired_end ${true='1' false='0' paired} \
            --mapq ${mapq} \
            --baseq ${baseq} \
            --sample ${sample} \
            --blacklist ${blacklist} \
            --haplo_count_blacklist ${haplo_blacklist} \
            --pass_only ${true='1' false='0' pass_only} \
            --o ${out_prefix}
    }
    #   Outputs
    output {
        File config = "${out_prefix}.allele_config.txt"
        File counts = "${out_prefix}.allelic_counts.txt"
        File haplotypes = "${out_prefix}.haplotypes.txt"
        File haplo_counts = "${out_prefix}.haplotypic_counts.txt"
        File connections = "${out_prefix}.variant_connections.txt"
        File phased = "${out_prefix}.vcf.gz"
        File index = "${out_prefix}.vcf.gz.tbi"
    }
    #   Runtime environment
    runtime {
        docker: "ghcr.io/lappalainenlab/phaser:latest"
        memory: "10 G"
    }
}

task phaser_gene_ae {
    #   Inputs
    File counts
    File bed
    String out_prefix
    #   Generate default values
    String outname = "${out_prefix}_gene_ae.txt"
    #   Documentation for parameters
    parameter_meta {
        counts: "The haplotypic counts generated from `phaser.py`"
        bed: "BED file with features to produce counts for"
        out_prefix: "Prefix for names of output files"
    }
    #   Run phASER gene ae
    command {
        phaser_gene_ae.py --haplotypic_counts ${counts} --features ${bed} --o ${outname}
    }
    #   Outputs
    output {
        File out = "${outname}"
    }
    #   Runtime environment
    runtime {
        docker: "ghcr.io/lappalainenlab/phaser:latest"
        memory: "10 G"
    }
}

workflow run_phaser {
    #   Inputs
    File bam
    File bai
    File vcf
    File tbi
    File blacklist
    File haplo_blacklist
    File features
    Boolean paired = true
    Int mapq = 255
    Int baseq = 10
    String sample = ""
    Boolean pass_only = false
    #   Generate default values
    String out_prefix = basename(bam, ".bam")
    String sample_name = if (sample == "") then out_prefix else sample
    #   Documentation for parameters
    parameter_meta {
        bam: "RNA-seq BAM file to run phASER on"
        bai: "BAI index for `bam`"
        vcf: "VCF file with WGS data for `bam`"
        tbi: "Tabix-generated index for `vcf`"
        blacklist: "BED file with blacklisted genes"
        haplo_blacklist: "BED file with regions blacklisted from the haplotypic counts"
        features: "BED file with features to produce counts for"
        paired: "Is `bam` generated from paired-end data?; defaults to true"
        mapq: "Minimum mapping quality; defaults to 255"
        baseq: "Minimum base quality; defaults to 10"
        sample: "Sample name as present in `vcf`; defaults to the basename of `bam`"
        pass_only: "Limit `vcf` to variantes that have passed quality filters; defaults to false"
    }
    #   Run tasks
    call phaser {
        input:
            bam = bam,
            bai = bai,
            vcf = vcf,
            tbi = tbi,
            paired = paired,
            mapq = mapq,
            baseq = baseq,
            blacklist = blacklist,
            haplo_blacklist = haplo_blacklist,
            sample = sample_name,
            pass_only = pass_only,
            out_prefix = out_prefix
    }
    call phaser_gene_ae {
        input:
            counts = phaser.haplo_counts,
            bed = features,
            out_prefix = out_prefix
    }
    #   Outputs
    output {
        File config = phaser.config
        File counts = phaser.counts
        File haplotypes = phaser.haplotypes
        File haplo_counts = phaser.haplo_counts
        File connections = phaser.connections
        File phased = phaser.phased
        File index = phaser.index
        File annotated = phaser_gene_ae.out
    }
}

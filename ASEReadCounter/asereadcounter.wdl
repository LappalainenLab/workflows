# WDL workflow for ASEReadCounter

task asereadcounter {
    #   Inputs
    File bam
    File bai
    File vcf
    File tbi
    File reference
    File fai
    File fdict
    Int depth
    Int mapq
    Int baseq
    String out_prefix
    #   Generate default values
    String outname = "${out_prefix}.txt"
    #   Documentation for parameters
    parameter_meta {
        bam: "RNA-seq BAM file to run phASER on"
        bai: "BAI index for `bam`"
        vcf: "VCF file with WGS data for `bam`"
        tbi: "Tabix-generated index for `vcf`"
        reference: "FASTA reference genome"
        fai: "SAMtools FASTA index for `reference`"
        fdict: "GATK/Picard sequence dictionary for `reference`"
        depth: "Minimum depth"
        mapq: "Minimum mapping quality"
        baseq: "Minimum base quality"
        out_prefix: "Prefix for name of output file"
    }
    #   Run ASEReadCounter
    command {
        gatk ASEReadCounter \
            --reference ${reference} \
            --input ${bam} \
            --variant ${vcf} \
            --intervals ${vcf} \
            --output ${outname} \
            -min-depth ${depth} \
            --min-mapping-quality ${mapq} \
            --min-base-quality ${baseq}
    }
    #   Outputs
    output {
        File out = "${outname}"
    }
    #   Runtime environment
    runtime {
        docker: "broadinstitute/gatk:4.1.9.0"
    }
}

workflow run_ase {
    #   Inputs
    File bam
    File bai
    File vcf
    File tbi
    File reference
    File fai
    File fdict
    Int depth = 1
    Int mapq = 255
    Int baseq = 10
    #   Generate default values
    String out_prefix = basename(bam, ".bam")
    #   Documentation for parameters
    parameter_meta {
        bam: "RNA-seq BAM file to run phASER on"
        bai: "BAI index for `bam`"
        vcf: "VCF file with WGS data for `bam`"
        tbi: "Tabix-generated index for `vcf`"
        reference: "FASTA reference genome"
        fai: "SAMtools FASTA index for `reference`"
        fdict: "GATK/Picard sequence dictionary for `reference`"
        depth: "Minimum depth; defaults to 1"
        mapq: "Minimum mapping quality; defaults to 255"
        baseq: "Minimum base quality; defaults to 10"
    }
    #   Run tasks
    call asereadcounter {
        input:
            bam = bam,
            bai = bai,
            vcf = vcf,
            tbi = tbi,
            reference = reference,
            fai = fai,
            fdict = fdict,
            depth = depth,
            mapq = mapq,
            baseq = baseq,
            out_prefix = out_prefix
    }
    #   Outputs
    output {
        File ase = asereadcounter.out
    }
}

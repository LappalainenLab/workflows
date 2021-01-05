# ASE with GATK's ASEReadCounter

This workflow is for generating ASE data using the GATK's ASEReadCounter. It is compreised of one WDL task and one WDL workflow, all importable

### Workflow `run_ase`

[`asereadcounter`](#task-asereadcounter)

#### Inputs

 - File `bam`: an RNA-seq BAM file
 - File `bai`: the BAI index for `bam`
 - File `vcf`: a VCF file with corresponding WGS data for `bam`
 - File `tbi`: the tabix-generated index for `vcf`
 - File `reference`: reference genome in FASTA format
 - File `fai`: SAMtools-generated FASTA index for `reference`
 - File `fdict`: GATK/Picard-generated sequence dictionary for `reference`
 - Int `depth`: minimum depth; defaults to 1
 - Int `mapq`: minimum mapping quality; defaults to 255
 - Int `baseq`: minimum base quality; defaults to 10

#### Outputs

- File `ase`: table with ASE data

### Task `asereadcounter`

Run the GATK's ASEReadCounter on a sample. For more details about ASEReadCounter, please see the GATK's [documentation](https://gatk.broadinstitute.org/hc/en-us/articles/360051308051-ASEReadCounter)

#### Inputs

 - File `bam`: an RNA-seq BAM file
 - File `bai`: the BAI index for `bam`
 - File `vcf`: a VCF file with corresponding WGS data for `bam`
 - File `tbi`: the tabix-generated index for `vcf`
 - File `reference`: reference genome in FASTA format
 - File `fai`: SAMtools-generated FASTA index for `reference`
 - File `fdict`: GATK/Picard-generated sequence dictionary for `reference`
 - Int `depth`: minimum depth
 - Int `mapq`: minimum mapping quality
 - Int `baseq`: minimum base quality
 - String `out_prefix`: prefix for name of output file

#### Outputs

- File `out`: table with ASE data

#### Runtime

This task utilizes the offical [GATK Docker image](https://hub.docker.com/r/broadinstitute/gatk/) for GATK version 4.1.9.0

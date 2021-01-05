# ASE with phASER

This workflow is for generating ASE data using phASER. It is comprised of two WDL tasks and one WDL workflow, all importable

### Workflow `run_phaser`

Run tasks [`phaser`](#task-phaser) and [`phaser_gene_ae`](#task-phaser_gene_ae) on a sample

#### Inputs

 - File `bam`: an RNA-seq BAM file
 - File `bai`: the BAI index for `bam`
 - File `vcf`: a VCF file with corresponding WGS data for `bam`
 - File `tbi`: the tabix-generated index for `vcf`
 - File `blacklist`: BED file with blacklisted genes
 - File `haplo_blacklist`: BED file with regions blacklisted from the haplotypic counts
 - File `features`: BED file with features to produce counts for
 - Boolean `paired`: is the data paired-end or single-end; defaults to `true`
 - Int `mapq`: minimum mapping quality; defaults to 255
 - Int `baseq`: minimum base quality; defaults to 10
 - String `sample`: sample name as present in `vcf`; defaults to the basename of `bam`
 - Boolean `pass_only`: limit `vcf` to variantes that have passed quality filters; defaults to `false`

#### Outputs

 - File `config`: table with allele configuration for each variant
 - File `counts`: table with ref/alt counts for variants used in phasing
 - File `haplotypes`: table of phasing statisitcs of haplotypes
 - File `haplo_counts`: table with unique reads for each haplotype
 - File `connections`: table with variant connection statistics
 - File `phased`: input VCF file with phasing information
 - File `index`: the tabix-generated index for `phased`
 - File `out`: the annotated ASE table

### Task `phaser`

Run `phaser.py` on a sample. For more details about `phaser.py`, please see [their GitHub](https://github.com/secastel/phaser/tree/master/phaser)

#### Inputs

 - File `bam`: an RNA-seq BAM file
 - File `bai`: the BAI index for `bam`
 - File `vcf`: a VCF file with corresponding WGS data for `bam`
 - File `tbi`: the tabix-generated index for `vcf`
 - Boolean `paired`: is the data paired-end or single-end
 - Int `mapq`: minimum mapping quality
 - Int `baseq`: minimum base quality
 - File `blacklist`: BED file with blacklisted genes
 - File `haplo_blacklist`: BED file with regions blacklisted from the haplotypic counts
 - String `sample`: sample name as present in `vcf`
 - Boolean `pass_only`: limit `vcf` to variantes that have passed quality filters
 - String `out_prefix`: prefix for names of output files

#### Outputs

 - File `config`: table with allele configuration for each variant
 - File `counts`: table with ref/alt counts for variants used in phasing
 - File `haplotypes`: table of phasing statisitcs of haplotypes
 - File `haplo_counts`: table with unique reads for each haplotype
 - File `connections`: table with variant connection statistics
 - File `phased`: input VCF file with phasing information
 - File `index`: the tabix-generated index for `phased`

#### Runtime

This task utilizes a pre-built Docker image hosted on the [Lappalainen Lab GitHub Packages](https://github.com/orgs/LappalainenLab/packages/container/package/phaser) page. In compute environments, this task requires 10 GB of memory


### Task `phaser_gene_ae`

Run `phaser_gene_ae.py` on a sample. For more details about `phaser_gene_ae`, please see [their GitHub](https://github.com/secastel/phaser/tree/master/phaser_gene_ae)

#### Inputs

 - File `counts`: the haplotypic counts generated from `phaser.py`
 - File `bed`: BED file with features to produce counts for
 - String `out_prefix`: refix for names of output files

#### Outputs

 - File `out`: the annotated ASE table

#### Runtime

This task utilizes a pre-built Docker image hosted on the [Lappalainen Lab GitHub Packages](https://github.com/orgs/LappalainenLab/packages/container/package/phaser) page. In compute environments, this task requires 10 GB of memory

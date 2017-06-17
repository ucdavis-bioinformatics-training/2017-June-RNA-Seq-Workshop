Alignment to Read Counts
=========================

In this section we will align reads to the genome, view some alignments, and assign counts to genes. **Log into a compute node using srun first! Do not run on the head node!**

**1\.** First, let's make sure that your jobs from yesterday completed. Go back to your '01-Trimming' directory and first check all the "arrayJob\*.out" and "arrayJob\*.err" files:

    cd ~/rnaseq_example/01-Trimming
    cat arrayJob*.out

Look through the output and make sure you don't see any errors. Now do the same for the err files:

    cat arrayJob*.err

Also, check the output files. First check the number of forward and reverse output files (should be 24 each):

    ls *.sickle.R1.fastq | wc -l
    ls *.sickle.R2.fastq | wc -l

Check the sizes of the files as well. Make sure there are no zero or near-zero size files and also make sure that the size of the files are in the same ballpark as each other:

    ls -lh *.sickle.R1.fastq
    ls -lh *.sickle.R2.fastq

If, for some reason, your jobs did not finish or something else went wrong, please let one of us know and we can get you caught up.

---

**2\.** To align our data we will need the genome and annotation for Arabidopsis thaliana. There are many places to find them, but we are going to get them from the Ensembl Genomes FTP site. In a browser, go to here:

    ftp://ftp.ensemblgenomes.org/pub/plants/release-36/

Navigate through the directories to find a GTF (**NOT** GFF3) annotation file for Arabidopsis thaliana, as well as a complete genome. The genome file is "Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz" and the annotation file is "Arabidopsis_thaliana.TAIR10.36.gtf.gz". When you find those files, copy the location links and use wget to add them to your ref directory:

    cd ~/rnaseq_example/ref
    wget <link to genome>
    wget <link to annotation>

Finally, you will need to use gunzip to uncompress the files:

    gunzip Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz
    gunzip Arabidopsis_thaliana.TAIR10.36.gtf.gz

Take a look at the GTF file:

    less Arabidopsis_thaliana.TAIR10.36.gtf

Press 'q' to exit this screen.

---

**2\.** Now, let's make an alignment directory and link all of our sickle paired-end files (we are not going to use the singletons) into the directory:

    cd ~/rnaseq_example
    mkdir 03-alignment
    cd 03-alignment
    ln -s ../01-Trimming/*sickle.R*.fastq .

We are going to use an aligner called 'STAR' to align the data, but in order to use star we need to index the genome for star. So go back to your ref directory and let's do the indexing (**Note that the STAR command below has been put on multiple lines for readability**). We specify 4 threads, the output directory, the fasta file for the genome, the annotation file (GTF), and the overhang parameter, which is calculated by subtracting 1 from the read length.

    cd ../ref
    module load star
    mkdir star_index
    
    STAR --runThreadN 4 \
    --runMode genomeGenerate \
    --genomeDir star_index \
    --genomeFastaFiles Arabidopsis_thaliana.TAIR10.dna.toplevel.fa \
    --sjdbGTFfile Arabidopsis_thaliana.TAIR10.36.gtf \
    --sjdbOverhang 99

This step will take 5 minutes. You can look at the [STAR documentation](https://github.com/alexdobin/STAR/blob/master/doc/STARmanual.pdf) while you wait. All of the output files will be written to the star_index directory. 

---

**3\.** We are now ready to try an alignment of one of our samples' reads. Let's go back to our 03-alignment directory.

    cd ../03-alignment

and let's run STAR on just one pair of files. Make sure you run this on a compute node using 8Gb of memory. It will take about 30 minutes to run (**Again, the command is on multiple lines for readability**):

    STAR --runThreadN 8 \
    --sjdbOverhang 99 \
    --genomeDir ../ref/star_index \
    --sjdbGTFtagExonParentGene gene_id \
    --sjdbGTFfile ../ref/Arabidopsis_thaliana.TAIR10.36.gtf \
    --outSAMtype BAM Unsorted SortedByCoordinate \
    --outReadsUnmapped Fastx \
    --quantMode GeneCounts \
    --outFileNamePrefix I864_S78_star_alignment/I864_S78_ \
    --readFilesIn I864_S78.sickle.R1.fastq I864_S78.sickle.R2.fastq

For this command, we are giving it the overhang like from the previous step, the genome index directory we created in the last step, an identifier name from the GTF file that identifies genes, the annotation file, the output file type, outputting unmapped reads, telling it to count reads on a gene level, the prefix for all the output files, and finally, the input files.

---

**4\.**

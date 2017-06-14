Preprocessing Data
===================

In this exercise, we will learn how to preprocess our data for alignment. We will be doing phiX detection, ribosomal RNA detection, adapter trimming, and quality trimming.

1\. First, create a directory for the example in your home directory:

    cd
    mkdir rnaseq_example

---

2\. Next, go into that directory and link to the directory for your raw data. This data comes from an Arabidopsis RNA-Seq project that we did:

    cd rnaseq_example
    ln -s /share/biocore-archive/Leveau_J_UCD/RNASeq_Arabidopsis_2016/00-RawData

---

3\. Now, take a look inside that directory.

    cd 00-RawData
    ls

--- 

4\. You will see a list of directories and some other files. Take a look at all the files in all of the directories:

    ls *

---

5\. Pick a directory and go into it. Look at one of the files using the 'zless' command:

    cd I894_S90_L006
    zless I894_S90_L006_R1_001.fastq.gz

Make sure you can identify which lines correspond to a single read and which lines are the header, sequence, and quality values. Press 'q' to exit this screen. Then, let's figure out the number of reads in this file. A simple way to do that is to count the number of lines and divide by 4 (because the record of each read uses 4 lines). In order to do this, use "zcat" to output the uncompressed file and pipe that to "wc" to count the number of lines:

    zcat I894_S90_L006_R1_001.fastq.gz | wc -l

Divide this number by 4 and you have the number of reads in this file. One more thing to try is to figure out the length of the reads without counting each nucleotide. First get the first 4 lines of the file (i.e. the first record):

    zcat I894_S90_L006_R1_001.fastq.gz | head -4

Then, copy and paste the sequence line into the following command (replace [sequence] with the line):

    echo -n [sequence] | wc -c

This will give you the length of the read. See if you can figure out how this command works.

---

6\. Now go back to your 'rnaseq_example' directory and create another directory called '01-Trimming':

    cd ~/rnaseq_example
    mkdir 01-Trimming

---

7\. Go into that directory (make sure your prompt shows that you are in the 01-Trimming directory) and link to all of the files you will be using:

    cd 01-Trimming
    ln -s ../00-RawData/*/*.gz .
    ls -l

Now you should see a long listing of all the links you just created.

---

8\. Now, we will use software called 'scythe' (developed at the UC Davis Bioinformatics Core) to do adapter trimming. First we will run it on just one pair of files. First, load the module, and then type 'scythe' with no arguments to see the options.

    module load scythe
    scythe

Looking at the Usage you can see that scythe needs an adapter file and the sequence file. The adapter file will depend upon which kit you used... typically you can find the adapters from the sequencing provider. In this case, Illumina TruSeq adapters were used, so we have put the adapters (forward & reverse) in a file for you already ([adapters file](tuesday/adapters.fasta)). You will have to use the "wget" command to copy the file to your class directory:

    wget https://ucdavis-bioinformatics-training.github.io/2017-June-RNA-Seq-Workshop/tuesday/adapters.fasta

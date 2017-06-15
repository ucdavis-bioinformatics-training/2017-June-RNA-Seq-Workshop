Alignment
==========

6\. Now go back to your 'rnaseq_example' directory and create another directory called '01-QA':

    cd ~/rnaseq_example
    mkdir 01-QA

7\. Go into that directory (make sure your prompt shows that you are in the 01-QA directory) and link to all of the files you will be using:

    cd 01-QA
    ln -s ../00-RawData/*/*.gz .
    ls -l

Now you should see a long listing of all the links you just created.

8\. Now we want to check for phiX and rRNA contamination. In order to do that we need to download the PhiX genome and Arabidopsis ribosomal RNA. And while we're at it, let's download the Arabidopsis genome as well. First, make a directory called 'ref' and go into it. 

    cd ~/rnaseq_example
    mkdir ref
    cd ref

Then, go to the [Illumina iGenomes site](https://support.illumina.com/sequencing/sequencing_software/igenome.html). We want to download the NCBI TAIR10 Arabidopsis file and the PhiX Illumina RTA file to our 'ref' directory. In order to do that, we will use the 'wget' command. Right click (or whatever is right for your laptop) on the link for Arabidopsis and choose "Copy Link Location" (or something similar). Then use wget to pull down the archive files:

    wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Arabidopsis_thaliana/NCBI/TAIR10/Arabidopsis_thaliana_NCBI_TAIR10.tar.gz

Do the same for PhiX:

    wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/PhiX/Illumina/RTA/PhiX_Illumina_RTA.tar.gz

---

9\. Next, we need to uncompress and extract all the files from the archives. We will use the 'tar' command. First, let's take a look at the options of the 'tar' command:

    man tar

You will see that 'tar' has many options... we will be using the "-x", "-v", "-z", and "-f" options, which are used for extraction, verbose information output, unzipping the file, and giving the filename, respectively. Type "q" to exit this screen.

    tar -x -v -z -f Arabidopsis_thaliana_NCBI_TAIR10.tar.gz

Do the same for PhiX:

    tar -x -v -z -f PhiX_Illumina_RTA.tar.gz
    
Explore the directories that you've just created. You'll find annotation and indexed sequence for some popular alignment programs.

---

10\. Now, let's run some Q&A on one pair of our raw data files. First go back to our Q&A directory and load the bwa aligner:

    cd ~/rnaseq_example/01-QA
    ls -ltrh
    module load bwa

Take a look at the options to bwa, by typing 'bwa' with no arguments. Then type 'bwa mem' to get the options for that subcommand:

    bwa
    bwa mem

Notice the Usage that is printed to the screen. We will use the "-t" option to use 4 threads (processors). 'idxbase' refers to the basename of the index for the genome you are aligning against. First let's align against PhiX. 

    bwa mem -t 4 ../ref/PhiX/Illumina/RTA/Sequence/BWAIndex/genome.fa C61_S67_L006_R1_001.fastq.gz C61_S67_L006_R2_001.fastq.gz > phix.sam

We use a relative path to specify the index file and we redirect the output to a new file.

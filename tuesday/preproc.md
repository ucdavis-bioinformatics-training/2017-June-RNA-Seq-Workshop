Preprocessing Data
===================

In this exercise, we will learn how to preprocess our data for alignment. We will be doing phiX detection, ribosomal RNA detection, adapter trimming, and quality trimming.

1\. First, create a directory for the example in your home directory:

    cd
    mkdir rnaseq_example


2\. Next, go into that directory and link to the directory for your raw data. This data comes from an Arabidopsis RNA-Seq project that we did:

    cd rnaseq_example
    ln -s /share/biocore-archive/Leveau_J_UCD/RNASeq_Arabidopsis_2016/00-RawData


3\. Now, take a look inside that directory.

    cd 00-RawData
    ls
    

4\. You will see a list of directories and some other files. Take a look at all the files in all of the directories:

    ls *
 

5\. Pick a directory and go into it. Look at one of the files using the 'zless' command:

    cd I894_S90_L006
    zless I894_S90_L006_R1_001.fastq.gz

 Press 'q' to exit this screen.


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

Then, go to the [Illumina iGenomes site](https://support.illumina.com/sequencing/sequencing_software/igenome.html). We want to download the NCBI TAIR10 Arabidopsis file and the PhiX Illumina RTA file to our 'ref' directory. In order to do that, we will use the 'wget' command. Right click (or whatever is right for your laptop) on the link for Arabidopsis and choose "Copy Link Location" (or something similar). Then use wget to pull down the file:

    wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Arabidopsis_thaliana/NCBI/TAIR10/Arabidopsis_thaliana_NCBI_TAIR10.tar.gz

Do the same for PhiX:

    wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/PhiX/Illumina/RTA/PhiX_Illumina_RTA.tar.gz


9\.

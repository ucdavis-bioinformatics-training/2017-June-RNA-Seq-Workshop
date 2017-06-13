Preprocessing Data
===================

In this exercise, we will learn how to preprocess our data for alignment. We will be doing phiX detection, ribosomal RNA detection, adapter trimming, and quality trimming.

1\. First, create a directory for the example in your home directory:

    cd
    mkdir rnaseq_example


2\. Next, go into that directory and link to the directory for your raw data. This data comes from a mouse RNA-Seq project that we did:

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


#library(biocInstaller)
## try http:// if https:// URLs are not supported
#source("https://bioconductor.org/biocLite.R")
#biocLite("VariantAnnotation")
#biocLite("digest")
#biocLite("snpStats")
library(VariantAnnotation)
library(snpStats)
vcf = readVcf("Tgondii_genome_snpeff.vcf")
vcf

gtm <- genotypeToSnpMatrix(vcf)

head(gtm)
names(gtm)

dim(gtm$genotypes)

head(gtm$genotypes)
rownames(gtm$genotypes)

table(gtm$map$ignore)

#FALSE   TRUE 
#117171 172516 


gtm$genotypes[,1:10]
gtm$genotypes[,1]

table(gtm$genotypes[,1])

gtm$genotypes
gtm$map
t(as(gtm$genotype[,1:10], "character"))
head(vcf)
geno(head(vcf))$GT

apply(geno(head(vcf))$GT,1,table)
apply(geno(head(vcf))$GT,1,function(x) length(unique(x)))

ngenos <- apply(geno(vcf)$GT,1,function(x) length(unique(x)))

table(ngenos)
gtm <- geno(vcf)$GT
head(gtm)
ngenosA <- apply(gtm[,c(2,3,4,6,7,8)],1,function(x) length(unique(x)))
ngenosG <- apply(gtm[,c(1,5)],1,function(x) length(unique(x)))

table(ngenosA)
vcfA <- vcf[which(ngenosA == 2),]
vcfA <- vcfA[,c(2,3,4,6,7,8)]
vcfAmult <- vcfA[sapply(info(vcfA)$TYPE,length) > 1,]
vcfAsingle <- vcfA[sapply(info(vcfA)$TYPE,length) == 1,]
vcfAsnp <- vcfAsingle[sapply(info(vcfAsingle)$TYPE,"==","snp"),]
vcfAindel <- vcfAsingle[sapply(info(vcfAsingle)$TYPE,"%in%",c("ins","del")),]
vcfAcomplex <- vcfAsingle[sapply(info(vcfAsingle)$TYPE,"!=","snp"),]

#vcfAsnp <- vcfAsnp[order(rowRanges(vcfAsnp)$QUAL,decreasing = T),]
dim(vcfAsnp)
#[1] 1340    6
writeVcf(vcfAsnp,"Tgondii_genomeAsnp_snpeff.vcf")

matAsnp <- matrix(unlist(strsplit(names(rowRanges(vcfAsnp)),split=":")),ncol=2,byrow=T)
colnames(matAsnp) <- c("Chrom","Variant")
dfAsnp <- data.frame(matAsnp,QUAL=rowRanges(vcfAsnp)$QUAL,num_samples_w_data=info(vcfAsnp)$NS,read_depth=info(vcfAsnp)$DP,geno(vcfAsnp)$GT,ANN=sapply(info(vcfAsnp)$ANN,paste,collapse=","))
write.table(dfAsnp,"Tgondii_genomeAsnp_table.txt",sep="\t",row.names=F,col.names=T,quote=F)

dim(vcfAindel)
#[1] 195   6
writeVcf(vcfAindel,"Tgondii_genomeAindel_snpeff.vcf")

matAindel <- matrix(unlist(strsplit(names(rowRanges(vcfAindel)),split=":")),ncol=2,byrow=T)
colnames(matAindel) <- c("Chrom","Variant")
dfAindel <- data.frame(matAindel,QUAL=rowRanges(vcfAindel)$QUAL,num_samples_w_data=info(vcfAindel)$NS,read_depth=info(vcfAindel)$DP,geno(vcfAindel)$GT,ANN=sapply(info(vcfAindel)$ANN,paste,collapse=","))
write.table(dfAindel,"Tgondii_genomeAindel_table.txt",sep="\t",row.names=F,col.names=T,quote=F)

vcfAcomplex <- vcfAcomplex[order(rowRanges(vcfAcomplex)$QUAL,decreasing = T),]
dim(vcfAcomplex)
#[1] 723   6
writeVcf(vcfAcomplex,"Tgondii_genomeAcomplex_snpeff.vcf")

vcfAmult <- vcfAmult[order(rowRanges(vcfAmult)$QUAL,decreasing = T),]
dim(vcfAmult)
#[1] 1076    6
writeVcf(vcfAmult,"Tgondii_genomeAmultiple_snpeff.vcf")

table(ngenosG)
vcfG <- vcf[which(ngenosG == 2),]
vcfG <- vcfG[,c(1,5)]
vcfGmult <- vcfG[sapply(info(vcfG)$TYPE,length) > 1,]
vcfGsingle <- vcfG[sapply(info(vcfG)$TYPE,length) == 1,]
vcfGsnp <- vcfGsingle[sapply(info(vcfGsingle)$TYPE,"==","snp"),]
vcfGindel <- vcfGsingle[sapply(info(vcfGsingle)$TYPE,"%in%",c("ins","del")),]
vcfGcomplex <- vcfGsingle[sapply(info(vcfGsingle)$TYPE,"!=","snp"),]

#vcfGsnp <- vcfGsnp[order(rowRanges(vcfGsnp)$QUAL,decreasing = T),]
dim(vcfGsnp)
#[1] 1669    2
vcfGsnp <- vcfGsnp[!apply(geno(vcfGsnp)$GT,1,function(x) any(x==".")),]
writeVcf(vcfGsnp,"Tgondii_genomeGsnp_snpeff.vcf")

matGsnp <- matrix(unlist(strsplit(names(rowRanges(vcfGsnp)),split=":")),ncol=2,byrow=T)
colnames(matGsnp) <- c("Chrom","Variant")
dfGsnp <- data.frame(matGsnp,QUAL=rowRanges(vcfGsnp)$QUAL,num_samples_w_data=info(vcfGsnp)$NS,read_depth=info(vcfGsnp)$DP,geno(vcfGsnp)$GT,ANN=sapply(info(vcfGsnp)$ANN,paste,collapse=","))
write.table(dfGsnp,"Tgondii_genomeGsnp_table.txt",sep="\t",row.names=F,col.names=T,quote=F)

dim(vcfGindel)
#[1] 460   2
vcfGindel <- vcfGindel[!apply(geno(vcfGindel)$GT,1,function(x) any(x==".")),]
writeVcf(vcfGindel,"Tgondii_genomeGindel_snpeff.vcf")

matGindel <- matrix(unlist(strsplit(names(rowRanges(vcfGindel)),split=":")),ncol=2,byrow=T)
colnames(matGindel) <- c("Chrom","Variant")
dfGindel <- data.frame(matGindel,QUAL=rowRanges(vcfGindel)$QUAL,num_samples_w_data=info(vcfGindel)$NS,read_depth=info(vcfGindel)$DP,geno(vcfGindel)$GT,ANN=sapply(info(vcfGindel)$ANN,paste,collapse=","))
write.table(dfGindel,"Tgondii_genomeGindel_table.txt",sep="\t",row.names=F,col.names=T,quote=F)

vcfGcomplex <- vcfGcomplex[order(rowRanges(vcfGcomplex)$QUAL,decreasing = T),]
dim(vcfGcomplex)
#[1] 1088    2
writeVcf(vcfGcomplex,"Tgondii_genomeGcomplex_snpeff.vcf")

vcfGmult <- vcfGmult[order(rowRanges(vcfGmult)$QUAL,decreasing = T),]
dim(vcfGmult)
#[1] 938   2
writeVcf(vcfGmult,"Tgondii_genomeGmultiple_snpeff.vcf")

vcf_chrIX <- vcf[seqnames(rowRanges(vcf)) == "TGGT1_chrIX"]
vcf_chrIX_5409701_5417293 <- vcf_chrIX[start(ranges(rowRanges(vcf_chrIX))) >= 5409701 & end(ranges(rowRanges(vcf_chrIX))) <= 5417293]
matvcf_chrIX <- matrix(unlist(strsplit(names(rowRanges(vcf_chrIX_5409701_5417293)),split=":")),ncol=2,byrow=T)
colnames(matvcf_chrIX) <- c("Chrom","Variant")
dfchrIX_5409701_5417293 <- data.frame(matvcf_chrIX,QUAL=rowRanges(vcf_chrIX_5409701_5417293)$QUAL,num_samples_w_data=info(vcf_chrIX_5409701_5417293)$NS,read_depth=info(vcf_chrIX_5409701_5417293)$DP,geno(vcf_chrIX_5409701_5417293)$GT[,order(colnames(geno(vcf_chrIX_5409701_5417293)$GT))],ANN=sapply(info(vcf_chrIX_5409701_5417293)$ANN,paste,collapse=","))
write.table(dfchrIX_5409701_5417293,"Tgondii_chrIX_5409701_5417293l_table.txt",sep="\t",row.names=F,col.names=T,quote=F)


vcf_chrX <- vcf[seqnames(rowRanges(vcf)) == "TGGT1_chrX"]
vcf_chrX_5450444_5452337 <- vcf_chrX[start(ranges(rowRanges(vcf_chrX))) >= 5450444 & end(ranges(rowRanges(vcf_chrX))) <= 5452337]
matvcf_chrX <- matrix(unlist(strsplit(names(rowRanges(vcf_chrX_5450444_5452337)),split=":")),ncol=2,byrow=T)
colnames(matvcf_chrX) <- c("Chrom","Variant")
dfchrX_5450444_5452337 <- data.frame(matvcf_chrX,QUAL=rowRanges(vcf_chrX_5450444_5452337)$QUAL,num_samples_w_data=info(vcf_chrX_5450444_5452337)$NS,read_depth=info(vcf_chrX_5450444_5452337)$DP,geno(vcf_chrX_5450444_5452337)$GT[,order(colnames(geno(vcf_chrX_5450444_5452337)$GT))],ANN=sapply(info(vcf_chrX_5450444_5452337)$ANN,paste,collapse=","))
write.table(dfchrX_5450444_5452337,"Tgondii_chrX_5450444_5452337_table.txt",sep="\t",row.names=F,col.names=T,quote=F)




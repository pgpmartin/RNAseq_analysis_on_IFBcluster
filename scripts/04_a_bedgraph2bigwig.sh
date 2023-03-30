#!/bin/bash
#SBATCH --account=2306_bioinfo_rnaseq_m1
#SBATCH --job-name=bg2bw
#SBATCH --output=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/04_a_bedgraph2bigwig_%A_%a.out
#SBATCH --error=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/04_a_bedgraph2bigwig_%A_%a.err
#SBATCH --array=0-5
#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G


#chargement modules
module load ucsc-bedgraphtobigwig/377

#Nom de l'échantillon
formdir="/shared/projects/2306_bioinfo_rnaseq_m1"
workdir="${formdir}/TD_RNAseq"
bankdir="${workdir}/bank"

SNames=("GSE112441_bdrs_rep1" \
        "GSE112441_bdrs_rep2" \
        "GSE112441_bdrs_rep3" \
        "GSE112441_WT_rep1" \
        "GSE112441_WT_rep2" \
        "GSE112441_WT_rep3")

SampleName="${SNames[${SLURM_ARRAY_TASK_ID}]}"


#Chemin des fichiers bedgraph (input)
bgFile_strand1="${workdir}/results/star/${SampleName}_Signal.Unique.str1.out.bg"
bgFile_strand2="${workdir}/results/star/${SampleName}_Signal.Unique.str2.out.bg"

#Chemin des fichiers bigwig (output)
bwFile_strand1="${workdir}/results/star/${SampleName}_Signal.Unique.str1.out.bigwig"
bwFile_strand2="${workdir}/results/star/${SampleName}_Signal.Unique.str2.out.bigwig"

#conversion bedgraph to bigwig
bedGraphToBigWig ${bgFile_strand1} ${bankdir}/TAIR10_chrom.sizes ${bwFile_strand1}
bedGraphToBigWig ${bgFile_strand2} ${bankdir}/TAIR10_chrom.sizes ${bwFile_strand2}


echo "bedGraphToBigWig pour ${SampleName} terminé!"

# Fin


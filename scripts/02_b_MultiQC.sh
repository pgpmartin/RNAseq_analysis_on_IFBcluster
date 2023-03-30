#!/bin/bash
#SBATCH --account=2306_bioinfo_rnaseq_m1
#SBATCH --job-name=multiqc
#SBATCH --output=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/02_b_MultiQC_%j.out
#SBATCH --error=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/02_b_MultiQC_%j.err
#SBATCH --time=00:30:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=6G

#chargement modules
module load multiqc/1.11

#répertoire de travail
formdir="/shared/projects/2306_bioinfo_rnaseq_m1"
workdir="${formdir}/TD_RNAseq"

#repertoire à analyser
targetdir="${workdir}/results/fastqc"

#répertoire de sortie
outdir="${targetdir}/multiqc"
mkdir -p ${outdir}

# Lancer multiqc
multiqc \
  -n "multiqc_rawReads" \
  -o ${outdir} \
  ${targetdir}

#Fin du script

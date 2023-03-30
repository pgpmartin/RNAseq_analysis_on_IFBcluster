#!/bin/bash
#SBATCH --account=2306_bioinfo_rnaseq_m1
#SBATCH --job-name=bamscale
#SBATCH --output=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/04_b_bamscale_filteredReads_%A_%a.out
#SBATCH --error=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/04_b_bamscale_filteredReads_%A_%a.err
#SBATCH --array=0-5
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G


#Objectif: générer des fichiers signaux bigwig à partir des reads filtrés

#chargement modules
module load bamscale/0.0.5

#nombre de coeurs
nthreads=${SLURM_CPUS_PER_TASK}

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


#Chemin du fichier d'entrée
inputBAM="${workdir}/results/star/${SampleName}_filtered.bam"

#Chemin du dossier de sortie
outdir="${workdir}/results/tracks"
mkdir -p ${outdir}


##------------
## bamscale
##------------

BAMscale scale \
  --threads ${nthreads} \
  --operation strandrna \
  --keepdup yes \
  --outdir ${outdir} \
  --bam ${inputBAM} \
;

echo "bamscale sur ${SampleName} terminé!"

#Fin

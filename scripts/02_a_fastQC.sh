#!/bin/bash
#SBATCH --account=form_2022_07
#SBATCH --job-name=fastqc
#SBATCH --output=/shared/projects/form_2022_07/TD_RNAseq/log/02_a_fastQC_%A_%a.out
#SBATCH --error=/shared/projects/form_2022_07/TD_RNAseq/log/02_a_fastQC_%A_%a.err
#SBATCH --array=0-5
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=6G

# set -e indique au script de s'arrêter à la première erreur
# set -u indique au script de considérer l'utilisation d'une variable vide comme une erreur
set -ue

#chargement modules
module load fastqc/0.11.9


#Nom de l'échantillon
formdir="/shared/projects/form_2022_07"
workdir="${formdir}/TD_RNAseq"
datadir="${workdir}/data"

SNames=("GSE112441_bdrs_rep1" \
        "GSE112441_bdrs_rep2" \
        "GSE112441_bdrs_rep3" \
        "GSE112441_WT_rep1" \
        "GSE112441_WT_rep2" \
        "GSE112441_WT_rep3")

SampleName="${SNames[${SLURM_ARRAY_TASK_ID}]}"


#Chemin des fichiers fastq

fqfile1="${datadir}/${SampleName}_R1.fastq"
fqfile2="${datadir}/${SampleName}_R2.fastq"

#Chemin des fichiers de sortie
outdir="${workdir}/results/fastqc"
mkdir -p ${outdir}

# fastqc
fastqc \
  -o ${outdir} \
  ${fqfile1} \
  ${fqfile2}

# message de fin
echo "FastQC done for ${SampleName}"

#Fin du script

#!/bin/bash
#SBATCH --account=2306_bioinfo_rnaseq_m1
#SBATCH --job-name=fcount
#SBATCH --output=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/05_a_featurecounts_%A_%a.out
#SBATCH --error=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/05_a_featurecounts_%A_%a.err
#SBATCH --array=0-5
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8G


#Objectif: compter les reads qui s'alignent sur chaque gène

#chargement modules
module load subread/2.0.1

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
outdir="${workdir}/results/fcount"
mkdir -p ${outdir}

# paramètres
gtfFile="${bankdir}/TAIR10_GTF_genes.gtf"
fastaFile="${bankdir}/TAIR10.fa"
outcount="${outdir}/${SampleName}_filtered.fcount"

##------------
## featurecount
##------------


# these RNA-seq data are reversely stranded (-s 2)

featureCounts \
  -T ${nthreads} \
  -a ${gtfFile} \
  -G ${fastaFile} \
  -p \
  -s 2 \
  -B \
  -C \
  -o ${outcount} \
  ${inputBAM} \
;

echo "featurecount sur ${SampleName} terminé!"

#Fin

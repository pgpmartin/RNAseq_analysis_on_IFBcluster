#!/bin/bash
#SBATCH --account=2306_bioinfo_rnaseq_m1
#SBATCH --job-name=staraln
#SBATCH --output=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/03_a_STAR_pe_%A_%a.out
#SBATCH --error=/shared/projects/2306_bioinfo_rnaseq_m1/TD_RNAseq/log/03_a_STAR_pe_%A_%a.err
#SBATCH --array=0-5
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G


#chargement modules
module load star/2.7.9a
module load samtools/1.14

#nombre de coeurs
nthreads=${SLURM_CPUS_PER_TASK}

#Nom de l'échantillon
formdir="/shared/projects/2306_bioinfo_rnaseq_m1"
workdir="${formdir}/TD_RNAseq"
bankdir="${workdir}/bank"
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
outdir="${workdir}/results/star"
mkdir -p ${outdir}

#chemin de l'index STAR
genomedir="${bankdir}/star_index"


##------------
## STAR
##------------

STAR \
  --runMode alignReads \
  --runThreadN ${nthreads} \
  --genomeDir ${genomedir} \
  --readFilesIn ${fqfile1} ${fqfile2} \
  --outFileNamePrefix ${outdir}/${SampleName}_ \
  --outSAMtype BAM SortedByCoordinate \
  --outWigType bedGraph \
;

echo "Alignement STAR de ${SampleName} terminé!"


# Indexage du fichier BAM
outputBAM="${outdir}/${SampleName}_Aligned.sortedByCoord.out.bam"

# Index BAM
samtools index ${outputBAM}

echo "Indexage du fichier BAM de ${SampleName} terminé!"


##------------
## Filtrage des alignements
##------------
#Les reads avec MapQ < 10 sont éliminés (-q 10)
#On élimine (-F 780):
#  - les reads non mappés
#  - les reads dont le read apparié est non mappé
#  - les reads qui ne passent pas les contrôle qualité d'Illlumina
#  - les alignements secondaires
#On garde (-f 3):
#  - les reads appariés
#  - les reads alignés de manière correctement appariés (read mapped in proper pair)

filteredBAM=${outputBAM/_Aligned.sortedByCoord.out.bam/_filtered.bam}

samtools view \
  -bh \
  -f 3 \
  -F 780 \
  -q 10 \
  ${outputBAM}  | \
  samtools sort -o ${filteredBAM}

#Indexage du fichier filtré
samtools index ${filteredBAM}

echo "Filtrage des reads pour ${SampleName} terminé!"

##------------
## Nombre de reads avant/après avoir filtré
##------------
ReadsBeforeFiltering=$(samtools view -c ${outputBAM})
ReadsAfterFiltering=$(samtools view -c ${filteredBAM})

echo "Reads avant filtrage: ${ReadsBeforeFiltering}"
echo "Reads après filtrage: ${ReadsAfterFiltering}"


echo "Echantillon ${SampleName} - tout est terminé!"


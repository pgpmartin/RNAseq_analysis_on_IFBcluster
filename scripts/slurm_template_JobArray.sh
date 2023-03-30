#!/bin/bash
#SBATCH --account=2306_bioinfo_rnaseq_m1
#SBATCH --job-name=<MyJOB>
#SBATCH --output=</Path/to/outputFile_%A_%a.out>
#SBATCH --error=</Path/to/errorFile_%A_%a.err>
#SBATCH --array=0-3
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=6G

#chargement modules
module load <somemodule>

#nombre de coeurs
nthreads=${SLURM_CPUS_PER_TASK}

#Nom de l'échantillon (utilisation de l'indice de l'array)
SNames=("Sample1" \
        "Sample2" \
        "Sample3" \
        "Sample4")

SampleName="${SNames[${SLURM_ARRAY_TASK_ID}]}"

#Faire quelque chose avec cet échantillon

echo $SampleName

#Fin du script

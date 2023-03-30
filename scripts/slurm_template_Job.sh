#!/bin/bash
#SBATCH --account=2306_bioinfo_rnaseq_m1
#SBATCH --job-name=<MyJOB>
#SBATCH --output=</Path/to/outputFile_%j.out>
#SBATCH --error=</Path/to/errorFile_%j.err>
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=6G

#chargement modules
module load <somemodule>

#nombre de coeurs
nthreads=${SLURM_CPUS_PER_TASK}

#Nom de l'échantillon
SampleName="MyOnlySample"

#Faire quelque chose avec cet échantillon

echo "$SampleName"

#Fin du script

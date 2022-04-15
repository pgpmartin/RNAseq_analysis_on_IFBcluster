#!/bin/bash
#SBATCH --account=form_2022_07
#SBATCH --job-name=SetupSession
#SBATCH --output=/shared/projects/form_2022_07/log/00_a_SetupSession_M1B2AS_UE_NGS_%j.out
#SBATCH --error=/shared/projects/form_2022_07/log/00_a_SetupSession_M1B2AS_UE_NGS_%j.err
#SBATCH --time=18:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8G

#Aim: setup the folder with the material necessary to do the course
formdir="/shared/projects/form_2022_07"

# Clone git repo
cd $formdir
git clone https://github.com/pgpmartin/Master_B2AS_UE_NGS

###----------------
### TD RNA-seq
###----------------

##--------
## Setup folders

workdir="${formdir}/TD_RNAseq"

# données :
datadir="${workdir}/data"
mkdir -p $datadir

# génome :
bankdir="${workdir}/bank"
mkdir -p $bankdir

# scripts :
scriptdir="${workdir}/scripts"
mkdir -p $scriptdir

# log :
logdir="${workdir}/log"
mkdir -p $logdir

##--------
## Create symlinks

ln -s $bankdir ${formdir}/bank
ln -s $datadir ${formdir}/data

##--------
## scripts
cp ${formdir}/Master_B2AS_UE_NGS/scripts/*.sh ${scriptdir}/
chmod 750 ${scriptdir}/*.sh

##--------
## Donnnées brutes

#déplacement dans le dossier:
cd $datadir

#téléchargement des fichiers (en leur assignant des noms plus explicites)
enaFolder="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR690"
curl -L $enaFolder/004/SRR6908884/SRR6908884_1.fastq.gz -o GSE112441_WT_rep1_R1.fastq.gz
curl -L $enaFolder/004/SRR6908884/SRR6908884_2.fastq.gz -o GSE112441_WT_rep1_R2.fastq.gz
curl -L $enaFolder/006/SRR6908886/SRR6908886_1.fastq.gz -o GSE112441_WT_rep3_R1.fastq.gz
curl -L $enaFolder/006/SRR6908886/SRR6908886_2.fastq.gz -o GSE112441_WT_rep3_R2.fastq.gz
curl -L $enaFolder/006/SRR6908896/SRR6908896_1.fastq.gz -o GSE112441_bdrs_rep1_R1.fastq.gz
curl -L $enaFolder/006/SRR6908896/SRR6908896_2.fastq.gz -o GSE112441_bdrs_rep1_R2.fastq.gz
curl -L $enaFolder/008/SRR6908898/SRR6908898_1.fastq.gz -o GSE112441_bdrs_rep3_R1.fastq.gz
curl -L $enaFolder/008/SRR6908898/SRR6908898_2.fastq.gz -o GSE112441_bdrs_rep3_R2.fastq.gz
curl -L $enaFolder/007/SRR6908897/SRR6908897_1.fastq.gz -o GSE112441_bdrs_rep2_R1.fastq.gz
curl -L $enaFolder/007/SRR6908897/SRR6908897_2.fastq.gz -o GSE112441_bdrs_rep2_R2.fastq.gz
curl -L $enaFolder/005/SRR6908885/SRR6908885_1.fastq.gz -o GSE112441_WT_rep2_R1.fastq.gz
curl -L $enaFolder/005/SRR6908885/SRR6908885_2.fastq.gz -o GSE112441_WT_rep2_R2.fastq.gz

# decompression des fichiers
gunzip $datadir/*.fastq.gz

##--------
# FASTA sequence

cd $bankdir

### download fasta sequence
wget ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/TAIR10_chr1.fas
wget ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/TAIR10_chr2.fas
wget ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/TAIR10_chr3.fas
wget ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/TAIR10_chr4.fas
wget ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/TAIR10_chr5.fas
wget ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/TAIR10_chrC.fas
wget ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/TAIR10_chrM.fas

### assemble in a single file
touch ${bankdir}/TAIR10.fa
for chr in 1 2 3 4 5 C M; do
  echo ">Chr${chr}" >> ${bankdir}/TAIR10.fa
  tail -n +2 ${bankdir}/TAIR10_chr${chr}.fas >> ${bankdir}/TAIR10.fa
  rm TAIR10_chr${chr}.fas
done

### index fasta
module load samtools/1.14
samtools faidx TAIR10.fa

### get chromosomes sizes
cut -f 1,2 TAIR10.fa.fai > TAIR10_chrom.sizes

##--------
## GFF/GTF annotations

### Download annotations
cd $bankdir
wget ftp://ftp.arabidopsis.org/home/tair/Genes/TAIR10_genome_release/TAIR10_gff3/TAIR10_GFF3_genes.gff

### Convert to GTF
cd $bankdir
module load cufflinks/2.2.1
gffread TAIR10_GFF3_genes.gff -T -o TAIR10_GTF_genes.gtf

##--------
## STAR index
module load star/2.7.9a

genomedir="${bankdir}/star_index"
mkdir -p $genomedir

STAR \
  --runMode genomeGenerate \
  --genomeDir ${genomedir} \
  --genomeFastaFiles ${bankdir}/TAIR10.fa \
  --sjdbGTFfile ${bankdir}/TAIR10_GFF3_genes.gff \
  --sjdbGTFtagExonParentTranscript Parent \
  --genomeSAindexNbases 12 \
;


###----------------
### Projets en groupe
###----------------

##--------
## Download data

projectDataDir="${formdir}/data_project"
mkdir -p ${projectDataDir}

ENAftp="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR623"

#Controls
curl -L ${ENAftp}/008/SRR6236998/SRR6236998.fastq.gz -o ${projectDataDir}/SRR6236998_Control_0_h_replicate1.fastq.gz
curl -L ${ENAftp}/000/SRR6237000/SRR6237000.fastq.gz -o ${projectDataDir}/SRR6237000_Control_0_h_replicate2.fastq.gz
curl -L ${ENAftp}/006/SRR6236996/SRR6236996.fastq.gz -o ${projectDataDir}/SRR6236996_Control_0_h_replicate3.fastq.gz
curl -L ${ENAftp}/007/SRR6236997/SRR6236997.fastq.gz -o ${projectDataDir}/SRR6236997_Control_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/005/SRR6236995/SRR6236995.fastq.gz -o ${projectDataDir}/SRR6236995_Control_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/009/SRR6236999/SRR6236999.fastq.gz -o ${projectDataDir}/SRR6236999_Control_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/000/SRR6236990/SRR6236990.fastq.gz -o ${projectDataDir}/SRR6236990_Control_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/009/SRR6237009/SRR6237009.fastq.gz -o ${projectDataDir}/SRR6237009_Control_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/000/SRR6237010/SRR6237010.fastq.gz -o ${projectDataDir}/SRR6237010_Control_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/002/SRR6237022/SRR6237022.fastq.gz -o ${projectDataDir}/SRR6237022_Control_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/003/SRR6237023/SRR6237023.fastq.gz -o ${projectDataDir}/SRR6237023_Control_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/004/SRR6237024/SRR6237024.fastq.gz -o ${projectDataDir}/SRR6237024_Control_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/003/SRR6237043/SRR6237043.fastq.gz -o ${projectDataDir}/SRR6237043_Control_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/002/SRR6237042/SRR6237042.fastq.gz -o ${projectDataDir}/SRR6237042_Control_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/005/SRR6237005/SRR6237005.fastq.gz -o ${projectDataDir}/SRR6237005_Control_6_h_replicate3.fastq.gz

#Beneficial rhizobacteria Pseudomonas simiae WCS417
curl -L ${ENAftp}/003/SRR6236993/SRR6236993.fastq.gz -o ${projectDataDir}/SRR6236993_rhizo_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/004/SRR6236994/SRR6236994.fastq.gz -o ${projectDataDir}/SRR6236994_rhizo_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/001/SRR6237001/SRR6237001.fastq.gz -o ${projectDataDir}/SRR6237001_rhizo_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/009/SRR6236989/SRR6236989.fastq.gz -o ${projectDataDir}/SRR6236989_rhizo_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/008/SRR6236988/SRR6236988.fastq.gz -o ${projectDataDir}/SRR6236988_rhizo_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/007/SRR6236987/SRR6236987.fastq.gz -o ${projectDataDir}/SRR6236987_rhizo_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/005/SRR6237025/SRR6237025.fastq.gz -o ${projectDataDir}/SRR6237025_rhizo_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/006/SRR6237026/SRR6237026.fastq.gz -o ${projectDataDir}/SRR6237026_rhizo_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/007/SRR6237027/SRR6237027.fastq.gz -o ${projectDataDir}/SRR6237027_rhizo_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/006/SRR6237006/SRR6237006.fastq.gz -o ${projectDataDir}/SRR6237006_rhizo_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/003/SRR6237003/SRR6237003.fastq.gz -o ${projectDataDir}/SRR6237003_rhizo_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/004/SRR6237004/SRR6237004.fastq.gz -o ${projectDataDir}/SRR6237004_rhizo_6_h_replicate3.fastq.gz

#flg22 from beneficial rhizobacteria Pseudomonas simiae WCS417
curl -L ${ENAftp}/002/SRR6237002/SRR6237002.fastq.gz -o ${projectDataDir}/SRR6237002_flg22Psim_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/007/SRR6237017/SRR6237017.fastq.gz -o ${projectDataDir}/SRR6237017_flg22Psim_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/008/SRR6237018/SRR6237018.fastq.gz -o ${projectDataDir}/SRR6237018_flg22Psim_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/006/SRR6236986/SRR6236986.fastq.gz -o ${projectDataDir}/SRR6236986_flg22Psim_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/005/SRR6236985/SRR6236985.fastq.gz -o ${projectDataDir}/SRR6236985_flg22Psim_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/004/SRR6236984/SRR6236984.fastq.gz -o ${projectDataDir}/SRR6236984_flg22Psim_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/008/SRR6237028/SRR6237028.fastq.gz -o ${projectDataDir}/SRR6237028_flg22Psim_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/005/SRR6237035/SRR6237035.fastq.gz -o ${projectDataDir}/SRR6237035_flg22Psim_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/004/SRR6237034/SRR6237034.fastq.gz -o ${projectDataDir}/SRR6237034_flg22Psim_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/000/SRR6237030/SRR6237030.fastq.gz -o ${projectDataDir}/SRR6237030_flg22Psim_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/009/SRR6237029/SRR6237029.fastq.gz -o ${projectDataDir}/SRR6237029_flg22Psim_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/007/SRR6237007/SRR6237007.fastq.gz -o ${projectDataDir}/SRR6237007_flg22Psim_6_h_replicate3.fastq.gz

#flg22 from pathogenic Pseudomonas aeruginosa
curl -L ${ENAftp}/005/SRR6237015/SRR6237015.fastq.gz -o ${projectDataDir}/SRR6237015_flg22Paer_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/006/SRR6237016/SRR6237016.fastq.gz -o ${projectDataDir}/SRR6237016_flg22Paer_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/003/SRR6237013/SRR6237013.fastq.gz -o ${projectDataDir}/SRR6237013_flg22Paer_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/003/SRR6236983/SRR6236983.fastq.gz -o ${projectDataDir}/SRR6236983_flg22Paer_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/002/SRR6236992/SRR6236992.fastq.gz -o ${projectDataDir}/SRR6236992_flg22Paer_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/001/SRR6236991/SRR6236991.fastq.gz -o ${projectDataDir}/SRR6236991_flg22Paer_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/007/SRR6237037/SRR6237037.fastq.gz -o ${projectDataDir}/SRR6237037_flg22Paer_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/006/SRR6237036/SRR6237036.fastq.gz -o ${projectDataDir}/SRR6237036_flg22Paer_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/009/SRR6237039/SRR6237039.fastq.gz -o ${projectDataDir}/SRR6237039_flg22Paer_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/008/SRR6237008/SRR6237008.fastq.gz -o ${projectDataDir}/SRR6237008_flg22Paer_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/002/SRR6237032/SRR6237032.fastq.gz -o ${projectDataDir}/SRR6237032_flg22Paer_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/003/SRR6237033/SRR6237033.fastq.gz -o ${projectDataDir}/SRR6237033_flg22Paer_6_h_replicate3.fastq.gz

# Treatment with chitin
curl -L ${ENAftp}/004/SRR6237014/SRR6237014.fastq.gz -o ${projectDataDir}/SRR6237014_chitin_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/001/SRR6237011/SRR6237011.fastq.gz -o ${projectDataDir}/SRR6237011_chitin_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/002/SRR6237012/SRR6237012.fastq.gz -o ${projectDataDir}/SRR6237012_chitin_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/009/SRR6237019/SRR6237019.fastq.gz -o ${projectDataDir}/SRR6237019_chitin_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/000/SRR6237020/SRR6237020.fastq.gz -o ${projectDataDir}/SRR6237020_chitin_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/001/SRR6237021/SRR6237021.fastq.gz -o ${projectDataDir}/SRR6237021_chitin_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/008/SRR6237038/SRR6237038.fastq.gz -o ${projectDataDir}/SRR6237038_chitin_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/001/SRR6237041/SRR6237041.fastq.gz -o ${projectDataDir}/SRR6237041_chitin_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/000/SRR6237040/SRR6237040.fastq.gz -o ${projectDataDir}/SRR6237040_chitin_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/005/SRR6237045/SRR6237045.fastq.gz -o ${projectDataDir}/SRR6237045_chitin_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/004/SRR6237044/SRR6237044.fastq.gz -o ${projectDataDir}/SRR6237044_chitin_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/001/SRR6237031/SRR6237031.fastq.gz -o ${projectDataDir}/SRR6237031_chitin_6_h_replicate3.fastq.gz

##--------
## Create projects folder with corresponding symlinks

### Groupe 1
destdir="${formdir}/projet_groupe1"
mkdir -p ${destdir}/data
mkdir -p ${destdir}/log
mkdir -p ${destdir}/scripts
ln -s ${bankdir} ${destdir}/bank

# Controls
cd ${projectDataDir}
for fn in `ls SRR*_Control_*.fastq.gz`; do
  ln -s ${projectDataDir}/${fn} ${destdir}/data/${fn}
done

# rhizo
for fn in `ls SRR*_rhizo_*.fastq.gz`; do
  ln -s ${projectDataDir}/${fn} ${destdir}/data/${fn}
done


### Groupe 2
destdir="${formdir}/projet_groupe2"
mkdir -p ${destdir}/data
mkdir -p ${destdir}/log
mkdir -p ${destdir}/scripts
ln -s ${bankdir} ${destdir}/bank

# Controls
cd ${projectDataDir}
for fn in `ls SRR*_Control_*.fastq.gz`; do
  ln -s ${projectDataDir}/${fn} ${destdir}/data/${fn}
done

# flg22Psim
for fn in `ls SRR*_flg22Psim_*.fastq.gz`; do
  ln -s ${projectDataDir}/${fn} ${destdir}/data/${fn}
done


### Groupe 3
destdir="${formdir}/projet_groupe3"
mkdir -p ${destdir}/data
mkdir -p ${destdir}/log
mkdir -p ${destdir}/scripts
ln -s ${bankdir} ${destdir}/bank

# Controls
cd ${projectDataDir}
for fn in `ls SRR*_Control_*.fastq.gz`; do
  ln -s ${projectDataDir}/${fn} ${destdir}/data/${fn}
done

# flg22Paer
for fn in `ls SRR*_flg22Paer_*.fastq.gz`; do
  ln -s ${projectDataDir}/${fn} ${destdir}/data/${fn}
done


### Groupe 4
destdir="${formdir}/projet_groupe4"
mkdir -p ${destdir}/data
mkdir -p ${destdir}/log
mkdir -p ${destdir}/scripts
ln -s ${bankdir} ${destdir}/bank

# Controls
cd ${projectDataDir}
for fn in `ls SRR*_Control_*.fastq.gz`; do
  ln -s ${projectDataDir}/${fn} ${destdir}/data/${fn}
done

# chitin
for fn in `ls SRR*_chitin_*.fastq.gz`; do
  ln -s ${projectDataDir}/${fn} ${destdir}/data/${fn}
done


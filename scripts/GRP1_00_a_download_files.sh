#!/bin/bash
#SBATCH --account=form_2022_07
#SBATCH --job-name=grp1
#SBATCH --output=/shared/projects/form_2022_07/projet_groupe1/log/00_a_download_files.out
#SBATCH --error=/shared/projects/form_2022_07/projet_groupe1/log/00_a_download_files.err
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G

set -ue

datadir="/shared/projects/form_2022_07/projet_groupe1/data"
ENAftp="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR623"

#Controls
#~ curl -L ${ENAftp}/008/SRR6236998/SRR6236998.fastq.gz -o ${datadir}/SRR6236998_Control_0_h_replicate1.fastq.gz
#~ curl -L ${ENAftp}/000/SRR6237000/SRR6237000.fastq.gz -o ${datadir}/SRR6237000_Control_0_h_replicate2.fastq.gz
#~ curl -L ${ENAftp}/006/SRR6236996/SRR6236996.fastq.gz -o ${datadir}/SRR6236996_Control_0_h_replicate3.fastq.gz
#~ curl -L ${ENAftp}/007/SRR6236997/SRR6236997.fastq.gz -o ${datadir}/SRR6236997_Control_0.5_h_replicate1.fastq.gz
#~ curl -L ${ENAftp}/005/SRR6236995/SRR6236995.fastq.gz -o ${datadir}/SRR6236995_Control_0.5_h_replicate2.fastq.gz
#~ curl -L ${ENAftp}/009/SRR6236999/SRR6236999.fastq.gz -o ${datadir}/SRR6236999_Control_0.5_h_replicate3.fastq.gz
#~ curl -L ${ENAftp}/000/SRR6236990/SRR6236990.fastq.gz -o ${datadir}/SRR6236990_Control_1_h_replicate3.fastq.gz
#~ curl -L ${ENAftp}/009/SRR6237009/SRR6237009.fastq.gz -o ${datadir}/SRR6237009_Control_1_h_replicate1.fastq.gz
#~ curl -L ${ENAftp}/000/SRR6237010/SRR6237010.fastq.gz -o ${datadir}/SRR6237010_Control_1_h_replicate2.fastq.gz
#~ curl -L ${ENAftp}/002/SRR6237022/SRR6237022.fastq.gz -o ${datadir}/SRR6237022_Control_3_h_replicate1.fastq.gz
#~ curl -L ${ENAftp}/003/SRR6237023/SRR6237023.fastq.gz -o ${datadir}/SRR6237023_Control_3_h_replicate2.fastq.gz
#~ curl -L ${ENAftp}/004/SRR6237024/SRR6237024.fastq.gz -o ${datadir}/SRR6237024_Control_3_h_replicate3.fastq.gz
#~ curl -L ${ENAftp}/003/SRR6237043/SRR6237043.fastq.gz -o ${datadir}/SRR6237043_Control_6_h_replicate1.fastq.gz
#~ curl -L ${ENAftp}/002/SRR6237042/SRR6237042.fastq.gz -o ${datadir}/SRR6237042_Control_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/005/SRR6237005/SRR6237005.fastq.gz -o ${datadir}/SRR6237005_Control_6_h_replicate3.fastq.gz

#Beneficial rhizobacteria Pseudomonas simiae WCS417
curl -L ${ENAftp}/003/SRR6236993/SRR6236993.fastq.gz -o ${datadir}/SRR6236993_rhizo_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/004/SRR6236994/SRR6236994.fastq.gz -o ${datadir}/SRR6236994_rhizo_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/001/SRR6237001/SRR6237001.fastq.gz -o ${datadir}/SRR6237001_rhizo_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/009/SRR6236989/SRR6236989.fastq.gz -o ${datadir}/SRR6236989_rhizo_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/008/SRR6236988/SRR6236988.fastq.gz -o ${datadir}/SRR6236988_rhizo_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/007/SRR6236987/SRR6236987.fastq.gz -o ${datadir}/SRR6236987_rhizo_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/005/SRR6237025/SRR6237025.fastq.gz -o ${datadir}/SRR6237025_rhizo_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/006/SRR6237026/SRR6237026.fastq.gz -o ${datadir}/SRR6237026_rhizo_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/007/SRR6237027/SRR6237027.fastq.gz -o ${datadir}/SRR6237027_rhizo_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/006/SRR6237006/SRR6237006.fastq.gz -o ${datadir}/SRR6237006_rhizo_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/003/SRR6237003/SRR6237003.fastq.gz -o ${datadir}/SRR6237003_rhizo_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/004/SRR6237004/SRR6237004.fastq.gz -o ${datadir}/SRR6237004_rhizo_6_h_replicate3.fastq.gz


#Fin du script

#!/bin/bash
#SBATCH --account=form_2022_07
#SBATCH --job-name=grp2
#SBATCH --output=/shared/projects/form_2022_07/projet_groupe2/log/00_a_download_files.out
#SBATCH --error=/shared/projects/form_2022_07/projet_groupe2/log/00_a_download_files.err
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G

set -ue

datadir="/shared/projects/form_2022_07/projet_groupe2/data"
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
#~ curl -L ${ENAftp}/005/SRR6237005/SRR6237005.fastq.gz -o ${datadir}/SRR6237005_Control_6_h_replicate3.fastq.gz

#flg22 from beneficial rhizobacteria Pseudomonas simiae WCS417
curl -L ${ENAftp}/002/SRR6237002/SRR6237002.fastq.gz -o ${datadir}/SRR6237002_flg22Psim_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/007/SRR6237017/SRR6237017.fastq.gz -o ${datadir}/SRR6237017_flg22Psim_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/008/SRR6237018/SRR6237018.fastq.gz -o ${datadir}/SRR6237018_flg22Psim_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/006/SRR6236986/SRR6236986.fastq.gz -o ${datadir}/SRR6236986_flg22Psim_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/005/SRR6236985/SRR6236985.fastq.gz -o ${datadir}/SRR6236985_flg22Psim_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/004/SRR6236984/SRR6236984.fastq.gz -o ${datadir}/SRR6236984_flg22Psim_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/008/SRR6237028/SRR6237028.fastq.gz -o ${datadir}/SRR6237028_flg22Psim_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/005/SRR6237035/SRR6237035.fastq.gz -o ${datadir}/SRR6237035_flg22Psim_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/004/SRR6237034/SRR6237034.fastq.gz -o ${datadir}/SRR6237034_flg22Psim_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/000/SRR6237030/SRR6237030.fastq.gz -o ${datadir}/SRR6237030_flg22Psim_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/009/SRR6237029/SRR6237029.fastq.gz -o ${datadir}/SRR6237029_flg22Psim_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/007/SRR6237007/SRR6237007.fastq.gz -o ${datadir}/SRR6237007_flg22Psim_6_h_replicate3.fastq.gz

#Fin du script

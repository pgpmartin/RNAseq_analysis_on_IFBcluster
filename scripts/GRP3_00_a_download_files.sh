#!/bin/bash
#SBATCH --account=form_2022_07
#SBATCH --job-name=grp3
#SBATCH --output=/shared/projects/form_2022_07/projet_groupe3/log/00_a_download_files.out
#SBATCH --error=/shared/projects/form_2022_07/projet_groupe3/log/00_a_download_files.err
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G

set -ue

datadir="/shared/projects/form_2022_07/projet_groupe3/data"
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

#flg22 from pathogenic Pseudomonas aeruginosa
curl -L ${ENAftp}/005/SRR6237015/SRR6237015.fastq.gz -o ${datadir}/SRR6237015_flg22Paer_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/006/SRR6237016/SRR6237016.fastq.gz -o ${datadir}/SRR6237016_flg22Paer_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/003/SRR6237013/SRR6237013.fastq.gz -o ${datadir}/SRR6237013_flg22Paer_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/003/SRR6236983/SRR6236983.fastq.gz -o ${datadir}/SRR6236983_flg22Paer_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/002/SRR6236992/SRR6236992.fastq.gz -o ${datadir}/SRR6236992_flg22Paer_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/001/SRR6236991/SRR6236991.fastq.gz -o ${datadir}/SRR6236991_flg22Paer_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/007/SRR6237037/SRR6237037.fastq.gz -o ${datadir}/SRR6237037_flg22Paer_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/006/SRR6237036/SRR6237036.fastq.gz -o ${datadir}/SRR6237036_flg22Paer_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/009/SRR6237039/SRR6237039.fastq.gz -o ${datadir}/SRR6237039_flg22Paer_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/008/SRR6237008/SRR6237008.fastq.gz -o ${datadir}/SRR6237008_flg22Paer_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/002/SRR6237032/SRR6237032.fastq.gz -o ${datadir}/SRR6237032_flg22Paer_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/003/SRR6237033/SRR6237033.fastq.gz -o ${datadir}/SRR6237033_flg22Paer_6_h_replicate3.fastq.gz

#Fin du script

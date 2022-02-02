#!/bin/bash
#SBATCH --account=form_2022_07
#SBATCH --job-name=grp4
#SBATCH --output=/shared/projects/form_2022_07/projet_groupe4/log/00_a_download_files.out
#SBATCH --error=/shared/projects/form_2022_07/projet_groupe4/log/00_a_download_files.err
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G

set -ue

datadir="/shared/projects/form_2022_07/projet_groupe4/data"
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

# Treatment with chitin
curl -L ${ENAftp}/004/SRR6237014/SRR6237014.fastq.gz -o ${datadir}/SRR6237014_chitin_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/001/SRR6237011/SRR6237011.fastq.gz -o ${datadir}/SRR6237011_chitin_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/002/SRR6237012/SRR6237012.fastq.gz -o ${datadir}/SRR6237012_chitin_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/009/SRR6237019/SRR6237019.fastq.gz -o ${datadir}/SRR6237019_chitin_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/000/SRR6237020/SRR6237020.fastq.gz -o ${datadir}/SRR6237020_chitin_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/001/SRR6237021/SRR6237021.fastq.gz -o ${datadir}/SRR6237021_chitin_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/008/SRR6237038/SRR6237038.fastq.gz -o ${datadir}/SRR6237038_chitin_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/001/SRR6237041/SRR6237041.fastq.gz -o ${datadir}/SRR6237041_chitin_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/000/SRR6237040/SRR6237040.fastq.gz -o ${datadir}/SRR6237040_chitin_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/005/SRR6237045/SRR6237045.fastq.gz -o ${datadir}/SRR6237045_chitin_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/004/SRR6237044/SRR6237044.fastq.gz -o ${datadir}/SRR6237044_chitin_6_h_replicate2.fastq.gz
curl -L ${ENAftp}/001/SRR6237031/SRR6237031.fastq.gz -o ${datadir}/SRR6237031_chitin_6_h_replicate3.fastq.gz

#Fin du script

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This
work is licensed under a
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative
Commons Attribution 4.0 International License</a>.

Données et mise en place
------------------------

*Dans ce document, les commandes de chargement des modules
d’environnement correspondent au cluster de l’IFBcore
(`core.cluster.france-bioinformatique.fr`).  
Si vous utilisez une autre plateforme de bioinformatique, il faudra
adapter ces commandes, voire installer vous même les logiciels
nécessaires aux analyses.  
Si vous êtes amenés à installer des logiciels, je vous suggère vivement
d’utiliser [conda](https://conda.io/en/latest/index.html) et le canal
[bioconda](https://bioconda.github.io/) dédié à la bioinformatique*  
</br>

### Présentation des données

Les données que nous analyserons sont disponibles sur **Gene Expression
Omnibus** ([GEO](https://www.ncbi.nlm.nih.gov/geo/)) sous l’identifiant
[GSE112441](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE112441)
et sont issues de (Yu et al., 2019).  
Dans ce travail, nous avons généré des plantes d’*Arabidopsis thaliana*
mutantes pour 3 gènes appelés **BORDER** et nous avons comparé le
transcriptome de ces plantes à des plantes de type sauvage (même génome
mais non mutées) par [RNA-seq](https://en.wikipedia.org/wiki/RNA-Seq).
Les deux extrémités des fragments d’ADNc ont été séquencés. On parle de
séquençage *paired-end*.  
Dans deux publications, nous avons analysés les ARN dont l’abondance est
**diminuée** chez les plantes mutantes par rapport aux plantes contrôles
(Yu et al., 2019) et les ARN dont l’abondance est **augmentée** dans les
plantes mutantes (Yu et al., 2021).  
L’étude porte également sur d’autres génotypes (*fpa*, *bdr1*, *bdr2* et
*bdr3*) mais nous n’analyserons que les données correspondant aux
triples mutants (*bdrs* = *bdr1,2,3*) et aux plantes contrôles non
mutées (*WT*).

[GEO](https://www.ncbi.nlm.nih.gov/geo/) est une base de données
publique dédiée aux données de génomique. Elle est étroitement connectée
avec la **Short Read Archive**
([SRA](https://www.ncbi.nlm.nih.gov/sra)), une base de données
spécifiquement dédiée aux données de séquençage à haut-débit.  
Certaines données apparaissent donc à la fois dans **GEO** et dans
**SRA** mais il arrive aussi que des données ne soient disponibles que
dans l’une de ces deux sources.  
L’**European Nucleotide Archive** ([ENA](https://www.ebi.ac.uk/ena))
stocke une copie de la plupart des données présentes dans
[SRA](https://www.ncbi.nlm.nih.gov/sra). Depuis la France, c’est un site
de choix pour télécharger des données.

### Préparation des dossiers pour les analyses

#### Dossiers utilisés:

On commence par préparer les dossiers dans lesquels les analyses seront
effectuée.  
Notre dossier partagé pour la formation est :

``` bash
formdir="/shared/projects/form_2022_07"
```

Le dossier où nous analyserons les données:

``` bash
workdir="${formdir}"/TD_RNAseq
```

Création des différents dossiers que nous utiliserons pour les analyses
:

``` bash
# données :
datadir="${workdir}"/data
mkdir -p $datadir

# génome :
bankdir="${workdir}"/bank
mkdir -p $bankdir

# scripts :
scriptdir="${workdir}"/scripts
mkdir -p $scriptdir

# log :
logdir="${workdir}"/log
mkdir -p $logdir
```

#### Mise en place de votre session:

Si vous souhaitez reproduire les analyses de ce document, vous pouvez
créer un dossier personnel contenant des liens vers les dossiers
`datadir` et `bankdir` :

``` bash
mkdir -p "${formdir}"/${USER}
mkdir -p "${formdir}"/${USER}/log
mkdir -p "${formdir}"/${USER}/scripts
ln -s $datadir "${formdir}"/data
ln -s $bankdir "${formdir}"/bank
```

### Téléchargement des données

> Les données ont déjà été téléchargées. Vous n’avez donc pas à lancer
> les commandes présentées dans ce paragraphe.

Il y a plusieurs manières de récupérer les liens permettant de
télécharger les données brutes d’une étude. Ici, on peut par exemple
rechercher l’identifiant **SRA** de l’étude
([SRP136640](https://trace.ncbi.nlm.nih.gov/Traces/sra/?study=SRP136640))
dans l’outil [sra-explorer](https://sra-explorer.info/) qui génèrera un
script permattant de télécharger les données brutes depuis
l’[ENA](https://www.ebi.ac.uk/ena).

Le RNA-seq étant *paired-end*, on récupère 2 fichiers de données brutes
pour chaque échantillon.

``` bash
#création du dossier si il n'existe pas
mkdir -p $datadir

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
```

Les fichiers téléchargés sont des fichiers compressés (*.gz*) de données
brutes au format [fastq](https://fr.wikipedia.org/wiki/FASTQ) (extension
*.fastq* ou bien *.fq*).  
Le nom [fastq](https://fr.wikipedia.org/wiki/FASTQ) provient de
[**FASTA**](https://fr.wikipedia.org/wiki/FASTA_(format_de_fichier)) +
**QUAL**.  
Un fichier
[FASTA](https://fr.wikipedia.org/wiki/FASTA_(format_de_fichier))
contient des séquences:

![](img/FastaFormat.png)

Un fichier **QUAL** contient les [Score de qualité
Phred](https://fr.wikipedia.org/wiki/Score_de_qualit%C3%A9_phred) de
chaque nucléotide codés à l’aide du code
[ASCII](https://fr.wikipedia.org/wiki/American_Standard_Code_for_Information_Interchange).

![](img/PhredScore.png)

Donc, un fichier **fastq** regroupe ces deux informations: la
**séquence** et la **qualité** de chaque nucléotide de la séquence.
Chaque **séquence** ou *read* est codé sur 4 lignes:

![](img/FastqFormat.png)

Ces fichiers sont décompressés à l’aide de la commande :

``` bash
gunzip $datadir/*.fastq.gz
```

**Il n’est pas toujours obligatoire de décompresser les fichiers de
données brutes. De nombreux outils acceptent directement les fichiers
compressés**

### Génome, annotations et indexage

References
----------

Yu, X., Martin, P.G.P., and Michaels, S.D. (2019). BORDER proteins
protect expression of neighboring genes by promoting 3’ Pol II pausing
in plants. Nat Commun *10*, 4359.

Yu, X., Martin, P.G.P., Zhang, Y., Trinidad, J.C., Xu, F., Huang, J.,
Thum, K.E., Li, K., Zhao, S., Gu, Y., et al. (2021). The BORDER family
of negative transcription elongation factors regulates flowering time in
Arabidopsis. Curr Biol *31*, 5377–5384.
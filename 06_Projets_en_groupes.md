<!-- convert to md using 
      rmarkdown::render("06_Projets_en_groupes.Rmd", 
                        rmarkdown::md_document(variant = "markdown_github"), 
                        output_file="06_Projets_en_groupes.md") -->
Introduction: BORDER-regulated defense genes (**BDRG**)
-------------------------------------------------------

Au cours de l’analyse des données
[GSE112441](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE112441)
nous avons identifié des gènes dont l’expression est augmentée chez les
plantes *bdr1,2,3*, mutantes pour les 3 protéines BORDER, par rapport
aux plantes contrôles de type sauvage *WT*.

Nous pouvons récupérér la liste de ces gènes ainsi:

``` r
# srun --time=04:00:00 --cpus-per-task=2 --mem-per-cpu=8G --pty bash
# module load r/4.1.1
# R

# définir le répertoire de travail
projPath <- "/shared/projects/form_2022_07/TD_RNAseq/results/RData" 
setwd(projPath)

# chargement des packages
library(DESeq2)

#Résultats de l'analyse différentielle (DESeq2)
restab <- readRDS("DESeq2res.rds")

#noms des gènes uprégulés
upgn <- restab %>% 
          as.data.frame() %>%
          dplyr::filter(padj < 0.05, log2FoldChange > 0) %>%
          rownames
```

Nous avons également identifié que beaucoup de ces gènes sont impliqués
dans des fonctions liées aux systèmes de défense de l’organisme, à la
fois contre des stress biotiques (bactéries, champignons) et contre des
stress abiotiques (hypoxie en particulier).

Nous pouvons récupérer les résultats des analyses d’enrichissement
ainsi:

``` r
# Répertoire de travail
projPath <- "/shared/projects/form_2022_07/TD_RNAseq/results/RData" 
setwd(projPath)

#Librairies
library(clusterProfiler)
library(dplyr)

# Ensemble des résultats
ego <- readRDS("EnrichGOBP_upregulatedGenes.rds")

#récupération des annotations GO BP significatives (50 termes GO)
go_id = ego@result %>% 
  dplyr::filter(p.adjust < 0.001) %>% 
  dplyr::pull(ID)
```

Parmi les catégories GO, nous aimerions savoir lesquelles sont vraiment
liées aux mécanismes de défense.  
Pour récupérer les termes GO associées aux catégories significatives:

``` r
#librairie
library(GO.db)

go_id_terms <- AnnotationDbi::select(GO.db, go_id, "TERM")  
```

Voici la liste de tous les termes GO significatifs
<table class="table table-striped" style="font-size: 12px; width: auto !important; margin-left: auto; margin-right: auto;">
<caption style="font-size: initial !important;">
Termes GO BP enrichis dans les gènes uprégulés
</caption>
<thead>
<tr>
<th style="text-align:left;">
GOID
</th>
<th style="text-align:center;">
TERM
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
GO:0009620
</td>
<td style="text-align:center;">
response to fungus
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0042742
</td>
<td style="text-align:center;">
defense response to bacterium
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0050832
</td>
<td style="text-align:center;">
defense response to fungus
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0019748
</td>
<td style="text-align:center;">
secondary metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0071456
</td>
<td style="text-align:center;">
cellular response to hypoxia
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0009611
</td>
<td style="text-align:center;">
response to wounding
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0036294
</td>
<td style="text-align:center;">
cellular response to decreased oxygen levels
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0071453
</td>
<td style="text-align:center;">
cellular response to oxygen levels
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0006979
</td>
<td style="text-align:center;">
response to oxidative stress
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0001666
</td>
<td style="text-align:center;">
response to hypoxia
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0036293
</td>
<td style="text-align:center;">
response to decreased oxygen levels
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0070482
</td>
<td style="text-align:center;">
response to oxygen levels
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0044550
</td>
<td style="text-align:center;">
secondary metabolite biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0016143
</td>
<td style="text-align:center;">
S-glycoside metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0019757
</td>
<td style="text-align:center;">
glycosinolate metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0019760
</td>
<td style="text-align:center;">
glucosinolate metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0006790
</td>
<td style="text-align:center;">
sulfur compound metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0010200
</td>
<td style="text-align:center;">
response to chitin
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0009404
</td>
<td style="text-align:center;">
toxin metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0044272
</td>
<td style="text-align:center;">
sulfur compound biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0016144
</td>
<td style="text-align:center;">
S-glycoside biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0019758
</td>
<td style="text-align:center;">
glycosinolate biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0019761
</td>
<td style="text-align:center;">
glucosinolate biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0010243
</td>
<td style="text-align:center;">
response to organonitrogen compound
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0009627
</td>
<td style="text-align:center;">
systemic acquired resistance
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0002239
</td>
<td style="text-align:center;">
response to oomycetes
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0010120
</td>
<td style="text-align:center;">
camalexin biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0052317
</td>
<td style="text-align:center;">
camalexin metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0042430
</td>
<td style="text-align:center;">
indole-containing compound metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0009403
</td>
<td style="text-align:center;">
toxin biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0009700
</td>
<td style="text-align:center;">
indole phytoalexin biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0046217
</td>
<td style="text-align:center;">
indole phytoalexin metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0052314
</td>
<td style="text-align:center;">
phytoalexin metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0052315
</td>
<td style="text-align:center;">
phytoalexin biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:1901698
</td>
<td style="text-align:center;">
response to nitrogen compound
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:1901659
</td>
<td style="text-align:center;">
glycosyl compound biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:1901657
</td>
<td style="text-align:center;">
glycosyl compound metabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0009682
</td>
<td style="text-align:center;">
induced systemic resistance
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0045087
</td>
<td style="text-align:center;">
innate immune response
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0002376
</td>
<td style="text-align:center;">
immune system process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0042435
</td>
<td style="text-align:center;">
indole-containing compound biosynthetic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0006955
</td>
<td style="text-align:center;">
immune response
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0031347
</td>
<td style="text-align:center;">
regulation of defense response
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0002831
</td>
<td style="text-align:center;">
regulation of response to biotic stimulus
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0009751
</td>
<td style="text-align:center;">
response to salicylic acid
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0032101
</td>
<td style="text-align:center;">
regulation of response to external stimulus
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0016998
</td>
<td style="text-align:center;">
cell wall macromolecule catabolic process
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0002221
</td>
<td style="text-align:center;">
pattern recognition receptor signaling pathway
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0012501
</td>
<td style="text-align:center;">
programmed cell death
</td>
</tr>
<tr>
<td style="text-align:left;">
GO:0009753
</td>
<td style="text-align:center;">
response to jasmonic acid
</td>
</tr>
</tbody>
</table>
Parmi ces termes, nous sélectionnons ceux que l’on estime relever de ces
réponses de défense:

``` r
defres <- c("GO:0009620", "GO:0042742", "GO:0050832", "GO:0071456", 
            "GO:0009611", "GO:0036294", "GO:0071453", "GO:0006979", 
            "GO:0001666", "GO:0036293", "GO:0070482", "GO:0010200",
            "GO:0009627", "GO:0002239", "GO:0009682", "GO:0045087", 
            "GO:0002376", "GO:0006955", "GO:0031347", "GO:0002831", 
            "GO:0009751", "GO:0032101", "GO:0002221", "GO:0009753")
```

Les liens entre les gènes et les catégories GO sont disponibles dans
`ego@geneSets` qui est une liste dont chaque élément correspond à un
terme GO et contient un vecteur des noms de gènes annotés avec ce
terme.  
On récupère donc les identifiants de tous les gènes annotés avec les
termes `defres` :

``` r
defres_genes_all <- unique(unlist(ego@geneSets[defres], use.names = FALSE))
```

Puis on filtre pour ne retenir que les gènes uprégulés dans notre
expérience:

``` r
defres_genes_up <- intersect(upgn, defres_genes_all)
```

<br>

Voici la liste des 135 gènes contenus dans `defres_genes_up` et leurs
symboles : <br>

<style>
.table>tbody>tr>td{
  padding: 1px;
}
</style>
<table class="table" style="font-size: 9px; width: auto !important; float: left; margin-right: 10px;">
<thead>
<tr>
<th style="text-align:left;">
\#
</th>
<th style="text-align:center;">
TAIR
</th>
<th style="text-align:center;">
SYMBOLS
</th>
<th style="text-align:left;">
log2FC
</th>
<th style="text-align:left;">
padj
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
1
</td>
<td style="text-align:center;">
AT1G02360
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.82
</td>
<td style="text-align:left;">
2.5e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
2
</td>
<td style="text-align:center;">
AT1G02920
</td>
<td style="text-align:center;">
ATGST11,ATGSTF7,ATGSTF8,GST11,GSTF7
</td>
<td style="text-align:left;">
1.96
</td>
<td style="text-align:left;">
2.0e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
3
</td>
<td style="text-align:center;">
AT1G02930
</td>
<td style="text-align:center;">
ATGST1,ATGSTF3,ATGSTF6,ERD11,GST1,GSTF6
</td>
<td style="text-align:left;">
2.23
</td>
<td style="text-align:left;">
2.3e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
4
</td>
<td style="text-align:center;">
AT1G06160
</td>
<td style="text-align:center;">
ERF59,ORA59
</td>
<td style="text-align:left;">
2.03
</td>
<td style="text-align:left;">
4.5e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
5
</td>
<td style="text-align:center;">
AT1G14370
</td>
<td style="text-align:center;">
APK2A,Kin1,PBL2
</td>
<td style="text-align:left;">
0.90
</td>
<td style="text-align:left;">
2.3e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
6
</td>
<td style="text-align:center;">
AT1G14540
</td>
<td style="text-align:center;">
PER4,PRX4
</td>
<td style="text-align:left;">
2.03
</td>
<td style="text-align:left;">
9.0e-07
</td>
</tr>
<tr>
<td style="text-align:left;">
7
</td>
<td style="text-align:center;">
AT1G14870
</td>
<td style="text-align:center;">
AtPCR2,PCR2
</td>
<td style="text-align:left;">
0.83
</td>
<td style="text-align:left;">
1.1e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
8
</td>
<td style="text-align:center;">
AT1G17420
</td>
<td style="text-align:center;">
ATLOX3,LOX3
</td>
<td style="text-align:left;">
1.30
</td>
<td style="text-align:left;">
1.2e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
9
</td>
<td style="text-align:center;">
AT1G19250
</td>
<td style="text-align:center;">
FMO1
</td>
<td style="text-align:left;">
2.07
</td>
<td style="text-align:left;">
4.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
10
</td>
<td style="text-align:center;">
AT1G21110
</td>
<td style="text-align:center;">
IGMT3
</td>
<td style="text-align:left;">
1.38
</td>
<td style="text-align:left;">
1.0e-07
</td>
</tr>
<tr>
<td style="text-align:left;">
11
</td>
<td style="text-align:center;">
AT1G21120
</td>
<td style="text-align:center;">
IGMT2
</td>
<td style="text-align:left;">
2.40
</td>
<td style="text-align:left;">
0.0e+00
</td>
</tr>
<tr>
<td style="text-align:left;">
12
</td>
<td style="text-align:center;">
AT1G26380
</td>
<td style="text-align:center;">
AtBBE3,FOX,FOX1
</td>
<td style="text-align:left;">
2.83
</td>
<td style="text-align:left;">
6.2e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
13
</td>
<td style="text-align:center;">
AT1G26410
</td>
<td style="text-align:center;">
AtBBE6
</td>
<td style="text-align:left;">
2.36
</td>
<td style="text-align:left;">
1.0e-07
</td>
</tr>
<tr>
<td style="text-align:left;">
14
</td>
<td style="text-align:center;">
AT1G27730
</td>
<td style="text-align:center;">
STZ,ZAT10
</td>
<td style="text-align:left;">
1.98
</td>
<td style="text-align:left;">
3.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
15
</td>
<td style="text-align:center;">
AT1G28480
</td>
<td style="text-align:center;">
GRX480,GRXC9,ROXY19
</td>
<td style="text-align:left;">
1.44
</td>
<td style="text-align:left;">
3.0e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
16
</td>
<td style="text-align:center;">
AT1G32928
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.83
</td>
<td style="text-align:left;">
2.2e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
17
</td>
<td style="text-align:center;">
AT1G32960
</td>
<td style="text-align:center;">
ATSBT3.3,SBT3.3
</td>
<td style="text-align:left;">
4.82
</td>
<td style="text-align:left;">
3.0e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
18
</td>
<td style="text-align:center;">
AT1G51800
</td>
<td style="text-align:center;">
IOS1
</td>
<td style="text-align:left;">
1.65
</td>
<td style="text-align:left;">
1.0e-07
</td>
</tr>
<tr>
<td style="text-align:left;">
19
</td>
<td style="text-align:center;">
AT1G51890
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.84
</td>
<td style="text-align:left;">
2.1e-05
</td>
</tr>
<tr>
<td style="text-align:left;">
20
</td>
<td style="text-align:center;">
AT1G52030
</td>
<td style="text-align:center;">
F-ATMBP,MBP1.2,MBP2
</td>
<td style="text-align:left;">
1.50
</td>
<td style="text-align:left;">
1.2e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
21
</td>
<td style="text-align:center;">
AT1G52200
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.09
</td>
<td style="text-align:left;">
1.3e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
22
</td>
<td style="text-align:center;">
AT1G55020
</td>
<td style="text-align:center;">
ATLOX1,LOX1
</td>
<td style="text-align:left;">
0.74
</td>
<td style="text-align:left;">
4.0e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
23
</td>
<td style="text-align:center;">
AT1G59870
</td>
<td style="text-align:center;">
ABCG36,ATABCG36,ATPDR8,PDR8,PEN3
</td>
<td style="text-align:left;">
0.87
</td>
<td style="text-align:left;">
1.9e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
24
</td>
<td style="text-align:center;">
AT1G66700
</td>
<td style="text-align:center;">
PXMT1
</td>
<td style="text-align:left;">
2.36
</td>
<td style="text-align:left;">
2.0e-07
</td>
</tr>
<tr>
<td style="text-align:left;">
25
</td>
<td style="text-align:center;">
AT1G72060
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.06
</td>
<td style="text-align:left;">
1.2e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
26
</td>
<td style="text-align:center;">
AT1G72520
</td>
<td style="text-align:center;">
ATLOX4,LOX4
</td>
<td style="text-align:left;">
1.55
</td>
<td style="text-align:left;">
6.5e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
27
</td>
<td style="text-align:center;">
AT1G74930
</td>
<td style="text-align:center;">
ORA47
</td>
<td style="text-align:left;">
3.25
</td>
<td style="text-align:left;">
6.7e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
28
</td>
<td style="text-align:center;">
AT1G80840
</td>
<td style="text-align:center;">
ATWRKY40,WRKY40
</td>
<td style="text-align:left;">
1.88
</td>
<td style="text-align:left;">
2.0e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
29
</td>
<td style="text-align:center;">
AT2G02930
</td>
<td style="text-align:center;">
ATGSTF3,GST16,GSTF3
</td>
<td style="text-align:left;">
1.64
</td>
<td style="text-align:left;">
2.0e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
30
</td>
<td style="text-align:center;">
AT2G05520
</td>
<td style="text-align:center;">
ATGRP-3,ATGRP3,GRP-3,GRP3
</td>
<td style="text-align:left;">
0.59
</td>
<td style="text-align:left;">
1.5e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
31
</td>
<td style="text-align:center;">
AT2G18150
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.59
</td>
<td style="text-align:left;">
5.3e-05
</td>
</tr>
<tr>
<td style="text-align:left;">
32
</td>
<td style="text-align:center;">
AT2G19190
</td>
<td style="text-align:center;">
FRK1,SIRK
</td>
<td style="text-align:left;">
3.17
</td>
<td style="text-align:left;">
5.4e-05
</td>
</tr>
<tr>
<td style="text-align:left;">
33
</td>
<td style="text-align:center;">
AT2G21640
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
3.17
</td>
<td style="text-align:left;">
1.8e-06
</td>
</tr>
<tr>
<td style="text-align:left;">
34
</td>
<td style="text-align:center;">
AT2G22500
</td>
<td style="text-align:center;">
ATPUMP5,DIC1,UCP5
</td>
<td style="text-align:left;">
0.92
</td>
<td style="text-align:left;">
6.4e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
35
</td>
<td style="text-align:center;">
AT2G23270
</td>
<td style="text-align:center;">
PIP3,prePIP3
</td>
<td style="text-align:left;">
2.21
</td>
<td style="text-align:left;">
6.4e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
36
</td>
<td style="text-align:center;">
AT2G25000
</td>
<td style="text-align:center;">
ATWRKY60,WRKY60
</td>
<td style="text-align:left;">
1.13
</td>
<td style="text-align:left;">
8.7e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
37
</td>
<td style="text-align:center;">
AT2G29350
</td>
<td style="text-align:center;">
SAG13
</td>
<td style="text-align:left;">
3.65
</td>
<td style="text-align:left;">
3.9e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
38
</td>
<td style="text-align:center;">
AT2G30750
</td>
<td style="text-align:center;">
CYP71A12
</td>
<td style="text-align:left;">
3.27
</td>
<td style="text-align:left;">
2.6e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
39
</td>
<td style="text-align:center;">
AT2G30770
</td>
<td style="text-align:center;">
CYP71A13
</td>
<td style="text-align:left;">
3.94
</td>
<td style="text-align:left;">
1.6e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
40
</td>
<td style="text-align:center;">
AT2G31865
</td>
<td style="text-align:center;">
atPARG2,PARG2
</td>
<td style="text-align:left;">
0.90
</td>
<td style="text-align:left;">
1.8e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
41
</td>
<td style="text-align:center;">
AT2G32210
</td>
<td style="text-align:center;">
AthCYSTM6
</td>
<td style="text-align:left;">
1.02
</td>
<td style="text-align:left;">
3.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
42
</td>
<td style="text-align:center;">
AT2G35930
</td>
<td style="text-align:center;">
AtPUB23,PUB23
</td>
<td style="text-align:left;">
0.78
</td>
<td style="text-align:left;">
2.1e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
43
</td>
<td style="text-align:center;">
AT2G37130
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.59
</td>
<td style="text-align:left;">
4.5e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
44
</td>
<td style="text-align:center;">
AT2G38380
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.57
</td>
<td style="text-align:left;">
1.6e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
45
</td>
<td style="text-align:center;">
AT2G38470
</td>
<td style="text-align:center;">
ATWRKY33,WRKY33
</td>
<td style="text-align:left;">
0.89
</td>
<td style="text-align:left;">
1.0e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
46
</td>
<td style="text-align:center;">
AT2G38870
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.91
</td>
<td style="text-align:left;">
2.0e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
47
</td>
<td style="text-align:center;">
AT2G39210
</td>
<td style="text-align:center;">
PIC30
</td>
<td style="text-align:left;">
1.02
</td>
<td style="text-align:left;">
2.6e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
48
</td>
<td style="text-align:center;">
AT2G41010
</td>
<td style="text-align:center;">
ATCAMBP25,CAMBP25
</td>
<td style="text-align:left;">
0.72
</td>
<td style="text-align:left;">
2.1e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
49
</td>
<td style="text-align:center;">
AT2G41100
</td>
<td style="text-align:center;">
ATCAL4,CML12,TCH3
</td>
<td style="text-align:left;">
0.74
</td>
<td style="text-align:left;">
4.5e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
50
</td>
<td style="text-align:center;">
AT2G43570
</td>
<td style="text-align:center;">
CHI
</td>
<td style="text-align:left;">
1.77
</td>
<td style="text-align:left;">
0.0e+00
</td>
</tr>
<tr>
<td style="text-align:left;">
51
</td>
<td style="text-align:center;">
AT2G45220
</td>
<td style="text-align:center;">
AtPME17,PME17
</td>
<td style="text-align:left;">
1.23
</td>
<td style="text-align:left;">
1.1e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
52
</td>
<td style="text-align:center;">
AT3G01290
</td>
<td style="text-align:center;">
AtHIR2,HIR2
</td>
<td style="text-align:left;">
0.71
</td>
<td style="text-align:left;">
5.9e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
53
</td>
<td style="text-align:center;">
AT3G04720
</td>
<td style="text-align:center;">
AtPR4,HEL,PR-4,PR4
</td>
<td style="text-align:left;">
0.83
</td>
<td style="text-align:left;">
3.0e-05
</td>
</tr>
<tr>
<td style="text-align:left;">
54
</td>
<td style="text-align:center;">
AT3G09940
</td>
<td style="text-align:center;">
AtMDAR3,MDAR3
</td>
<td style="text-align:left;">
1.00
</td>
<td style="text-align:left;">
8.4e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
55
</td>
<td style="text-align:center;">
AT3G10930
</td>
<td style="text-align:center;">
IDL7
</td>
<td style="text-align:left;">
1.51
</td>
<td style="text-align:left;">
3.0e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
56
</td>
<td style="text-align:center;">
AT3G12500
</td>
<td style="text-align:center;">
ATHCHIB,B-CHI,CHI-B,HCHIB,PR-3,PR3
</td>
<td style="text-align:left;">
0.99
</td>
<td style="text-align:left;">
1.1e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
57
</td>
<td style="text-align:center;">
AT3G13610
</td>
<td style="text-align:center;">
F6’H1
</td>
<td style="text-align:left;">
1.39
</td>
<td style="text-align:left;">
1.2e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
58
</td>
<td style="text-align:center;">
AT3G13790
</td>
<td style="text-align:center;">
ATBFRUCT1,AtCWI1,ATCWINV1,CWI1
</td>
<td style="text-align:left;">
0.68
</td>
<td style="text-align:left;">
1.7e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
59
</td>
<td style="text-align:center;">
AT3G14840
</td>
<td style="text-align:center;">
LIK1
</td>
<td style="text-align:left;">
0.62
</td>
<td style="text-align:left;">
2.1e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
60
</td>
<td style="text-align:center;">
AT3G16530
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.29
</td>
<td style="text-align:left;">
2.8e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
61
</td>
<td style="text-align:center;">
AT3G16770
</td>
<td style="text-align:center;">
ATEBP,EBP,ERF72,RAP2.3
</td>
<td style="text-align:left;">
0.67
</td>
<td style="text-align:left;">
2.0e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
62
</td>
<td style="text-align:center;">
AT3G17980
</td>
<td style="text-align:center;">
AtC2,AtGAP1,C2,CAR4
</td>
<td style="text-align:left;">
3.52
</td>
<td style="text-align:left;">
3.3e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
63
</td>
<td style="text-align:center;">
AT3G19710
</td>
<td style="text-align:center;">
BCAT4
</td>
<td style="text-align:left;">
0.83
</td>
<td style="text-align:left;">
2.1e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
64
</td>
<td style="text-align:center;">
AT3G20470
</td>
<td style="text-align:center;">
ATGRP-5,ATGRP5,GRP-5,GRP5
</td>
<td style="text-align:left;">
0.64
</td>
<td style="text-align:left;">
2.6e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
65
</td>
<td style="text-align:center;">
AT3G23250
</td>
<td style="text-align:center;">
ATMYB15,ATY19,MYB15
</td>
<td style="text-align:left;">
3.36
</td>
<td style="text-align:left;">
2.9e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
66
</td>
<td style="text-align:center;">
AT3G25250
</td>
<td style="text-align:center;">
AGC2,AGC2-1,AtOXI1,OXI1
</td>
<td style="text-align:left;">
1.37
</td>
<td style="text-align:left;">
1.9e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
67
</td>
<td style="text-align:center;">
AT3G25780
</td>
<td style="text-align:center;">
AOC3
</td>
<td style="text-align:left;">
0.92
</td>
<td style="text-align:left;">
9.4e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
68
</td>
<td style="text-align:center;">
AT3G26830
</td>
<td style="text-align:center;">
CYP71B15,PAD3
</td>
<td style="text-align:left;">
1.66
</td>
<td style="text-align:left;">
3.1e-02
</td>
</tr>
</tbody>
</table>
<table class="table" style="font-size: 9px; width: auto !important; margin-right: 0; margin-left: auto">
<thead>
<tr>
<th style="text-align:left;">
\#
</th>
<th style="text-align:center;">
TAIR
</th>
<th style="text-align:center;">
SYMBOLS
</th>
<th style="text-align:left;">
log2FC
</th>
<th style="text-align:left;">
padj
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
69
</td>
<td style="text-align:center;">
AT3G28580
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
2.52
</td>
<td style="text-align:left;">
1.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
70
</td>
<td style="text-align:center;">
AT3G44260
</td>
<td style="text-align:center;">
AtCAF1a,CAF1a
</td>
<td style="text-align:left;">
2.05
</td>
<td style="text-align:left;">
4.6e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
71
</td>
<td style="text-align:center;">
AT3G49110
</td>
<td style="text-align:center;">
ATPCA,ATPRX33,PRX33,PRXCA
</td>
<td style="text-align:left;">
1.16
</td>
<td style="text-align:left;">
1.5e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
72
</td>
<td style="text-align:center;">
AT3G49120
</td>
<td style="text-align:center;">
ATPCB,ATPERX34,AtPRX34,PERX34,PRX34,PRXCB
</td>
<td style="text-align:left;">
0.74
</td>
<td style="text-align:left;">
1.3e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
73
</td>
<td style="text-align:center;">
AT3G49960
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.80
</td>
<td style="text-align:left;">
6.7e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
74
</td>
<td style="text-align:center;">
AT3G50480
</td>
<td style="text-align:center;">
HR4
</td>
<td style="text-align:left;">
1.84
</td>
<td style="text-align:left;">
1.0e-05
</td>
</tr>
<tr>
<td style="text-align:left;">
75
</td>
<td style="text-align:center;">
AT3G52400
</td>
<td style="text-align:center;">
ATSYP122,SYP122
</td>
<td style="text-align:left;">
0.58
</td>
<td style="text-align:left;">
3.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
76
</td>
<td style="text-align:center;">
AT3G54150
</td>
<td style="text-align:center;">
EFD
</td>
<td style="text-align:left;">
2.02
</td>
<td style="text-align:left;">
7.3e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
77
</td>
<td style="text-align:center;">
AT3G54420
</td>
<td style="text-align:center;">
ATCHITIV,ATEP3,CHIV,EP3
</td>
<td style="text-align:left;">
1.04
</td>
<td style="text-align:left;">
3.1e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
78
</td>
<td style="text-align:center;">
AT3G56400
</td>
<td style="text-align:center;">
ATWRKY70,WRKY70
</td>
<td style="text-align:left;">
2.01
</td>
<td style="text-align:left;">
2.0e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
79
</td>
<td style="text-align:center;">
AT3G56880
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.76
</td>
<td style="text-align:left;">
3.1e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
80
</td>
<td style="text-align:center;">
AT3G57330
</td>
<td style="text-align:center;">
ACA11
</td>
<td style="text-align:left;">
0.49
</td>
<td style="text-align:left;">
4.2e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
81
</td>
<td style="text-align:center;">
AT3G62600
</td>
<td style="text-align:center;">
ATERDJ3B,ERDJ3B
</td>
<td style="text-align:left;">
0.64
</td>
<td style="text-align:left;">
4.1e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
82
</td>
<td style="text-align:center;">
AT4G05200
</td>
<td style="text-align:center;">
CRK25
</td>
<td style="text-align:left;">
0.78
</td>
<td style="text-align:left;">
1.6e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
83
</td>
<td style="text-align:center;">
AT4G08770
</td>
<td style="text-align:center;">
Prx37
</td>
<td style="text-align:left;">
1.23
</td>
<td style="text-align:left;">
2.1e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
84
</td>
<td style="text-align:center;">
AT4G10500
</td>
<td style="text-align:center;">
DLO1
</td>
<td style="text-align:left;">
1.51
</td>
<td style="text-align:left;">
3.0e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
85
</td>
<td style="text-align:center;">
AT4G11650
</td>
<td style="text-align:center;">
ATOSM34,OSM34
</td>
<td style="text-align:left;">
2.02
</td>
<td style="text-align:left;">
0.0e+00
</td>
</tr>
<tr>
<td style="text-align:left;">
86
</td>
<td style="text-align:center;">
AT4G12470
</td>
<td style="text-align:center;">
AZI1
</td>
<td style="text-align:left;">
1.34
</td>
<td style="text-align:left;">
0.0e+00
</td>
</tr>
<tr>
<td style="text-align:left;">
87
</td>
<td style="text-align:center;">
AT4G12480
</td>
<td style="text-align:center;">
EARLI1,pEARLI
</td>
<td style="text-align:left;">
2.05
</td>
<td style="text-align:left;">
0.0e+00
</td>
</tr>
<tr>
<td style="text-align:left;">
88
</td>
<td style="text-align:center;">
AT4G12490
</td>
<td style="text-align:center;">
AZI3
</td>
<td style="text-align:left;">
2.53
</td>
<td style="text-align:left;">
4.3e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
89
</td>
<td style="text-align:center;">
AT4G13395
</td>
<td style="text-align:center;">
DVL10,RTFL12
</td>
<td style="text-align:left;">
2.76
</td>
<td style="text-align:left;">
4.3e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
90
</td>
<td style="text-align:center;">
AT4G17500
</td>
<td style="text-align:center;">
AtERF\#100,ATERF-1,ERF-1,ERF1A
</td>
<td style="text-align:left;">
1.04
</td>
<td style="text-align:left;">
2.0e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
91
</td>
<td style="text-align:center;">
AT4G20140
</td>
<td style="text-align:center;">
GSO1,SGN3
</td>
<td style="text-align:left;">
0.75
</td>
<td style="text-align:left;">
8.2e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
92
</td>
<td style="text-align:center;">
AT4G21840
</td>
<td style="text-align:center;">
ATMSRB8,MSRB8
</td>
<td style="text-align:left;">
3.17
</td>
<td style="text-align:left;">
1.7e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
93
</td>
<td style="text-align:center;">
AT4G23170
</td>
<td style="text-align:center;">
CRK9,EP1
</td>
<td style="text-align:left;">
1.61
</td>
<td style="text-align:left;">
7.4e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
94
</td>
<td style="text-align:center;">
AT4G23210
</td>
<td style="text-align:center;">
CRK13
</td>
<td style="text-align:left;">
1.97
</td>
<td style="text-align:left;">
2.5e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
95
</td>
<td style="text-align:center;">
AT4G25100
</td>
<td style="text-align:center;">
ATFSD1,FSD1
</td>
<td style="text-align:left;">
0.86
</td>
<td style="text-align:left;">
1.2e-06
</td>
</tr>
<tr>
<td style="text-align:left;">
96
</td>
<td style="text-align:center;">
AT4G26010
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.64
</td>
<td style="text-align:left;">
8.2e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
97
</td>
<td style="text-align:center;">
AT4G26120
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.45
</td>
<td style="text-align:left;">
2.6e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
98
</td>
<td style="text-align:center;">
AT4G28460
</td>
<td style="text-align:center;">
PIP1,prePIP1
</td>
<td style="text-align:left;">
2.81
</td>
<td style="text-align:left;">
3.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
99
</td>
<td style="text-align:center;">
AT4G29140
</td>
<td style="text-align:center;">
ABS3,ADP1,ADS1
</td>
<td style="text-align:left;">
0.59
</td>
<td style="text-align:left;">
7.9e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
100
</td>
<td style="text-align:center;">
AT4G31970
</td>
<td style="text-align:center;">
CYP82C2
</td>
<td style="text-align:left;">
3.10
</td>
<td style="text-align:left;">
2.0e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
101
</td>
<td style="text-align:center;">
AT4G33050
</td>
<td style="text-align:center;">
AtIQM1,EDA39,IQM1
</td>
<td style="text-align:left;">
1.24
</td>
<td style="text-align:left;">
2.7e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
102
</td>
<td style="text-align:center;">
AT4G35480
</td>
<td style="text-align:center;">
ATL45,RHA3B
</td>
<td style="text-align:left;">
1.18
</td>
<td style="text-align:left;">
1.3e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
103
</td>
<td style="text-align:center;">
AT4G36430
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.17
</td>
<td style="text-align:left;">
2.6e-05
</td>
</tr>
<tr>
<td style="text-align:left;">
104
</td>
<td style="text-align:center;">
AT4G37520
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.89
</td>
<td style="text-align:left;">
1.6e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
105
</td>
<td style="text-align:center;">
AT4G37980
</td>
<td style="text-align:center;">
ATCAD7,CAD7,CHR,ELI3,ELI3-1
</td>
<td style="text-align:left;">
0.52
</td>
<td style="text-align:left;">
1.1e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
106
</td>
<td style="text-align:center;">
AT4G39830
</td>
<td style="text-align:center;">
AO
</td>
<td style="text-align:left;">
1.43
</td>
<td style="text-align:left;">
3.3e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
107
</td>
<td style="text-align:center;">
AT5G01540
</td>
<td style="text-align:center;">
LecRK-VI.2,LECRKA4.1
</td>
<td style="text-align:left;">
1.99
</td>
<td style="text-align:left;">
7.1e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
108
</td>
<td style="text-align:center;">
AT5G01560
</td>
<td style="text-align:center;">
LecRK-VI.4,LECRKA4.3
</td>
<td style="text-align:left;">
1.58
</td>
<td style="text-align:left;">
2.8e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
109
</td>
<td style="text-align:center;">
AT5G05730
</td>
<td style="text-align:center;">
AMT1,ASA1,JDL1,TRP5,WEI2
</td>
<td style="text-align:left;">
0.98
</td>
<td style="text-align:left;">
2.4e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
110
</td>
<td style="text-align:center;">
AT5G06720
</td>
<td style="text-align:center;">
ATPA2,AtPRX53,PA2,PRX53
</td>
<td style="text-align:left;">
1.38
</td>
<td style="text-align:left;">
2.3e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
111
</td>
<td style="text-align:center;">
AT5G06730
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.34
</td>
<td style="text-align:left;">
1.1e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
112
</td>
<td style="text-align:center;">
AT5G06740
</td>
<td style="text-align:center;">
LecRK-S.5
</td>
<td style="text-align:left;">
1.23
</td>
<td style="text-align:left;">
4.0e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
113
</td>
<td style="text-align:center;">
AT5G07010
</td>
<td style="text-align:center;">
ATST2A,ST2A
</td>
<td style="text-align:left;">
0.95
</td>
<td style="text-align:left;">
2.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
114
</td>
<td style="text-align:center;">
AT5G07460
</td>
<td style="text-align:center;">
ATMSRA2,PMSR2
</td>
<td style="text-align:left;">
0.71
</td>
<td style="text-align:left;">
1.3e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
115
</td>
<td style="text-align:center;">
AT5G13320
</td>
<td style="text-align:center;">
AtGH3.12,GDG1,GH3.12,PBS3,WIN3
</td>
<td style="text-align:left;">
2.22
</td>
<td style="text-align:left;">
1.0e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
116
</td>
<td style="text-align:center;">
AT5G13330
</td>
<td style="text-align:center;">
Rap2.6L
</td>
<td style="text-align:left;">
0.75
</td>
<td style="text-align:left;">
4.5e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
117
</td>
<td style="text-align:center;">
AT5G14200
</td>
<td style="text-align:center;">
ATIMD1,IMD1
</td>
<td style="text-align:left;">
0.86
</td>
<td style="text-align:left;">
2.2e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
118
</td>
<td style="text-align:center;">
AT5G17350
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.61
</td>
<td style="text-align:left;">
3.4e-05
</td>
</tr>
<tr>
<td style="text-align:left;">
119
</td>
<td style="text-align:center;">
AT5G19230
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.64
</td>
<td style="text-align:left;">
2.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
120
</td>
<td style="text-align:center;">
AT5G19240
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
0.89
</td>
<td style="text-align:left;">
1.2e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
121
</td>
<td style="text-align:center;">
AT5G22250
</td>
<td style="text-align:center;">
AtCAF1b,CAF1b
</td>
<td style="text-align:left;">
1.71
</td>
<td style="text-align:left;">
8.4e-06
</td>
</tr>
<tr>
<td style="text-align:left;">
122
</td>
<td style="text-align:center;">
AT5G25250
</td>
<td style="text-align:center;">
FLOT1
</td>
<td style="text-align:left;">
2.47
</td>
<td style="text-align:left;">
3.9e-06
</td>
</tr>
<tr>
<td style="text-align:left;">
123
</td>
<td style="text-align:center;">
AT5G26920
</td>
<td style="text-align:center;">
CBP60G
</td>
<td style="text-align:left;">
1.05
</td>
<td style="text-align:left;">
4.7e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
124
</td>
<td style="text-align:center;">
AT5G42980
</td>
<td style="text-align:center;">
ATH3,ATTRX3,ATTRXH3,TRX3,TRXH3
</td>
<td style="text-align:left;">
0.55
</td>
<td style="text-align:left;">
1.4e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
125
</td>
<td style="text-align:center;">
AT5G44585
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.52
</td>
<td style="text-align:left;">
9.3e-05
</td>
</tr>
<tr>
<td style="text-align:left;">
126
</td>
<td style="text-align:center;">
AT5G47230
</td>
<td style="text-align:center;">
ATERF-5,ATERF5,AtMACD1,ERF102,ERF5
</td>
<td style="text-align:left;">
0.98
</td>
<td style="text-align:left;">
9.3e-04
</td>
</tr>
<tr>
<td style="text-align:left;">
127
</td>
<td style="text-align:center;">
AT5G49520
</td>
<td style="text-align:center;">
ATWRKY48,WRKY48
</td>
<td style="text-align:left;">
1.17
</td>
<td style="text-align:left;">
4.7e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
128
</td>
<td style="text-align:center;">
AT5G50200
</td>
<td style="text-align:center;">
ATNRT3.1,NRT3.1,WR3
</td>
<td style="text-align:left;">
0.75
</td>
<td style="text-align:left;">
5.9e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
129
</td>
<td style="text-align:center;">
AT5G51190
</td>
<td style="text-align:center;">
ERF105
</td>
<td style="text-align:left;">
2.24
</td>
<td style="text-align:left;">
1.8e-06
</td>
</tr>
<tr>
<td style="text-align:left;">
130
</td>
<td style="text-align:center;">
AT5G52020
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
2.52
</td>
<td style="text-align:left;">
1.5e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
131
</td>
<td style="text-align:center;">
AT5G57220
</td>
<td style="text-align:center;">
CYP81F2
</td>
<td style="text-align:left;">
2.24
</td>
<td style="text-align:left;">
4.5e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
132
</td>
<td style="text-align:center;">
AT5G61890
</td>
<td style="text-align:center;">
ERF114
</td>
<td style="text-align:left;">
2.52
</td>
<td style="text-align:left;">
2.7e-02
</td>
</tr>
<tr>
<td style="text-align:left;">
133
</td>
<td style="text-align:center;">
AT5G63130
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:left;">
1.06
</td>
<td style="text-align:left;">
5.4e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
134
</td>
<td style="text-align:center;">
AT5G64120
</td>
<td style="text-align:center;">
AtPRX71,PRX71
</td>
<td style="text-align:left;">
1.91
</td>
<td style="text-align:left;">
2.1e-03
</td>
</tr>
<tr>
<td style="text-align:left;">
135
</td>
<td style="text-align:center;">
AT5G67400
</td>
<td style="text-align:center;">
RHS19
</td>
<td style="text-align:left;">
0.71
</td>
<td style="text-align:left;">
3.2e-02
</td>
</tr>
</tbody>
</table>
<br> <br>

Nous avons donc identifié un ensemble de 135 gènes impliqués dans des
mécanismes de défense contre des stress biotiques et abiotiques, en
particulier l’hypoxie ou la defense contre les bactéries et les
champignons.  
Nous allons appeler ce groupe de gènes les **BRDG** pour
**BORDER-regulated defense genes**.  
Nous souhaitons à present voir dans quelle mesure ces gènes sont
représentés (ou enrichis) et comment ils se comportent dans une
expérience publiée impliquant ce type de stress.

<br>

Présentation des données
------------------------

Nous allons travailler sur des données publiées dans un article de
[Plant J en 2018](https://pubmed.ncbi.nlm.nih.gov/29024173/) (Stringlis
et al., 2018).  
Les auteurs y analysent comment le transcriptome de racines
d’Arabidopsis thaliana est modulé en réponse à une exposition de courte
durée (*30min, 1h, 3h ou 6h*) :

1.  à une rhizobactérie bénéfique Pseudomonas simiae WCS417
    (**“rhizo”**)

à 2 peptides d’origine bactérienne qui stimulent le système immunitaire
des plantes:

1.  flg22 provenant de la rhizobactérie bénéfique Pseudomonas simiae
    WCS417 (**“flg22Psim”**)  
2.  flg22 provenant de la bactérie pathogène Pseudomonas aeruginosa
    (**“flg22Paer”**)

3.  à la chitin, d’origine fongique (**“chitin”**)

Le transcriptome racinaire de plantes contrôles (**“Control”**), non
exposées à ces stimuli, est analysé aux mêmes temps de cinétique, ainsi
qu’au temps t=0h.

Les données n’ont pas été déposées dans GEO mais on peut les récupérer
via SRA/ENA.

**Objectif :**  
Chaque groupe analysera l’un de ces 4 stimuli en le comparant aux
plantes contrôles et évaluera:

-   à chaque temps, le nombre gènes uprégulés ou downrégulés dans les
    racines de plantes exposées au stimulus par rapport aux plantes
    contrôles (DESeq2)
    -   à chaque temps le nombre et la proportion de gènes **BDRG** qui
        sont uprégulés ou downrégulés, ainsi que la significativité de
        cet enrichissement (test exact de Fisher, diagramme de Venn)
    -   pour tous les temps, une représentation des gènes **BDRG** dans
        les différents échantillons sous forme de heatmap

(OPTIONNEL)

-   à chaque temps, une analyse de l’enrichissement de catégories
    fonctionnelles parmi les gènes up- ou downrégulés

<br>

Téléchargement des données
--------------------------

Les données de l’ensemble de l’étude sont stockées dans un dossier nommé
`data_project`

``` bash
datadir="/shared/projects/form_2022_07/data_project"
ENAftp="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR623"

#Controls
curl -L ${ENAftp}/008/SRR6236998/SRR6236998.fastq.gz -o ${datadir}/SRR6236998_Control_0_h_replicate1.fastq.gz
curl -L ${ENAftp}/000/SRR6237000/SRR6237000.fastq.gz -o ${datadir}/SRR6237000_Control_0_h_replicate2.fastq.gz
curl -L ${ENAftp}/006/SRR6236996/SRR6236996.fastq.gz -o ${datadir}/SRR6236996_Control_0_h_replicate3.fastq.gz
curl -L ${ENAftp}/007/SRR6236997/SRR6236997.fastq.gz -o ${datadir}/SRR6236997_Control_0.5_h_replicate1.fastq.gz
curl -L ${ENAftp}/005/SRR6236995/SRR6236995.fastq.gz -o ${datadir}/SRR6236995_Control_0.5_h_replicate2.fastq.gz
curl -L ${ENAftp}/009/SRR6236999/SRR6236999.fastq.gz -o ${datadir}/SRR6236999_Control_0.5_h_replicate3.fastq.gz
curl -L ${ENAftp}/000/SRR6236990/SRR6236990.fastq.gz -o ${datadir}/SRR6236990_Control_1_h_replicate3.fastq.gz
curl -L ${ENAftp}/009/SRR6237009/SRR6237009.fastq.gz -o ${datadir}/SRR6237009_Control_1_h_replicate1.fastq.gz
curl -L ${ENAftp}/000/SRR6237010/SRR6237010.fastq.gz -o ${datadir}/SRR6237010_Control_1_h_replicate2.fastq.gz
curl -L ${ENAftp}/002/SRR6237022/SRR6237022.fastq.gz -o ${datadir}/SRR6237022_Control_3_h_replicate1.fastq.gz
curl -L ${ENAftp}/003/SRR6237023/SRR6237023.fastq.gz -o ${datadir}/SRR6237023_Control_3_h_replicate2.fastq.gz
curl -L ${ENAftp}/004/SRR6237024/SRR6237024.fastq.gz -o ${datadir}/SRR6237024_Control_3_h_replicate3.fastq.gz
curl -L ${ENAftp}/003/SRR6237043/SRR6237043.fastq.gz -o ${datadir}/SRR6237043_Control_6_h_replicate1.fastq.gz
curl -L ${ENAftp}/002/SRR6237042/SRR6237042.fastq.gz -o ${datadir}/SRR6237042_Control_6_h_replicate2.fastq.gz
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
```

On a créé des liens symboliques vers les données à analyser pour chacun
des groupes

<br>

Groupe 1: réponse à une rhizobactérie bénéfique
-----------------------------------------------

Les échantillons sont des triplicats biologiques de :

-   Plantes contrôles à 0h, 30min, 1h, 3h, 6h
    -   Plantes exposées à la rhizobactérie bénéfique *Pseudomonas
        simiae WCS417* à 30 min, 1h, 3h et 6h

``` bash
formdir="/shared/projects/form_2022_07"

datadir="${formdir}/data_project"
cd $datadir

destdir="${formdir}/projet_groupe1/data"
mkdir -p $destdir

# Controls
for fn in `ls SRR*_Control_*.fastq.gz`; do
  ln -s ${datadir}/${fn} ${destdir}/${fn}
done

# rhizo
for fn in `ls SRR*_rhizo_*.fastq.gz`; do
  ln -s ${datadir}/${fn} ${destdir}/${fn}
done
```

<br>

Groupe 2: réponse au peptide flg22 d’une rhizobactérie bénéfique
----------------------------------------------------------------

Le peptide flg22 (*“flg22Psim”*) provient de la rhizobactérie bénéfique
*Pseudomonas simiae WCS417*

Les échantillons sont des triplicats biologiques de :

-   Plantes contrôles (**Control**) à 0h, 30min, 1h, 3h, 6h
    -   Plantes exposées au peptide flg22 de la rhizobactérie bénéfique
        *Pseudomonas simiae WCS417* (**flg22Psim**) à 30 min, 1h, 3h et
        6h

``` bash
formdir="/shared/projects/form_2022_07"

datadir="${formdir}/data_project"
cd $datadir

destdir="${formdir}/projet_groupe2/data"
mkdir -p $destdir

# Controls
for fn in `ls SRR*_Control_*.fastq.gz`; do
  ln -s ${datadir}/${fn} ${destdir}/${fn}
done

# flg22Psim
for fn in `ls SRR*_flg22Psim_*.fastq.gz`; do
  ln -s ${oridir}/${fn} ${destdir}/${fn}
done
```

<br>

Groupe 3: réponse au peptide flg22 d’une bactérie pathogène
-----------------------------------------------------------

Le peptide flg22 (*“flg22Paer”*) provient de la bactérie pathogène
*Pseudomonas aeruginosa*

Les échantillons sont des triplicats biologiques de :

-   Plantes contrôles (**Control**) à 0h, 30min, 1h, 3h, 6h
    -   Plantes exposées au peptide flg22 de la bactérie pathogène
        *Pseudomonas aeruginosa* (**flg22Paer**) à 30 min, 1h, 3h et 6h

``` bash
formdir="/shared/projects/form_2022_07"

datadir="${formdir}/data_project"
cd $datadir

destdir="${formdir}/projet_groupe3/data"
mkdir -p $destdir

# Controls
for fn in `ls SRR*_Control_*.fastq.gz`; do
  ln -s ${datadir}/${fn} ${destdir}/${fn}
done

# flg22Paer
for fn in `ls SRR*_flg22Paer_*.fastq.gz`; do
  ln -s ${oridir}/${fn} ${destdir}/${fn}
done

```

<br>

Groupe 4: réponse à la chitine
------------------------------

Les échantillons sont des triplicats biologiques de :

-   Plantes contrôles (**Control**) à 0h, 30min, 1h, 3h, 6h
    -   Plantes exposées à la chitine (**chitin**) à 30 min, 1h, 3h et
        6h

``` bash
formdir="/shared/projects/form_2022_07"

datadir="${formdir}/data_project"
cd $datadir

destdir="${formdir}/projet_groupe3/data"
mkdir -p $destdir

# Controls
for fn in `ls SRR*_Control_*.fastq.gz`; do
  ln -s ${datadir}/${fn} ${destdir}/${fn}
done

# chitin
for fn in `ls SRR*_chitin_*.fastq.gz`; do
  ln -s ${oridir}/${fn} ${destdir}/${fn}
done

```

Références
----------

Stringlis, I.A., Proietti, S., Hickman, R., Van Verk, M.C., Zamioudis,
C., and Pieterse, C.M.J. (2018). Root transcriptional dynamics induced
by beneficial rhizobacteria and microbial immune elicitors reveal
signatures of adaptation to mutualists. Plant J *93*, 166–180.

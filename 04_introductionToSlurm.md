---
title: Introduction à SLURM
---

# Introduction

[SLURM](https://slurm.schedmd.com) est un gestionnaire de fil  ou *scheduler* en anglais. Une fois connecté au serveur frontal via `ssh` c'est via **SLURM** que nous pourrons lancer des "**jobs**", sous forme de scripts, sur le cluster de calcul.   
**SLURM** va gérer pour nous la file d'attente (i.e. quand notre job sera lancé compte tenu des autres jobs en attente et des ressources disponibles) et quelles sont les ressources qui lui seront allouées (typiquement temps, CPU, mémoire).  

![Structure Plateforme Bioinformatique](img/BioinfoPlatform_Structure.png)

Une [fiche résumée](https://slurm.schedmd.com/pdfs/summary.pdf) des commandes slurm et une [documentation complète](https://slurm.schedmd.com/man_index.html) des différentes commandes sont disponible en ligne.  
**SLURM** nous permettra également de nous connecter directement à un noeud du cluster pour y lancer des commandes de manière **interactive**, c'est à dire qu'on pourra écrire et lancer une commande et qu'elle s'exécutera immédiatement.  

<br>

# Connexion interactive  

Puisque tous les utilisateurs d'une plateforme de bioinformatique se connectent à un même serveur frontal, il est important que celui-ci ne soit pas utilisé pour lancer des calculs ou des opérations utilisant beaucoup de ressources. Sinon c'est l'embouteillage.  
Pourtant il est parfois utile de tester rapidement une commande ou de réaliser une opération lourde sur des fichiers sans forcément écrire un script dédié à cette opération.  
C'est typiquement dans ce cas qu'on souhaitera se connecter à un noeud du cluster de calcul pour pouvoir y lancer des commandes de manière interactive. Cette connexion peut se faire de la manière suivante:  

```bash
srun --pty bash
```  
Sur certains serveurs il est possible d'utiliser le [X11 forwarding](https://fr.wikipedia.org/wiki/X_Window_System) avec :  

```bash
srun --x11 --pty bash
```

Il existe de [nombreuses options](https://slurm.schedmd.com/srun.html) pour demander des ressources précises en termes de coeurs/processeurs ou [CPU](https://fr.wikipedia.org/wiki/Processeur) (la partie qui effectue les calculs) et en termes de [mémoire](https://fr.wikipedia.org/wiki/M%C3%A9moire_(informatique)) (ce qui permet de stocker des données). Certains calculs (moins fréquents) peuvent également faire appel à des processeurs graphiques ou [GPU](https://fr.wikipedia.org/wiki/Processeur_graphique).  
Les options les plus courantes sont présentées dans le paragraphe suivant et peuvent être utiliser de la même manière pour soumettre un job via un script (commande `sbatch`) ou via une session interactive (commande `srun`).  
Par exemple, la commande ci-dessous demande l'ouverture d'une session interactive de 2 heures avec 2 CPU et 16G de mémoire:  

```bash
srun --time=02:00:00 --cpus-per-task=2 --mem=16G --pty bash
```

Quand on a terminé notre travail dans une session interactive, on la quitte en entrant:  

```bash
exit
```

ou bien en utilisant le raccourci `CTRL + D`  


<br>


# Soumettre un script  

## Préparer un script  

Un script est un fichier texte qui contient les commandes que l'on souhaite exécuter.  
Les scripts que nous allons utiliser doivent toujours commencer par `#!/bin/bash` que l'on appelle le [Shebang](https://fr.wikipedia.org/wiki/Shebang) et qui précise au système le language qui est utilisé dans le script. Ici on utilisera donc [bash](https://fr.wikipedia.org/wiki/Bourne-Again_shell).  

Le fichier texte ci-dessous est un script qui renvoie le texte `Hello World`.

```bash
#!/bin/bash
echo 'Hello World'
```

On peut créer ce fichier, que l'on nomme `HelloWorld.sh` en ligne de commande de la manière suivante:

```
printf "%s\n" '#!/bin/bash' > HelloWorld.sh
printf "%s\n" "echo 'Hello World'" >> HelloWorld.sh
```

Si on vérifie la création du fichier à l'aide de la commande `ls -l`, on constate qu'on ne possède pas les droits pour exécuter ce fichier.  
Les droits sont `-rw-rw-r--`, autrement dit tout le monde peut lire le fichier (`r`), l'utilisateur et les membres du groupes peuvent écrire (`w`) dans le fichier mais personne ne peut l'exécuter (`x`).  
Le script n'est donc pas utilisable pour l'instant.  
Pour cela, on donne à l'utilisateur les droits d'exécution avec:

```bash
chmod u+x HelloWorld.sh
```

On vérifie avec la commande `ls -l` que l'on dispose bien des droits d'exécution à présent: `-rwxrw-r--`  

Comme notre script ne consomme quasiment aucune resource, on peut le lancer directement en tapant:

```
./HelloWorld.sh
```


## Soumettre le script avec `sbatch`  

## `sbatch` et les sorties

La commande [`sbatch`](https://slurm.schedmd.com/sbatch.html) est la commande qui permet de soumettre un script au cluster de calcul.  
On peut donc soumettre notre script en écrivant:  

```bash
sbatch HelloWorld.sh
```

Un identifiant `<job_id>`, sous la forme d'une série de chiffre, a été assigné à notre job.  
Une fois le job terminé, un nouveau fichier est apparu dans notre répertoire de travail: `slurm-<job_id>.out`.  
Ce fichier contient ce qu'a renvoyé notre job: `cat slurm-<job_id>.out`  

En général, il est utile de choisir où ces données sont renvoyées. On peut le faire ainsi:

```bash
sbatch --output="script_output_%j.out" HelloWorld.sh
```

`%j` sera automatiquement remplacé par le `<job_id>`. Pour les jobs arrays (voir ci-dessous), on utilisera plutôt `%A_%a` où `%A` sera remplacé par le `<job_id>`et `%a` sera remplacé par l'`<array_index>`.  

Dans certains cas, nos scripts renverront (malheureusement) des erreurs. Par défaut celles-ci seront renvoyées dans le même fichier `slurm-<job_id>.out` que précédemment. Il est utile de séparer les erreurs et les sorties d'un script dans deux fichiers distincts via:  

```bash
sbatch \
  --output="script_output_%j.out" \
  --error="script_error_%j.err" \
  HelloWorld.sh
```

*Notez l'utilisation du signe `\` en fin de ligne pour étaler une même commande sur plusieurs lignes.*

## Gestion des ressources


## Utilisation des variables d'environnement

> Paragraphe concernant une utilisation avancée

A l'intérieur d'un script, il est possible d'utiliser des [variables d'environnement](https://fr.wikipedia.org/wiki/Variable_d%27environnement) définies dans l'environnement depuis lequel on lance le job (pour nous : le serveur frontal) en les propageant à l'environnement dans lequel le script est exécuté (pour nous, sur le cluster de calcul).  
Ainsi, la variable `USER` contient notre `<username>` sur la plateforme: `echo $USER`  

On peut créer un simple script qui renvoie `Hello <username>` comme suit:  

```bash
printf "%s\n" '#!/bin/bash' > HelloUser.sh
printf "%s\n" 'echo "Hello $USER"' >> HelloUser.sh
```

et le lancer avec: `sbatch HelloUser.sh` qui est équivalent à `sbatch --export=ALL HelloUser.sh` (`ALL` étant la valeur par défaut).  

Par contre, si je créé une nouvelle variable, par exemple `MONNOM="John DOE"` et que je modifie mon script pour qu'il utilise cette nouvelle variable:  

```bash
printf "%s\n" '#!/bin/bash' > HelloUser.sh
printf "%s\n" 'echo "Hello $MONNOM"' >> HelloUser.sh
```

dans ce cas les différentes commandes `./HelloUser.sh` ou bien `sbatch HelloUser.sh` ou encore `sbatch --export=ALL HelloUser.sh` ne renvoient pas ce que je souhaite.  
Pour "passer" cette variable à mon script et lancer le script avec cette nouvelle variable, je dois écrire:  

```bash
MONNOM="John DOE" ./HelloUser.sh`  
```

Et avec sbatch, j'écrirai:

```bash
sbatch --export=MONNOM="John DOE" HelloUser.sh
```

Un autre exemple avec 2 variables:  

```bash
#Création du script:
printf "%s\n" '#!/bin/bash' > HelloUser.sh
printf "%s\n" 'echo "Hello $PRENOM $NOM"' >> HelloUser.sh

#lancement du script
sbatch --export=PRENOM="John",NOM="DOE" HelloUser.sh
```


Lorsqu'un job est lancé, [slurm](https://slurm.schedmd.com/) créé un certains nombres de variables qui commencent toutes par `SLURM_` et que nous pouvons utiliser dans nos scripts. Il n'est pas nécessaire des les exporter explicitement avec `--export=`, elles sont toujours exportées.    
Quelques variables qui peuvent être utiles:  

  - `SLURM_JOB_ID` contient le `<job_id>` qui a été assigné à notre job.  
  - `SLURM_CPUS_PER_TASK` contient le nombre de CPU alloué à chaque tâche et réglé à l'aide de l'option `--cpus-per-task=`  
  - `SLURM_ARRAY_TASK_ID` contient l'index ou ID du job array (voir ci-dessous)  
  




<br>

Il est 


<br>

## Incorporer les resources dans son script      

## Les jobs arrays    

# Suivi des jobs  




# Les données sont dans le fichier housing.csv avec la description trouvée dans AmesHousing.pdf.
#Il s’agit de s’assurer de la mise en forme des données sous la forme d’un tableau n × p, avec les individus
#en ligne et les variables en colonne. La préparation se fait par les taches suivantes :
#1. détecter la présence de données manquantes ; de valeurs éventuellement aberrantes ;
#2. s’assurer du type des différentes variables (quantitatives, qualitatives) ;
#3. définir une problématique, ou un ensemble de questions au vu de ces données ou selon les objectifs
#pour lesquels la base de données a été constituée ;
#4. proposer les méthodes d’analyse selon le probl`eme défini.
#L’ensemble de cette pré-analyse sera reporté dans la premi`ere partie du rapport, qui présentera donc les
#données (leur source notamment), et les objectifs. Celui-ci servira `a l’encadrant `a évaluer la faisabilité du
#projet.

# bibliotèque nécessaires


# 1. chargement des données
housing_data <- read.csv("housing.csv")
head(housing_data)
str(housing_data)

# 2. détecter la présence de données manquantes
missing_data_summary <- colSums(is.na(housing_data))
print("Résumé des données manquantes par variable :")
print(missing_data_summary)

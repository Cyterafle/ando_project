# Chargement des librairies
# Si non installées : install.packages(c("ggplot2", "corrplot", "FactoMineR", "factoextra"))
library(ggplot2)
library(corrplot)
library(FactoMineR)
library(factoextra)

# 1. Chargement et préparation des données
housing <- read.csv("housing.csv", stringsAsFactors = TRUE)

# Nettoyage : On retire les colonnes avec trop de valeurs manquantes (Misc_Feature, Mas_Vnr_Type)
housing$Misc_Feature <- NULL
housing$Mas_Vnr_Type <- NULL

# Suppression des lignes avec des valeurs manquantes restantes
df <- na.omit(housing)

# Vérification des doublons
df <- unique(df)

# On ne garde que les variables quantitatives pour l'analyse stats et l'ACP
# Sélection manuelle des variables pertinentes pour éviter les erreurs de type
vars_num <- c("Sale_Price", "Gr_Liv_Area", "Lot_Area", "Year_Built", "Total_Bsmt_SF", "Garage_Area")
df_num <- df[, vars_num]

# 2. Analyse Descriptive
# Univarié : Histogramme des prix
png("dist_prix.png")
hist(df$Sale_Price, main="Distribution des Prix de Vente", xlab="Prix ($)", col="lightblue")
dev.off()
print(summary(df$Sale_Price))

# Bivarié : Prix vs Surface Habitable
png("prix_vs_surface.png")
plot(df$Gr_Liv_Area, df$Sale_Price, main="Prix vs Surface Habitable", 
     xlab="Surface (sq ft)", ylab="Prix ($)", pch=19, col=rgb(0,0,1,0.5))
dev.off()

# Matrice de corrélation
M <- cor(df_num)
png("corr_matrix.png")
corrplot(M, method="color", type="upper", tl.col="black", tl.srt=45)
dev.off()

# 3. Analyse Factorielle (ACP)
# On centre et réduit les données. Graphiques automatiques.
res.pca <- PCA(df_num, graph = FALSE)

# Cercle des corrélations
png("acp_cercle.png")
fviz_pca_var(res.pca, col.var = "black", repel = TRUE)
dev.off()

# Projection des individus
png("acp_ind.png")
fviz_pca_ind(res.pca, geom = "point", col.ind = "cos2", gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"))
dev.off()

# 4. Modélisation (Régression Linéaire Simple)
# Modèle : Expliquer le prix par la surface habitable
model <- lm(Sale_Price ~ Gr_Liv_Area, data=df)
print(summary(model))

# Graphique de régression
png("regression.png")
plot(df$Gr_Liv_Area, df$Sale_Price, main="Régression Linéaire Simple", xlab="Surface", ylab="Prix")
abline(model, col="red", lwd=2)
dev.off()

# 5. Classification (Bonus : K-means)
# On cherche 3 groupes de maisons
set.seed(123)
df_scaled <- scale(df_num)
km.res <- kmeans(df_scaled, centers = 3, nstart = 25)

# Visualisation
png("clusters.png")
fviz_cluster(km.res, data = df_scaled, geom = "point", main="Classification K-means (3 groupes)")
dev.off()

# Moyennes par groupe pour interprétation
print(aggregate(df_num, by=list(cluster=km.res$cluster), mean))
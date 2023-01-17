library(CASdatasets)
library(ggplot2)
library(FactoMineR)
library(factoextra)
data(freMPL5)

freMPL5$Freq = ifelse(freMPL5$ClaimNbNonResp+freMPL5$ClaimNbResp+freMPL5$ClaimNbParking+freMPL5$ClaimNbFireTheft+freMPL5$ClaimNbWindscreen+freMPL5$OutUseNb > 0, 1, 0)

cout_moyen = mean(freMPL5$ClaimAmount)

summary(freMPL5)

x <- freMPL5[, c(1,2,9,11,12,13,14,15,16,17,18,19)]

y <- princomp(x, cor = FALSE, scores = TRUE)
y
#C'est une ACP sur les données quantitatives (on a ici considéré la zone
#comme faisant partie des variables quantitatives car c'est "possibly ordered")

x.pca <- PCA(x, scale.unit = TRUE)
x.pca


round(x.pca$var$coord,2)

y <- x.pca$eig
y
#premiere colonne correspond aux valeurs propres
#deuxieme colonne correspond aux valeurs propres divisées par la somme totales des valeurs propres
y[0:12,1]/sum(y[0:12,1])
#troisième colonne correspond aux valeurs de la 2nd colonne cumulées succesivement
#on arrive ainsi à 100% en bas de la 3eme colonne

#on cherche le nombre de valeurs propres à garder pour connaitre le nombre d'axe à etudier
fviz_eig(x.pca, addlabels = TRUE)
#les deux dernières valeurs apportent très peu de proportions sur la variance (<5%)
#on etudiera les 10 premières valeurs propres

var <- get_pca_var(x.pca)
#etude de la qualité de représentation
head(var$cos2)

